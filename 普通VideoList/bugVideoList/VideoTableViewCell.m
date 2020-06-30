//
//  VideoTableViewCell.m
//  bugVideoList
//
//  Created by jiangbao on 2020/6/2.
//  Copyright © 2020 jiangbao. All rights reserved.
//

#import "VideoTableViewCell.h"
#import "Masonry.h"
#import "XLVideoItem.h"


@implementation VideoTableViewCell
-(void)setModel:(XLVideoItem *)model {
    _model = model;
   [self.videoImageView sd_setImageWithURL:[NSURL URLWithString:model.cover]];
     
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
   self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupView];
    }
    return self;
}
- (void)setupView {
    [self.contentView addSubview:self.videoImageView];
    [self.videoImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.mas_equalTo(0);
        make.height.mas_equalTo(300);
        make.width.mas_equalTo(SCREEN_WIDTH);
        make.bottom.mas_equalTo(0);
    }];
    [self.videoImageView addGestureRecognizer:self.tap];
    [self.videoImageView addSubview:self.playImageView];
    [self.playImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.contentView.mas_centerX);
        make.centerY.equalTo(self.contentView.mas_centerY);
        make.height.mas_equalTo(44);
        make.width.mas_equalTo(44);
    }];
}
- (void)showVideoPlayer:(UITapGestureRecognizer *)tapGesture {
    if (self.tapBlock) {
        self.tapBlock(tapGesture);
    }
}

-(UIImageView *)videoImageView {
    if (!_videoImageView) {
        _videoImageView = [[UIImageView alloc]init];
        _videoImageView.userInteractionEnabled = YES;
        _videoImageView.contentMode =UIViewContentModeScaleAspectFill;
    }
    return _videoImageView;
}
-(UITapGestureRecognizer *)tap {
    if (!_tap) {
        _tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showVideoPlayer:)];
    }
    return _tap;
}
-(UIImageView *)playImageView {
    if (!_playImageView) {
        _playImageView = [[UIImageView alloc]init];
        _playImageView.image = [UIImage imageNamed:@"play-2"];
    }
    return _playImageView;
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
