//
//  DownloadManger.m
//  DownLoadTest
//
//  Created by shenzhenshihua on 2016/11/17.
//  Copyright © 2016年 shenzhenshihua. All rights reserved.
//

#import "DownloadManger.h"


@interface DownloadManger()

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




@end
