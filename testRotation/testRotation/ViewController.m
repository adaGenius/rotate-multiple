//
//  ViewController.m
//  testRotation
//
//  Created by jiangbao on 2020/5/14.
//  Copyright © 2020 jiangbao. All rights reserved.
//

#import "ViewController.h"
#import "ADAPlayerView.h"
#import "AppDelegate.h"

#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height

@interface ViewController ()


@property (nonatomic,strong) ADAPlayerView *player;
@property (nonatomic,strong) UIView *backView;


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupView];
    
}
- (void)setupView {
    [self.view addSubview:self.backView];
    [self.backView addSubview:self.player];
    [self.player.orientationObserver updateRotateView:self.player containerView:self.backView];
     //((AppDelegate*)[[UIApplication sharedApplication] delegate]).allowOrentitaionRotation = YES;
}
-(ADAPlayerView *)player {
    if (!_player) {
        _player = [[ADAPlayerView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 260)];
    }
    return _player;
}
-(UIView *)backView {
    if (!_backView) {
        _backView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 260)];
    }
    return _backView;
}
 //Interface的方向是否会跟随设备方向自动旋转，如果返回NO,后两个方法不会再调用
// - (BOOL)shouldAutorotate {
//     return YES;
// }
// //返回直接支持的方向
// - (UIInterfaceOrientationMask)supportedInterfaceOrientations{
//     return UIInterfaceOrientationMaskAllButUpsideDown;
// }

@end
