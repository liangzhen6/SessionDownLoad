//
//  DownLoadWithDownLoadTask.m
//  DownLoadTest
//
//  Created by shenzhenshihua on 2016/11/16.
//  Copyright © 2016年 shenzhenshihua. All rights reserved.
//

#import "DownLoadWithDownLoadTask.h"

@interface DownLoadWithDownLoadTask()<NSURLSessionDownloadDelegate>

@property(nonatomic,strong)NSURLSession * session;

@property(nonatomic,strong)NSURLSessionDownloadTask * downloadTask;

@property(nonatomic,strong)NSData *resumeData;

@property(nonatomic,strong)NSOperationQueue * operationQueue;

@property(nonatomic,strong)NSString * urlStr;


@end

@implementation DownLoadWithDownLoadTask

+ (id)downLoadWithBlock:(void(^)(NSData *data,NSString *path))black{
    DownLoadWithDownLoadTask * task = [[DownLoadWithDownLoadTask alloc] init];
    
    black  = task.block;
    
//    [task start];
    return task;
}


+ (id)downLoadWithOperationQueue:(NSOperationQueue *)queue andUrlStr:(NSString *)url{
    DownLoadWithDownLoadTask * task = [[DownLoadWithDownLoadTask alloc] init];
    task.operationQueue = queue;
    task.urlStr = url;
    
    return task;
}

- (NSURLSession *)session{

    if (_session==nil) {
        _session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:self delegateQueue:self.operationQueue];
    }
    return _session;
}

- (NSURLSessionDownloadTask *)downloadTask{
    if (_downloadTask==nil) {
        _downloadTask = [self.session downloadTaskWithURL:[NSURL URLWithString:self.urlStr]];
    }
    return _downloadTask;
}

///**
// 开始下载
// */
//- (void)start{
//   
//    [self.downloadTask resume];
//
//}

- (void)cancel{
    [self.downloadTask cancelByProducingResumeData:^(NSData * _Nullable resumeData) {
        self.resumeData = resumeData;
    }];
    //变成暂停
    self.downloadState = DownloadTaskCancel;
}

- (void)suspend{
    [self.downloadTask suspend];
    
    //变成暂停
    self.downloadState = DownloadTaskSuspend;

}

- (void)resume{
    
//    [self.session downloadTaskWithResumeData:self.resumeData];
    if (self.resumeData) {
        self.downloadTask = [self.session downloadTaskWithResumeData:self.resumeData];
    }
    
    [self.downloadTask resume];
    //变成正在下载
    self.downloadState = DownloadTaskLoading;

}



// 每次写入调用(会调用多次)
- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didWriteData:(int64_t)bytesWritten totalBytesWritten:(int64_t)totalBytesWritten totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite {
    // 可在这里通过已写入的长度和总长度算出下载进度
//    NSLog(@"%@",session);

    float progress = 1.0 * totalBytesWritten / totalBytesExpectedToWrite;
    self.progress = progress;
    if ([self.delegate respondsToSelector:@selector(changeDownloadProgress:andDownloadTask:)]) {
        [self.delegate changeDownloadProgress:progress andDownloadTask:self];
    }
    NSLog(@"%f-----%lld----%lld----%lld",progress,totalBytesWritten,totalBytesExpectedToWrite,bytesWritten);
    
}

// 下载完成调用
- (void)URLSession:(NSURLSession *)session
      downloadTask:(NSURLSessionDownloadTask *)downloadTask
didFinishDownloadingToURL:(NSURL *)location {
    // location还是一个临时路径,需要自己挪到需要的路径(caches下面)
    /*
     po location
     file:///Users/szsh/Library/Developer/CoreSimulator/Devices/1BE73346-FC53-4089-96AF-C246FC3D59B1/data/Containers/Data/Application/4913DCEF-592F-4FA0-B8B5-283D5044F116/tmp/CFNetworkDownload_CBN05P.tmp
     
     (lldb) po filePath
     /Users/szsh/Library/Developer/CoreSimulator/Devices/1BE73346-FC53-4089-96AF-C246FC3D59B1/data/Containers/Data/Application/4913DCEF-592F-4FA0-B8B5-283D5044F116/Library/Caches/ios10-video.mp4
     */
    
    NSString *filePath = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:downloadTask.response.suggestedFilename];
    [[NSFileManager defaultManager] moveItemAtURL:location toURL:[NSURL fileURLWithPath:filePath] error:nil];
}

// 任务完成调用
- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error {
    
    if (error) {
        // 保存恢复数据
        self.resumeData = error.userInfo[NSURLSessionDownloadTaskResumeData];
        //变成失败 可恢复下载
        self.downloadState = DownloadTaskFailure;
    }else{
    //任务完成
        self.downloadState = DownloadTaskFinshed;
    
    }
    
    
}






@end
