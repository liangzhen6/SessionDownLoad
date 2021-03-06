//
//  DownloadModel.h
//  DownLoadTest
//
//  Created by shenzhenshihua on 2016/11/17.
//  Copyright © 2016年 shenzhenshihua. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger,DownloadTaskWillChangeState) {
    
    DownloadTaskWillChangeWating = 0,
    
    DownloadTaskWillChangeLoading,
    
    DownloadTaskWillChangeCancel,
    
    DownloadTaskWillChangeSuspend
    
};

@class DownLoadWithDownLoadTask;
@interface DownloadModel : NSObject

@property(nonatomic,strong)NSString * urlStr;
@property(nonatomic,strong)DownLoadWithDownLoadTask * task;
@property(nonatomic,assign)float downloadProgress;

@property(nonatomic,assign)NSInteger tagNum;

@property(nonatomic,assign)DownloadTaskWillChangeState downloadWillState;


@end
