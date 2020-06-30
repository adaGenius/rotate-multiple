//
//  ViewController.m
//  rotate
//
//  Created by jiangbao on 2020/4/20.
//  Copyright © 2020 jiangbao. All rights reserved.
//

#import "ViewController.h"
#import "SDAutoLayout/SDAutoLayout.h"
#define SCREEN_WIDTH  [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT  [UIScreen mainScreen].bounds.size.height

@interface ViewController ()

@property (nonatomic, strong)UIButton * btn;
@property (nonatomic, strong) UIView *DisplayView;//播放器界面范围
@end

@implementation ViewController
- (void)dealloc
{
    [self removeDeviceOrientationObserver];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"hello world!");
    [self setupView];
    //监听屏幕旋转方向
    [self startDeviceOrientationObserver];
}
- (void)setupView {
    self.view.backgroundColor = [UIColor orangeColor];
    
    _DisplayView = [[UIView alloc]init];
    _DisplayView.backgroundColor = [UIColor cyanColor];
    [self.view sd_addSubviews:@[_DisplayView]];
    //竖屏的约束
    _DisplayView.sd_layout
    .topSpaceToView(self.view, 44)
    .leftEqualToView(self.view)
    .widthIs(SCREEN_WIDTH)
    .heightIs(SCREEN_WIDTH * 0.625);
    
    _btn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 80, 50)];
    _btn.backgroundColor =  [UIColor redColor];
    [_DisplayView addSubview:_btn];
    [_btn addTarget:self action:@selector(btnAction:) forControlEvents:(UIControlEventTouchUpInside)];
    _btn.sd_layout
    .bottomEqualToView(_DisplayView)
    .rightEqualToView(_DisplayView)
    .widthIs(80)
    .heightIs(50);
}
- (void)btnAction:(UIButton *)sender {
    sender.selected =!sender.selected;
    [self rotateToProtrait:sender.selected];
}

#pragma mark 旋转方法
- (void)rotateToProtrait:(BOOL)protrait {
    UIInterfaceOrientationMask orientationMask = protrait ? UIInterfaceOrientationMaskPortrait : UIInterfaceOrientationMaskLandscapeRight;
    [[NSNotificationCenter defaultCenter] postNotificationName:@"IMSOrientationChangeNotification" object:nil userInfo:@{@"orientation":@(orientationMask)}];
    UIDeviceOrientation orientation = protrait ? UIDeviceOrientationPortrait : UIDeviceOrientationLandscapeLeft;
    NSNumber *orientationUnknown = [NSNumber numberWithInt:UIInterfaceOrientationUnknown];
    [[UIDevice currentDevice] setValue:orientationUnknown forKey:@"orientation"];
    NSNumber *orientationTarget = [NSNumber numberWithInteger:orientation];
    [[UIDevice currentDevice] setValue:orientationTarget forKey:@"orientation"];
}

#pragma mark - Layout
#pragma mark 横屏的约束
- (void)prepareRotateLayouts {
    CGFloat W = SCREEN_WIDTH * 1.6f;
    CGFloat M = (SCREEN_HEIGHT - W)/2.0f;
    if (W > SCREEN_HEIGHT) {
        W = SCREEN_HEIGHT;
        M = 0.0f;
    }
    self.DisplayView.sd_layout
    .topSpaceToView(self.view, 0.0f)
    .leftSpaceToView(self.view, M)
    .widthIs(W)
    .heightIs(W * 0.625);
}
#pragma mark 竖屏的约束
- (void)prepareInstalledLayouts {
    self.DisplayView.sd_layout
    .topSpaceToView(self.view, 44)
    .leftSpaceToView(self.view, 0.0f)
    .widthIs(SCREEN_HEIGHT)
    .heightIs(SCREEN_HEIGHT * 0.625);
}

- (void)startDeviceOrientationObserver {
    // 开始监听屏幕旋转方向
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationWillChangeStatusBarOrientationNotification:) name:UIApplicationWillChangeStatusBarOrientationNotification object:nil];
}

- (void)removeDeviceOrientationObserver {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIDeviceOrientationDidChangeNotification object:nil];
}

#pragma mark - Notification
#pragma mark 设备方向改变的处理 只是演示demo的一种方法，实际情况根据自己需要更改
- (void)applicationWillChangeStatusBarOrientationNotification:(NSNotification *)notification{
    
    UIInterfaceOrientation orientation = [[[notification userInfo] objectForKey:UIApplicationStatusBarOrientationUserInfoKey] integerValue];
    //获取屏幕方向
    BOOL protrait = UIInterfaceOrientationIsPortrait(orientation);
    
    if (protrait) {
        
        [self prepareInstalledLayouts];
        
    }else{
        
        [self prepareRotateLayouts];
        
    }
    
}


@end
