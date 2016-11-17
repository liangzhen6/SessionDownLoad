//
//  DownloadManger.h
//  DownLoadTest
//
//  Created by shenzhenshihua on 2016/11/17.
//  Copyright © 2016年 shenzhenshihua. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DownloadManger : NSObject

@property(nonatomic,strong)NSMutableArray *tasks;

@property(nonatomic,strong)NSOperationQueue * operationQueue;

+ (DownloadManger *)shareMager;


@end
