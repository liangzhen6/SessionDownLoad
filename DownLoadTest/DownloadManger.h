//
//  DownloadManger.h
//  DownLoadTest
//
//  Created by shenzhenshihua on 2016/11/17.
//  Copyright © 2016年 shenzhenshihua. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "DownLoadWithDownLoadTask.h"
//@class DownLoadWithDownLoadTask;
@class DownloadModel;
@interface DownloadManger : NSObject

@property(nonatomic,strong)NSMutableArray *tasks;

@property(nonatomic,strong)NSOperationQueue * operationQueue;

@property(nonatomic,strong)UITableView * beMangerView;


+ (DownloadManger *)shareMager;


- (void)startDownload;


- (void)changeDownloadWithDownloadModel:(DownloadModel *)model;


@end
