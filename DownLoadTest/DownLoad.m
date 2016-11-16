//
//  DownLoad.m
//  DownLoadTest
//
//  Created by shenzhenshihua on 2016/11/15.
//  Copyright © 2016年 shenzhenshihua. All rights reserved.
//

#import "DownLoad.h"

@interface DownLoad()<NSURLSessionDataDelegate>
//@property(nonatomic,strong)NSURLSessionDownloadTask * task;

@property(nonatomic,strong) NSURLSessionDataTask *task;

@property(nonatomic,strong)NSURLSession * session;

@property(nonatomic,strong)NSData * resumeData;


@property(nonatomic,assign)NSInteger totalLength;

@property(nonatomic,assign)NSInteger downloadLength;

@property(nonatomic,strong) NSOutputStream *stream;

@property(nonatomic,strong)NSMutableData * allData;

@property(nonatomic,strong)NSTimer * timer;
// 根据文件唯一的URL MD5值 作为文件名
#define ChaosFileName @"ChaosFileURL"

// 用来存储文件总长度的plist文件 key:文件名的MD5值 value:文件总长度
#define ChaosDownloadFilesPlist [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"downloadFiles.plist"]
// 下载文件的全路径
#define ChaosFileFullPath [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:ChaosFileName]
// 已经下载的文件长度
#define ChaosDownloadLength [[[NSFileManager defaultManager] attributesOfItemAtPath:ChaosFileFullPath error:nil][@"NSFileSize"] integerValue]



@end


@implementation DownLoad

+ (id)downLoadWithBlock:(void(^)(NSData *data,NSString *path))black{
    DownLoad * down = [[DownLoad alloc] init];
    down.block = black;

    [down start];
    
    return down;

}
- (NSURLSession *)session
{
    if (!_session) {
        NSURLSessionConfiguration * cfg = [NSURLSessionConfiguration defaultSessionConfiguration];
        _session = [NSURLSession sessionWithConfiguration:cfg delegate:self delegateQueue:[[NSOperationQueue alloc] init]];
        
    }

    return _session;
}


- (void)start
{
//    NSURL *url = [NSURL URLWithString:@"http://192.168.1.110:8080/Server/resources"];
//    self.task = [self.session downloadTaskWithURL:url];
    self.allData = [[NSMutableData alloc] init];
    // 2.开始任务
    [self.task resume];

}

- (NSURLSessionDataTask *)task
{
    if (!_task) {
        NSInteger totalLength = [[NSDictionary dictionaryWithContentsOfFile:ChaosDownloadFilesPlist][ChaosFileName] integerValue];
        // 请求同一个文件，判断下载文件长度；如果没下载过此文件，totalLength = 0
        if (totalLength && ChaosDownloadLength == totalLength) {
                NSLog(@"文件已经下载过.");
            if (self.block) {
//                self.block =^(NSData * data,NSString *path){
                  NSData*  data = [NSData dataWithContentsOfFile:ChaosFileFullPath];
                   NSString * path = ChaosDownloadFilesPlist;
//
//                };
                
                self.block(data,path);
            }

                return nil;
        }
        
        //https://framework.realtime.co/blog/img/ios10-video.mp4  http://image52.360doc.com/DownloadImg/2012/06/0316/24581213_3.jpg
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"http://image52.360doc.com/DownloadImg/2012/06/0316/24581213_3.jpg"]];

       // 设置请求头 -- range 这次从哪里开始请求数据 格式：bytes=***-***（从指定开始到指定结束）  或者：bytes=***-（从指定位置到结束）
       NSString *range = [NSString stringWithFormat:@"bytes=%zd-",ChaosDownloadLength];

       [request setValue:range forHTTPHeaderField:@"Range"];

       _task = [self.session dataTaskWithRequest:request];
        
    }

    return _task;
}

/**
 暂停
 */
- (void)pause
{
    /*
      3124762---0
     
     哈哈哈687602
     0.214806
     
     */

    [self.task suspend];

}

#pragma mark - <NSURLSessionDataDelegate>

/**
 接收到响应才能调用

 @param session <#session description#>
 @param dataTask <#dataTask description#>
 @param response <#response description#>
 @param completionHandler <#completionHandler description#>
 */
