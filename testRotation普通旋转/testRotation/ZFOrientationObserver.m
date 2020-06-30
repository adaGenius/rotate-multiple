
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
  

@interface ZFFullViewController : UIViewController

@property (nonatomic, assign) UIInterfaceOrientationMask interfaceOrientationMask;

@end

@implementation ZFFullViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
}

- (BOOL)shouldAutorotate {
    return YES;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    if (self.interfaceOrientationMask) {
        return self.interfaceOrientationMask;
    }
    return UIInterfaceOrientationMaskLandscape;
}

@end

@interface UIWindow (CurrentViewController)

/*!
 @method currentViewController
 @return Returns the topViewController in stack of topMostController.
 */
+ (UIViewController*)zf_currentViewController;

@end

@implementation UIWindow (CurrentViewController)

+ (UIViewController*)zf_currentViewController; {
    UIWindow *window = [[UIApplication sharedApplication].delegate window];
    UIViewController *topViewController = [window rootViewController];
    while (true) {
        if (topViewController.presentedViewController) {
            topViewController = topViewController.presentedViewController;
        } else if ([topViewController isKindOfClass:[UINavigationController class]] && [(UINavigationController*)topViewController topViewController]) {
            topViewController = [(UINavigationController *)topViewController topViewController];
        } else if ([topViewController isKindOfClass:[UITabBarController class]]) {
            UITabBarController *tab = (UITabBarController *)topViewController;
            topViewController = tab.selectedViewController;
        } else {
            break;
        }
    }
    return topViewController;
}

@end

@interface ZFOrientationObserver ()

@property (nonatomic, weak) UIView *view;

@property (nonatomic, assign, getter=isFullScreen) BOOL fullScreen;
   
@property (nonatomic, strong) UIView *blackView;

@property (nonatomic, strong) UIWindow *customWindow;

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
- (void)normalOrientation:(UIInterfaceOrientation)orientation animated:(BOOL)animated {
    UIView *superview = nil;
    CGRect frame;
    if (UIInterfaceOrientationIsLandscape(orientation)) {
        superview = self.fullScreenContainerView;
        /// It's not set from the other side of the screen to this side
        if (!self.isFullScreen) {
            self.view.frame = [self.view convertRect:self.view.frame toView:superview];
        }
        [superview addSubview:self.view];
        self.fullScreen = YES;
        if (self.orientationWillChange) self.orientationWillChange(self, self.isFullScreen);
        
        ZFFullViewController *fullVC = [[ZFFullViewController alloc] init];
        if (orientation == UIInterfaceOrientationLandscapeLeft) {
            fullVC.interfaceOrientationMask = UIInterfaceOrientationMaskLandscapeLeft;
        } else {
            fullVC.interfaceOrientationMask = UIInterfaceOrientationMaskLandscapeRight;
        }
        self.customWindow.rootViewController = fullVC;
    } else {
        self.fullScreen = NO;
        if (self.orientationWillChange) self.orientationWillChange(self, self.isFullScreen);
        ZFFullViewController *fullVC = [[ZFFullViewController alloc] init];
        fullVC.interfaceOrientationMask = UIInterfaceOrientationMaskPortrait;
        self.customWindow.rootViewController = fullVC;
        superview = self.containerView;
        if (self.blackView.superview != nil) [self.blackView removeFromSuperview];
    }
    frame = [superview convertRect:superview.bounds toView:self.fullScreenContainerView];
    
    if (animated) {
        [UIView animateWithDuration:self.duration animations:^{
            self.view.transform = [self getTransformRotationAngle:orientation];
            [UIView animateWithDuration:self.duration animations:^{
                self.view.frame = frame;
                [self.view layoutIfNeeded];
            }];
        } completion:^(BOOL finished) {
            [superview addSubview:self.view];
            self.view.frame = superview.bounds;
            if (self.fullScreen) {
                [superview insertSubview:self.blackView belowSubview:self.view];
                self.blackView.frame = superview.bounds;
            }
            if (self.orientationDidChanged) self.orientationDidChanged(self, self.isFullScreen);
        }];
    } else {
        self.view.transform = [self getTransformRotationAngle:orientation];
        [superview addSubview:self.view];
        self.view.frame = superview.bounds;
        [self.view layoutIfNeeded];
        if (self.fullScreen) {
            [superview insertSubview:self.blackView belowSubview:self.view];
            self.blackView.frame = superview.bounds;
        }
        if (self.orientationDidChanged) self.orientationDidChanged(self, self.isFullScreen);
    }
}
 

/// Gets the rotation Angle of the transformation.
- (CGAffineTransform)getTransformRotationAngle:(UIInterfaceOrientation)orientation {
    if (orientation == UIInterfaceOrientationPortrait) {
        return CGAffineTransformIdentity;
    } else if (orientation == UIInterfaceOrientationLandscapeLeft) {
        return CGAffineTransformMakeRotation(-M_PI_2);
    } else if(orientation == UIInterfaceOrientationLandscapeRight) {
        return CGAffineTransformMakeRotation(M_PI_2);
    }
    return CGAffineTransformIdentity;
}

#pragma mark - public

- (void)enterLandscapeFullScreen:(UIInterfaceOrientation)orientation animated:(BOOL)animated {
    _currentOrientation = orientation;
    [self normalOrientation:orientation animated:animated];
}
 
#pragma mark - private
 

#pragma mark - getter

- (UIView *)blackView {
    if (!_blackView) {
        _blackView = [UIView new];
        _blackView.backgroundColor = [UIColor blackColor];
    }
    return _blackView;
}

- (UIWindow *)customWindow {
    if (!_customWindow) {
        if (@available(iOS 13.0, *)) {
            UIWindowScene *windowScene = nil;
            for (UIScene *scene in [UIApplication sharedApplication].connectedScenes) {
                if (scene.activationState == UISceneActivationStateForegroundActive) {
                    windowScene = (UIWindowScene *)scene;
                }
                if (!windowScene && [UIApplication sharedApplication].connectedScenes.count == 1) {
                    windowScene = (UIWindowScene *)scene;
                }
            }
            if (windowScene) {
                _customWindow = [[UIWindow alloc] initWithWindowScene:windowScene];
            } else {
                _customWindow = [[UIWindow alloc] initWithFrame:CGRectZero];
            }
        } else {
            _customWindow = [[UIWindow alloc] initWithFrame:CGRectZero];
        }
    }
    return _customWindow;
}

#pragma mark - setter
 

- (UIView *)fullScreenContainerView {
    if (!_fullScreenContainerView) {
        _fullScreenContainerView = [UIApplication sharedApplication].keyWindow;
    }
    return _fullScreenContainerView;
}

- (void)setFullScreen:(BOOL)fullScreen {
    _fullScreen = fullScreen;
    [[UIWindow zf_currentViewController] setNeedsStatusBarAppearanceUpdate];
    [UIViewController attemptRotationToDeviceOrientation];
}
 

@end
