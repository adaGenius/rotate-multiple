//
//  ADAPlayerView.m
//  testRotation
//
//  Created by jiangbao on 2020/5/14.
//  Copyright © 2020 jiangbao. All rights reserved.
//

#define kAPPDelegate ((AppDelegate*)[[UIApplication sharedApplication] delegate])

#import "ADAPlayerView.h"
#import "AppDelegate.h"

@interface ADAPlayerView()

@property (nonatomic,strong) UIImageView *imageView;
@property (nonatomic,strong) UIButton *btn;

@end

@implementation ADAPlayerView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupView];
    }
    return self;
}
- (void)setupView {
    self.backgroundColor = [UIColor redColor];
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    imageView.image = [UIImage imageNamed:@"timg.jpeg"];
    [self addSubview:imageView];
    imageView.hidden = YES;
    _imageView = imageView;
    
    UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(self.frame.size.width - 40, 100, 40, 40)];
    [self addSubview:btn];
    btn.backgroundColor = [UIColor orangeColor];
    [btn addTarget:self action:@selector(btnAction) forControlEvents:(UIControlEventTouchUpInside)];
    _btn = btn;
}
-(void)layoutSubviews {
    [super layoutSubviews];
    _imageView.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    _btn.frame = CGRectMake(self.bounds.size.width - 40, 100, 40, 40);
    //NSLog(@" -- %@",NSStringFromCGRect(self.bounds));
    //NSLog(@" -- %@",NSStringFromCGRect(self.frame));
}
- (void)btnAction {
    if (self.backBlock) {
        self.backBlock();
    }
    if(self.orientationObserver.currentOrientation == UIInterfaceOrientationPortrait) {
        [self enterFullScreen:YES animated:YES];
    } else {
        [self enterFullScreen:NO animated:YES];
    }
}
- (void)enterFullScreen:(BOOL)fullScreen animated:(BOOL)animated {
    
    UIInterfaceOrientation orientation = UIInterfaceOrientationUnknown;
    orientation = fullScreen? UIInterfaceOrientationLandscapeRight : UIInterfaceOrientationPortrait;
    [self.orientationObserver enterLandscapeFullScreen:orientation animated:animated];
    
}
- (void)layoutControllerViews {
    [self layoutIfNeeded];
    [self setNeedsLayout];
}
- (ZFOrientationObserver *)orientationObserver {
    if (!_orientationObserver) {
        _orientationObserver = [[ZFOrientationObserver alloc] init];
        __weak typeof(self) weakself = self;
        _orientationObserver.orientationWillChange = ^(ZFOrientationObserver * _Nonnull observer, BOOL isFullScreen) {
            kAPPDelegate.allowOrentitaionRotation = isFullScreen;
            [weakself layoutControllerViews];
            
        };
        _orientationObserver.orientationDidChanged = ^(ZFOrientationObserver * _Nonnull observer, BOOL isFullScreen) {
            
        };
        
    }
    return _orientationObserver;
}

@end
