//
//  DownLoadWithDownLoadTask.h
//  DownLoadTest
//
//  Created by shenzhenshihua on 2016/11/16.
//  Copyright © 2016年 shenzhenshihua. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DownLoadWithDownLoadTask : NSObject

@property(nonatomic,copy)void(^block)(NSData *data,NSString*path);


+ (id)downLoadWithBlock:(void(^)(NSData *data,NSString *path))black;

@end
