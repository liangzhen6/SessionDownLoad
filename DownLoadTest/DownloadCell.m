//
//  DownloadCell.m
//  DownLoadTest
//
//  Created by shenzhenshihua on 2016/11/17.
//  Copyright © 2016年 shenzhenshihua. All rights reserved.
//

#import "DownloadCell.h"
#import "DownloadModel.h"
#import "DownLoadWithDownLoadTask.h"
@interface DownloadCell()<DownLoadWithDownLoadTaskDelegate>

@property(nonatomic,strong)UIProgressView *progress;

@property(nonatomic,getter=isLoading)BOOL loading;

@property(nonatomic,strong)UIButton * btn;

@end


@implementation DownloadCell


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initView];
    }
    return self;
}


- (void)initView{
    self.progress = [[UIProgressView alloc] initWithFrame:CGRectMake(5, 20, Screen_Width-100, 30)];
//    self.progress.trackTintColor = [UIColor blackColor];
//    self.progress.progressViewStyle =
//    self.progress.progress = 1.0;
    
    self.progress.progressTintColor=[UIColor redColor];
    [self.contentView addSubview:self.progress];
    
    self.btn = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.progress.frame)+5, CGRectGetMidY(self.progress.frame)+5, 70, 40)];
    
    _btn.backgroundColor = [UIColor redColor];
    [_btn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:_btn];
    
    [_btn setTitle:@"waiting" forState:UIControlStateNormal];
    [_btn setTitle:@"loading" forState:UIControlStateSelected];
    _btn.selected = NO;
    
    
    

}


- (void)btnAction:(UIButton *)btn{
    _btn.selected = !_btn.selected;
    if (_btn.selected) {
        [self.model.task resume];
    }else{
        [self.model.task suspend];
    }
    
}


- (void)setModel:(DownloadModel *)model{
    _model = model;
    
    model.task.delegate = self;
    
    if (model.task.downloadState==DownloadTaskLoading) {
        _btn.selected = YES;
    }else{
        _btn.selected = NO;
        self.progress.progress = 0;
    }
    
    self.progress.progress = model.downloadProgress;

    

}


- (void)changeDownloadProgress:(float)progress{
    self.model.downloadProgress = progress;

    dispatch_sync(dispatch_get_main_queue(), ^{
        self.progress.progress = progress;
    });
//    [self.progress setProgress:progress animated:NO];


}


- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    

    // Configure the view for the selected state
}

@end
