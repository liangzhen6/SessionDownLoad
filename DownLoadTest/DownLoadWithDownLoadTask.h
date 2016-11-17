//
//  DownLoadWithDownLoadTask.h
//  DownLoadTest
//
//  Created by shenzhenshihua on 2016/11/16.
//  Copyright © 2016年 shenzhenshihua. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger,DownloadTaskState) {
    
     DownloadTaskWating = 0,
    
     DownloadTaskLoading,
    
     DownloadTaskFinshed,
    
     DownloadTaskCancel,
    
     DownloadTaskSuspend,
    
     DownloadTaskFailure
    
};

@protocol DownLoadWithDownLoadTaskDelegate <NSObject>

- (void)changeDownloadProgress:(float)progress;


@end

@interface DownLoadWithDownLoadTask : NSObject

@property(nonatomic,assign)DownloadTaskState downloadState;

@property(nonatomic,assign)id <DownLoadWithDownLoadTaskDelegate>delegate;


@property(nonatomic,copy)void(^block)(NSData *data,NSString*path);


+ (id)downLoadWithBlock:(void(^)(NSData *data,NSString *path))black;

+ (id)downLoadWithOperationQueue:(NSOperationQueue *)queue andUrlStr:(NSString *)url;

//- (void)start;

- (void)cancel;

- (void)suspend;

- (void)resume;

@end
