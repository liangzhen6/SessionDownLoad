//
//  DownloadManger.m
//  DownLoadTest
//
//  Created by shenzhenshihua on 2016/11/17.
//  Copyright © 2016年 shenzhenshihua. All rights reserved.
//

#import "DownloadManger.h"
#import "DownLoadWithDownLoadTask.h"
#import "DownloadCell.h"
#import "DownloadModel.h"
#import <LZProgressView.h>


@interface DownloadManger()<DownLoadWithDownLoadTaskDelegate>
@property(nonatomic,strong)DownloadCell * loadingCell;
@property(nonatomic,getter=isLoading)BOOL loading;

@end

@implementation DownloadManger

+ (DownloadManger *)shareMager{
    static DownloadManger * maner;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        maner = [[DownloadManger alloc] init];
    });

    return maner;
}

- (NSMutableArray *)tasks{
    if (_tasks==nil) {
        _tasks = [[NSMutableArray array] init];
    }
    return _tasks;
}


- (NSOperationQueue *)operationQueue{
    if (_operationQueue==nil) {
        _operationQueue = [[NSOperationQueue alloc] init];
        _operationQueue.maxConcurrentOperationCount = 1;
    }

    return _operationQueue;
}

- (void)startDownload{

    for (int i; i<self.tasks.count; i++) {
      DownLoadWithDownLoadTask * task = self.tasks[i];
        if (task.downloadState==DownloadTaskSuspend) {
            task.delegate = self;
            [task resume];
            return;
        }
        
    }
    
    for (int i; i<self.tasks.count; i++) {
        DownLoadWithDownLoadTask * task = self.tasks[i];
        if (task.downloadState==DownloadTaskWating) {
            task.delegate = self;
            [task resume];
            return;
        }
        
    }

    
    

}


- (void)changeDownloadProgress:(float)progress andDownloadTask:(DownLoadWithDownLoadTask *)task{

    NSIndexPath * path = [NSIndexPath indexPathForRow:task.tag inSection:0];
    self.loadingCell = [self.beMangerView cellForRowAtIndexPath:path];
    NSLog(@"%ld",(long)task.tag);
    //刷新进度条
    if (self.loadingCell) {
        dispatch_sync(dispatch_get_main_queue(), ^{
            self.loadingCell.progress.progress = progress;
        });
    }
    


}




- (void)changeDownloadWithDownloadModel:(DownloadModel *)model{
    if (model.task) {//已经在下载队列了
        switch (model.downloadWillState) {
            case DownloadTaskWillChangeLoading:
            {//将要继续下载
            
                [model.task resume];
            
            }
                break;
            case DownloadTaskWillChangeSuspend:
            {//将要暂停
                
                [model.task suspend];
                
            }
                break;
                
            default:
                break;
        }
        
        
    }else{//还未在下载队列
      DownLoadWithDownLoadTask * task = [DownLoadWithDownLoadTask downLoadWithOperationQueue:self.operationQueue andUrlStr:model.urlStr];
        [task addObserver:self forKeyPath:@"downloadState" options:NSKeyValueObservingOptionNew context:nil];
        task.delegate = self;
        task.tag = model.tagNum;
        model.task = task;
        [self.tasks addObject:model];
        [task resume];
//        if (!self.loading) {
//            [task resume];
//            self.loading = !self.loading;
//        }
    }


}


- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
//获取住线程刷新UI
    if ([[NSThread currentThread] isMainThread]) {
        [self.beMangerView reloadData];
    }else{
    dispatch_sync(dispatch_get_main_queue(), ^{
        [self.beMangerView reloadData];
    });
    }

}


//- (void)dealloc{
//
//    [self remoa];
//
//}



@end
