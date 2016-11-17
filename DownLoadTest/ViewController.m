//
//  ViewController.m
//  DownLoadTest
//
//  Created by shenzhenshihua on 2016/11/15.
//  Copyright © 2016年 shenzhenshihua. All rights reserved.
//

#import "ViewController.h"
#import "DownLoad.h"
//#import <MediaPlayer/MediaPlayer.h>
#import <AVFoundation/AVFoundation.h>
#import <AVKit/AVKit.h>
#import "DownLoadWithDownLoadTask.h"
#import "DownloadCell.h"
#import "DownloadModel.h"
#import "DownloadManger.h"

@interface ViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)NSString * path;
@property (nonatomic,strong)AVPlayer *player;

@property(nonatomic,strong)DownLoadWithDownLoadTask * task;

@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)NSMutableArray * dataSource;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initTableView];
    [self initData];
//    [self initTask];

}


- (void)initData{

    
    NSArray * arr = @[@"https://framework.realtime.co/blog/img/ios10-video.mp4",@"https://framework.realtime.co/blog/img/ios10-video.mp4",@"https://framework.realtime.co/blog/img/ios10-video.mp4",@"https://framework.realtime.co/blog/img/ios10-video.mp4",@"https://framework.realtime.co/blog/img/ios10-video.mp4",@"https://framework.realtime.co/blog/img/ios10-video.mp4",@"https://framework.realtime.co/blog/img/ios10-video.mp4",@"https://framework.realtime.co/blog/img/ios10-video.mp4",@"https://framework.realtime.co/blog/img/ios10-video.mp4",@"https://framework.realtime.co/blog/img/ios10-video.mp4",@"https://framework.realtime.co/blog/img/ios10-video.mp4",@"https://framework.realtime.co/blog/img/ios10-video.mp4",@"https://framework.realtime.co/blog/img/ios10-video.mp4",@"https://framework.realtime.co/blog/img/ios10-video.mp4",@"https://framework.realtime.co/blog/img/ios10-video.mp4"];
    DownloadManger * maner = [DownloadManger shareMager];
    for (int i = 0; i<arr.count; i++) {
        NSString * str = arr[i];
        DownLoadWithDownLoadTask * task = [DownLoadWithDownLoadTask downLoadWithOperationQueue:maner.operationQueue andUrlStr:str];
        [maner.tasks addObject:task];

        DownloadModel * model = [[DownloadModel alloc] init];
        model.urlStr = str;
        model.task = task;
        task.tag = i;
        [self.dataSource addObject:model];
        
        if (i==0) {
            [task resume];
        }
        
    }
    
    [self.tableView reloadData];
    

}

- (void)initTableView{

    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    [self.view addSubview:self.tableView];


}

- (NSMutableArray *)dataSource{
    if (_dataSource==nil) {
        _dataSource = [[NSMutableArray array] init];
    }
    return _dataSource;
}



#pragma mark  delegate


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return self.dataSource.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 100;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
 static NSString * reUseId = @"cell";
    DownloadCell * cell = [tableView dequeueReusableCellWithIdentifier:reUseId];
    if (cell==nil) {
        cell = [[DownloadCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reUseId];
    }

    cell.model = _dataSource[indexPath.row];
    
    return  cell;

}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{


}










- (void)initTask{
     _task= [DownLoadWithDownLoadTask downLoadWithOperationQueue:[[NSOperationQueue alloc] init] andUrlStr:@"https://framework.realtime.co/blog/img/ios10-video.mp4"];
    NSArray * titles = @[@"开始",@"继续",@"取消",@"暂停"];
    for (int i = 0; i<4; i++) {
        UIButton * btn = [[UIButton alloc] initWithFrame:CGRectMake(10, 20+i*60, 100, 40)];
        btn.backgroundColor = [UIColor blackColor];
        [self.view addSubview:btn];
        btn.tag = i;
        [btn setTitle:titles[i] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
        
    }


}



- (void)btnAction:(UIButton *)btn{
    switch (btn.tag) {
        case 0:
        {//开始
//            [_task start];
        
        }
            break;
        case 1:
        {//继续
            [_task resume];
            
        }
            break;
        case 2:
        {//取消
            [_task cancel];
            
        }
            break;
        case 3:
        {//暂停
            [_task suspend];
            
        }
            break;

        default:
            break;
    }



}






//- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
//// [self.player play];
//    
//    if (_path) {
//        NSDictionary * dict = @{ @"ChaosFileURL":@"0"};
//        [dict writeToFile:_path atomically:YES];
//        
//        NSDictionary * dic = [NSDictionary dictionaryWithContentsOfFile:_path];
//        NSLog(@"%@",dic);
//    }
//
//    [self reload];
//}

/*

 [DownLoad downLoadWithBlock:^(NSData *data, NSString *path) {
 //        self.player = [[AVPlayer alloc] initWithPlayerItem:[[AVPlayerItem alloc]initWithURL:[NSURL URLWithString:@"https://framework.realtime.co/blog/img/ios10-video.mp4"]]];
 if ([[NSThread currentThread] isMainThread]) {
 self.player = [[AVPlayer alloc] initWithURL:[NSURL fileURLWithPath:path]];
 //设置播放页面
 AVPlayerLayer *layer = [AVPlayerLayer playerLayerWithPlayer:_player];
 //设置播放页面的大小
 layer.frame = self.view.bounds;
 layer.backgroundColor = [UIColor cyanColor].CGColor;
 //设置播放窗口和当前视图之间的比例显示内容
 layer.videoGravity = AVLayerVideoGravityResizeAspect;
 //添加播放视图到self.view
 [self.view.layer addSublayer:layer];
 
 }else{
 
 dispatch_sync(dispatch_get_main_queue(), ^{
 
 self.player = [[AVPlayer alloc] initWithURL:[NSURL fileURLWithPath:path]];
 //设置播放页面
 AVPlayerLayer *layer = [AVPlayerLayer playerLayerWithPlayer:_player];
 //设置播放页面的大小
 layer.frame = self.view.bounds;
 layer.backgroundColor = [UIColor cyanColor].CGColor;
 //设置播放窗口和当前视图之间的比例显示内容
 layer.videoGravity = AVLayerVideoGravityResizeAspect;
 //添加播放视图到self.view
 [self.view.layer addSublayer:layer];
 
 });
 
 
 }
 }];



//    [self reload];





//    DownLoad * down = [[DownLoad alloc] init];
//
//    [down start];
// Do any additional setup after loading the view, typically from a nib.
 */

- (void)reload{
    UIImageView * imageView = [[UIImageView alloc] initWithFrame:self.view.bounds];
    //    imageView.backgroundColor = [UIColor yellowColor];
    [self.view addSubview:imageView];
    
    [DownLoad downLoadWithBlock:^(NSData *data, NSString *path) {
        self.path = path;
        UIImage * image = [UIImage imageWithData:data];
        if ([[NSThread currentThread] isMainThread]) {
            imageView.image = image;
        }else{
            dispatch_sync(dispatch_get_main_queue(), ^{
                
                imageView.image = image;
                
            });
        }
        
        //        UIImage * Image = [[UIImage alloc] initWithContentsOfFile:path];
        NSLog(@"%@",image);
        
    }];

}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
    NSLog(@"内存警告");
    // Dispose of any resources that can be recreated.
}


@end
