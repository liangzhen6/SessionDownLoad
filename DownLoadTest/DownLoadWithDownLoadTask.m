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


@end

@implementation DownLoadWithDownLoadTask

+ (id)downLoadWithBlock:(void(^)(NSData *data,NSString *path))black{
    DownLoadWithDownLoadTask * task = [[DownLoadWithDownLoadTask alloc] init];
    
    black  = task.block;
    
    [task start];
    return task;
}


- (void)start{

    self.session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:self delegateQueue:[[NSOperationQueue alloc] init]];
    
    NSURL * Url = [NSURL URLWithString:@"https://framework.realtime.co/blog/img/ios10-video.mp4"];
    
    self.downloadTask = [self.session downloadTaskWithURL:Url];
    
    [self.downloadTask resume];


}


// 每次写入调用(会调用多次)
- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didWriteData:(int64_t)bytesWritten totalBytesWritten:(int64_t)totalBytesWritten totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite {
    // 可在这里通过已写入的长度和总长度算出下载进度

    float progress = 1.0 * totalBytesWritten / totalBytesExpectedToWrite;
    NSLog(@"%f-----%lld----%lld----%lld",progress,totalBytesWritten,totalBytesExpectedToWrite,bytesWritten);
    
}

// 下载完成调用
- (void)URLSession:(NSURLSession *)session
      downloadTask:(NSURLSessionDownloadTask *)downloadTask
didFinishDownloadingToURL:(NSURL *)location {
    // location还是一个临时路径,需要自己挪到需要的路径(caches下面)
    NSString *filePath = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:downloadTask.response.suggestedFilename];
    [[NSFileManager defaultManager] moveItemAtURL:location toURL:[NSURL fileURLWithPath:filePath] error:nil];
}

// 任务完成调用
- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error {
    
    if (error) {
        // 保存恢复数据
        self.resumeData = error.userInfo[NSURLSessionDownloadTaskResumeData];
    }
    
    
}






@end
