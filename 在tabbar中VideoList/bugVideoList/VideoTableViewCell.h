//
//  VideoTableViewCell.h
//  bugVideoList
//
//  Created by jiangbao on 2020/6/2.
//  Copyright © 2020 jiangbao. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class XLVideoItem;
@interface VideoTableViewCell : UITableViewCell

@property (nonatomic,strong) UIImageView *videoImageView;
@property (nonatomic,strong) UIImageView *playImageView;
@property (nonatomic,strong) UITapGestureRecognizer *tap;
@property (nonatomic,copy) tapBlock tapBlock;
@property (nonatomic,strong) XLVideoItem *model;

@end

NS_ASSUME_NONNULL_END
