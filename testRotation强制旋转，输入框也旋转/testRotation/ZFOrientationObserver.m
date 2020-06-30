
//  ZFOrentationObserver.m
//  ZFPlayer
//
// Copyright (c) 2016年 任子丰 ( http://github.com/renzifeng )
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

#import "ZFOrientationObserver.h"
 
@interface ZFOrientationObserver ()

@property (nonatomic, weak) UIView *view;

@property (nonatomic, assign, getter=isFullScreen) BOOL fullScreen;

@property (nonatomic, strong) UIView *cell;

@property (nonatomic, assign) NSInteger playerViewTag;
 

@property (nonatomic, strong) UIView *blackView;
 
@end

@implementation ZFOrientationObserver

- (instancetype)init {
    self = [super init];
    if (self) {
        _duration = 0.30;
        _currentOrientation = UIInterfaceOrientationPortrait;
    }
    return self;
}

- (void)updateRotateView:(UIView *)rotateView
           containerView:(UIView *)containerView {
    self.view = rotateView;
    self.containerView = containerView;
}
 
- (void)dealloc { 
    [self.blackView removeFromSuperview];
}
  

- (void)forceDeviceOrientation:(UIInterfaceOrientation)orientation animated:(BOOL)animated {
    UIView *superview = nil;
    if (UIInterfaceOrientationIsLandscape(orientation)) {
        /// It's not set from the other side of the screen to this side
        if (!self.isFullScreen) {
            self.view.frame = [self.view convertRect:self.view.frame toView:superview];
        }
        self.fullScreen = YES;
        superview = self.fullScreenContainerView;
    } else {
        if (!self.fullScreen) return;
        self.fullScreen = NO;
         superview = self.containerView;
        if (self.blackView.superview != nil) [self.blackView removeFromSuperview];
    }
    if (self.orientationWillChange) self.orientationWillChange(self, self.isFullScreen);
    [UIViewController attemptRotationToDeviceOrientation];

    [superview addSubview:self.view];
    if (animated) {
        [UIView animateWithDuration:self.duration animations:^{
            [self interfaceOrientation:orientation];
            self.view.frame = superview.bounds;
            [self.view layoutIfNeeded];
        } completion:^(BOOL finished) {
            if (self.fullScreen) {
                [superview insertSubview:self.blackView belowSubview:self.view];
                self.blackView.frame = superview.bounds;
            }
            if (self.orientationDidChanged) self.orientationDidChanged(self, self.isFullScreen);
        }];
    } else {
        [UIView animateWithDuration:0 animations:^{
            [self interfaceOrientation:orientation];
        }];
        self.view.frame = superview.bounds;
        [self.view layoutIfNeeded];
        if (self.fullScreen) {
            [superview insertSubview:self.blackView belowSubview:self.view];
            self.blackView.frame = superview.bounds;
            self.view.frame = superview.bounds;
        }
        if (self.orientationDidChanged) self.orientationDidChanged(self, self.isFullScreen);
    }
}
 

- (void)interfaceOrientation:(UIInterfaceOrientation)orientation {
    if ([[UIDevice currentDevice] respondsToSelector:@selector(setOrientation:)]) {
        SEL selector = NSSelectorFromString(@"setOrientation:");
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:[UIDevice instanceMethodSignatureForSelector:selector]];
        [invocation setSelector:selector];
        [invocation setTarget:[UIDevice currentDevice]];
        UIInterfaceOrientation val = orientation;
        [invocation setArgument:&val atIndex:2];
        [invocation invoke];
    }
}
 

#pragma mark - public

- (void)enterLandscapeFullScreen:(UIInterfaceOrientation)orientation animated:(BOOL)animated {
    _currentOrientation = orientation;
    [self forceDeviceOrientation:orientation animated:animated];
}
  
#pragma mark - getter

- (UIView *)blackView {
    if (!_blackView) {
        _blackView = [UIView new];
        _blackView.backgroundColor = [UIColor blackColor];
    }
    return _blackView;
}
  
#pragma mark - setter
  
- (UIView *)fullScreenContainerView {
    if (!_fullScreenContainerView) {
        _fullScreenContainerView = [UIApplication sharedApplication].keyWindow;
    }
    return _fullScreenContainerView;
}
  
@end
