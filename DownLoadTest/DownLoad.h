//
//  DownLoad.h
//  DownLoadTest
//
//  Created by shenzhenshihua on 2016/11/15.
//  Copyright © 2016年 shenzhenshihua. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DownLoad : NSObject

- (void)start;

@property(nonatomic,copy)void(^block)(NSData *data,NSString*path);


+ (id)downLoadWithBlock:(void(^)(NSData *data,NSString *path))black;

@end
