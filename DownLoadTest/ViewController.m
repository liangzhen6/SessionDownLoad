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
@interface ViewController ()
@property(nonatomic,strong)NSString * path;
@property (nonatomic,strong)AVPlayer *player;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    

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
     */
    
  [DownLoadWithDownLoadTask downLoadWithBlock:^(NSData *data, NSString *path) {
      
  }];

//    [self reload];
   
                   

                   
    
//    DownLoad * down = [[DownLoad alloc] init];
//
//    [down start];
    // Do any additional setup after loading the view, typically from a nib.
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
// [self.player play];
    
    if (_path) {
        NSDictionary * dict = @{ @"ChaosFileURL":@"0"};
        [dict writeToFile:_path atomically:YES];
        
        NSDictionary * dic = [NSDictionary dictionaryWithContentsOfFile:_path];
        NSLog(@"%@",dic);
    }

    [self reload];
}



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
