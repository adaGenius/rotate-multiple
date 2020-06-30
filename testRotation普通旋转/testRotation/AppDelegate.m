//
//  AppDelegate.m
//  testRotation
//
//  Created by jiangbao on 2020/5/14.
//  Copyright © 2020 jiangbao. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    return YES;
}

 /// 在这里写支持的旋转方向，为了防止横屏方向，应用启动时候界面变为横屏模式
 - (UIInterfaceOrientationMask)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window {
     // 可以这么写
     if (self.allowOrentitaionRotation) {
         return UIInterfaceOrientationMaskAllButUpsideDown;
     }
     return UIInterfaceOrientationMaskPortrait;
 }
@end
