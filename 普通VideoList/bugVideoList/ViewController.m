
#define videoListUrl @"http://c.3g.163.com/nc/video/list/VAP4BFR16/y/0-10.html"
#import "ViewController.h"
#import "VideoTableViewCell.h"
#import "Masonry.h"
#import "XLVideoItem.h"
#import "MJExtension.h"
#import "PLMediaInfo.h"
#import "AppDelegate.h"

@interface ViewController ()<UITableViewDelegate,UITableViewDataSource,PLPlayerViewDelegate>

@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *videoArray;
@property (nonatomic,strong) PLPlayerView *playerView;
@property (nonatomic,strong) NSIndexPath *indexPath;
@property (nonatomic,assign) BOOL isFull;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupView];
    [self fetchVideoListData];
}

- (void)fetchVideoListData {
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager GET:videoListUrl parameters:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        //        NSLog(@"%@", responseObject);
        NSArray *dataArray = responseObject[@"VAP4BFR16"];
        for (NSDictionary *dict in dataArray) {
            [self.videoArray addObject:[XLVideoItem mj_objectWithKeyValues:dict]];
        }
        [self.tableView reloadData];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"error = %@", error);
    }];
}

-(void)setupView {
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.playerView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(44);
        make.left.mas_equalTo(0);
        make.width.mas_equalTo(414);
        make.bottom.mas_equalTo(-34);
    }];
    
    [self.playerView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.left.mas_equalTo(0);
        make.width.mas_equalTo(SCREEN_WIDTH);
        make.height.mas_equalTo(300);
    }];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.videoArray.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    VideoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellID"];
    if (!cell) {
        cell = [[VideoTableViewCell alloc]initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:@"cellID"];
        kWeakSelf(self)
        cell.tapBlock = ^(id obj) {
            [weakself showVideoPlayer:obj];
        };
    }
    cell.model = self.videoArray[indexPath.row];
    cell.videoImageView.tag = indexPath.row + 100;
    return cell;
}
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    //    if (indexPath.row == self.indexPath.row) {
    //        [self.playerView stop];
    //        self.playerView.hidden = YES;
    //    }
    
}
- (void)showVideoPlayer:(UITapGestureRecognizer *)tapGesture {
    UIView *view = tapGesture.view;
    XLVideoItem *item = self.videoArray[view.tag-100];
    
    self.indexPath = [NSIndexPath indexPathForRow:view.tag - 100 inSection:0];
    VideoTableViewCell *cell = [self.tableView cellForRowAtIndexPath:self.indexPath];
    
    PLMediaInfo *model = [[PLMediaInfo alloc]init];
    model.videoURL = item.mp4_url;
    model.thumbURL = item.cover;
    model.name = item.title;
    self.playerView.media = model;
    [self.playerView removeFromSuperview];
    [cell.contentView addSubview:self.playerView];
    [cell.contentView bringSubviewToFront:self.playerView];
    self.playerView.hidden = NO;
    [self.playerView play];
    
}
#pragma mark scrollView delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if(self.playerView.isStop == NO && self.isFull == NO ){
        VideoTableViewCell *cell = [self.tableView cellForRowAtIndexPath:self.indexPath];
        CGRect rectInSuperview = [cell.videoImageView convertRect:cell.videoImageView.frame toView:self.view];
        
        if (rectInSuperview.origin.y < -cell.frame.size.height||
            rectInSuperview.origin.y > self.tableView.frame.size.height) {//往上拖动
            NSLog(@" 11 1 %@ %@ %@",NSStringFromCGRect(rectInSuperview),NSStringFromCGRect(self.tableView.frame),NSStringFromCGRect(cell.frame));
            [self.playerView stop];
            self.playerView.hidden = YES;
        } else {
            //NSLog(@" 22 2 %@ %@ %@",NSStringFromCGRect(rectInSuperview),NSStringFromCGRect(self.tableView.frame),NSStringFromCGRect(cell.frame));
        }
    }
}
#pragma mark - 七牛播放视频
- (void)playerViewEnterFullScreen:(PLPlayerView *)playerView {
    UIView *superView = [UIApplication sharedApplication].delegate.window.rootViewController.view;
    [self.playerView removeFromSuperview];
    [superView addSubview:self.playerView];
    [self.playerView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(self.view.mas_width);
        make.height.equalTo(self.view.mas_height);
        make.center.equalTo(self.view);
    }];
    [self.view setNeedsUpdateConstraints];
    [self.view updateConstraintsIfNeeded];
    
    [UIView animateWithDuration:.3 animations:^{
        [self.view layoutIfNeeded];
        self.isFull = YES;
    }];
    
}

