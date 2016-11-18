//
//  DownloadCell.h
//  DownLoadTest
//
//  Created by shenzhenshihua on 2016/11/17.
//  Copyright © 2016年 shenzhenshihua. All rights reserved.
//

#import <UIKit/UIKit.h>
@class DownloadModel;
@interface DownloadCell : UITableViewCell

@property(nonatomic,strong)DownloadModel * model;

@property(nonatomic,strong)UIProgressView *progress;

@property(nonatomic,copy)void(^block)(DownloadModel *model);

@end