/*
- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveResponse:(NSURLResponse *)response completionHandler:(void (^)(NSURLSessionResponseDisposition))completionHandler{
   //调用block才能接受数据
    completionHandler(NSURLSessionResponseAllow);
    // 初始化stream
    self.stream = [NSOutputStream outputStreamToFileAtPath:ChaosFileFullPath append:YES];

    self.totalLength = [response.allHeaderFields[@"Content-Length"] integerValue] + ChaosDownloadLength;

}
*/


- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveResponse:(NSHTTPURLResponse *)response completionHandler:(void (^)(NSURLSessionResponseDisposition))completionHandler{
    
    //调用block才能接受数据
    completionHandler(NSURLSessionResponseAllow);
    // 初始化stream    NSURLSessionResponseAllow
    self.stream = [NSOutputStream outputStreamToFileAtPath:ChaosFileFullPath append:YES];
    
    [self.stream open];
    
    self.totalLength = [response.allHeaderFields[@"Content-Length"] integerValue] + ChaosDownloadLength;
    
    NSLog(@"%ld---%ld",(long)self.totalLength,ChaosDownloadLength);
    // 接收到服务器响应的时候存储文件的总长度到plist,实现多文件下载，先取出字典，给字典赋值最后写入。
    // 错误做法：直接写入文件，会用这次写入的信息覆盖原来所有的信息
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithContentsOfFile:ChaosDownloadFilesPlist];
    // 字典可能为空
    if (dict == nil) dict = [NSMutableDictionary dictionary];
    // 写入文件
    dict[ChaosFileName] = @(self.totalLength);
    [dict writeToFile:ChaosDownloadFilesPlist atomically:YES];

    
}


/**
6  * 接收到服务器发来的数据的时候调用 -- 有可能调用多次
7  */
 - (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveData:(NSData *)data
 {
//     NSLog(@"写入前的进度%f",1.0 * self.downloadLength / self.totalLength);
      // 写入数据  写入数据流
      [self.stream write:[data bytes] maxLength:data.length];
     
      // 获取已经下载的长度
      self.downloadLength = ChaosDownloadLength;
     
     [self.allData appendData:data];
     NSLog(@"哈哈哈%lu",(unsigned long)self.allData.length);
     
//     [[@"NSFileSize"] integerValue];
      // 计算进度
      NSLog(@"%f",1.0 * self.downloadLength / self.totalLength);
    
 
 }

/**
   * 任务完成的时候调用
   */
- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error
{
    NSLog(@"----finish---%ld",(long)self.downloadLength);
    
    self.timer = [NSTimer scheduledTimerWithTimeInterval:0.1 repeats:YES block:^(NSTimer * _Nonnull timer) {
        NSLog(@"%@",self.timer);
        if (self.downloadLength==self.totalLength) {
            //下载完成
            if (self.block) {
                //        self.block =^(NSData * data,NSString *path){
                //            data = [NSData dataWithContentsOfFile:ChaosFileFullPath];
                //            path = ChaosFileFullPath;
                //
                //        };
                
                NSData*  data = [NSData dataWithContentsOfFile:ChaosFileFullPath];
                NSString * path = ChaosDownloadFilesPlist;
                NSLog(@"%lu---",(unsigned long)data.length);
                self.block(data,path);
                
                
            }
            [self.stream close];
            self.stream = nil;
            
            
            // 一个任务对应一个文件，用完清空
            self.task = nil;
            
            if ([self.timer isValid]) {
                [self.timer invalidate];
                self.timer=nil;
            }
        }

    }];
    [self.timer fireDate];
    [[NSRunLoop currentRunLoop] run];
    
//    [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSDefaultRunLoopMode];
    
    
   

    

}


//- (void)resume
//{
//    
//    // 传入上次暂停下载返回的数据，就可以恢复下载
//    self.task = [self.session downloadTaskWithResumeData:self.resumeData];
//    // 开始任务
//    [self.task resume];
//    
//    // 清空
//    self.resumeData = nil;
//
//}
//
//- (void)pause
//{
//    
//   [self.task cancelByProducingResumeData:^(NSData * _Nullable resumeData) {
//       self.resumeData = resumeData;
//   }];
//
//}


@end