- (void)playerViewExitFullScreen:(PLPlayerView *)playerView {
    [self.playerView removeFromSuperview];
    VideoTableViewCell *cell = [self.tableView cellForRowAtIndexPath:self.indexPath];
    [self.playerView removeFromSuperview];
    [cell.contentView addSubview:self.playerView];
    [cell.contentView bringSubviewToFront:self.playerView];
    [self.playerView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.left.mas_equalTo(0);
        make.width.mas_equalTo(SCREEN_HEIGHT);
        make.height.mas_equalTo(300);
    }];
    
    [self.view setNeedsUpdateConstraints];
    [self.view updateConstraintsIfNeeded];
    
    [UIView animateWithDuration:.3 animations:^{
        [self.view layoutIfNeeded];
        self.isFull = NO;
    }];
    
}

- (void)playerViewWillHideBar:(PLPlayerView *)playerView {
    
}

- (void)playerViewWillShowBar:(PLPlayerView *)playerView {
    
}

- (void)playerViewWillPlay:(PLPlayerView *)playerView {
    
}

- (void)playerViewWillPause:(PLPlayerView *)playerView {
    
}

- (void)playerViewWillStop:(PLPlayerView *)playerView {
    
}
#pragma mark 旋转方法
- (void)rotateToProtrait:(NSInteger)type {
    UIInterfaceOrientationMask orientationMask = UIInterfaceOrientationMaskPortrait;
    UIDeviceOrientation orientation = UIDeviceOrientationPortrait;
    if (type == 0) {
        orientationMask = UIInterfaceOrientationMaskPortrait;
        orientation = UIDeviceOrientationPortrait;
    } else if (type == 1) {
        orientationMask = UIInterfaceOrientationMaskLandscapeLeft;
        orientation = UIDeviceOrientationLandscapeRight;
    } else {
        orientationMask = UIInterfaceOrientationMaskLandscapeRight;
        orientation = UIDeviceOrientationLandscapeLeft;
    }
    
    AppDelegate *app = (AppDelegate *)[[UIApplication  sharedApplication] delegate];
    app.orientation = orientationMask;
    
    NSNumber *orientationUnknown = [NSNumber numberWithInt:UIInterfaceOrientationUnknown];
    [[UIDevice currentDevice] setValue:orientationUnknown forKey:@"orientation"];
    NSNumber *orientationTarget = [NSNumber numberWithInteger:orientation];
    [[UIDevice currentDevice] setValue:orientationTarget forKey:@"orientation"];
}
#pragma mark - Getters
-(NSMutableArray *)videoArray {
    if (!_videoArray) {
        _videoArray = [NSMutableArray array];
    }
    return _videoArray;
}
-(UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectZero style:(UITableViewStylePlain)];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableFooterView = [[UIView alloc]init];
        _tableView.tableHeaderView = [[UIView alloc]init];
        _tableView.estimatedRowHeight = 300;
        _tableView.rowHeight = UITableViewAutomaticDimension;
        _tableView.separatorStyle = UITableViewScrollPositionNone;
        _tableView.bounces = NO;
        
    }
    return _tableView;
}
- (PLPlayerView *)playerView {
    if (!_playerView) {
        _playerView = [[PLPlayerView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 300)];
        _playerView.delegate = self;
        _playerView.hidden = YES;
    }
    return _playerView;
}

@end
