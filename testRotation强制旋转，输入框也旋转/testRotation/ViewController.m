//
//  ViewController.m
//  testRotation
//
//  Created by jiangbao on 2020/5/14.
//  Copyright © 2020 jiangbao. All rights reserved.
//  强制

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

@end
