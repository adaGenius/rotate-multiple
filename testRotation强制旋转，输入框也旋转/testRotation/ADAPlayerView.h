//
//  ADAPlayerView.h
//  testRotation
//
//  Created by jiangbao on 2020/5/14.
//  Copyright © 2020 jiangbao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZFOrientationObserver.h"

NS_ASSUME_NONNULL_BEGIN

@interface ADAPlayerView : UIView

@property (nonatomic,copy) void(^backBlock)(void);
@property (nonatomic, strong) ZFOrientationObserver *orientationObserver;

@end

NS_ASSUME_NONNULL_END
