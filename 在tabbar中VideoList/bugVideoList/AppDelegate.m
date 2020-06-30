
#import "AppDelegate.h"
#import "ViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // 1.创建窗口
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    
    self.window.backgroundColor = [UIColor blueColor];
    
    // 2.设置窗口的根控制器：默认显示的是第一个子控制器的View
    UITabBarController *tabVC = [[UITabBarController alloc] init];
    
    // 创建第一个控制器
    UIViewController *vc1 = [[ViewController alloc] init];
    vc1.view.backgroundColor = [UIColor redColor];
    vc1.title = @"首页";
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc1];
    
    nav.tabBarItem.title = @"消息";
    nav.tabBarItem.badgeValue = @"10";
    nav.tabBarItem.image = [UIImage imageNamed:@"tab_recent_nor"];
    
    [tabVC addChildViewController:nav]; // 添加子控制器
    
    // 创建第二个控制器
    UIViewController *vc2 = [[UIViewController alloc] init];
    vc2.view.backgroundColor = [UIColor blueColor];
    vc2.tabBarItem.title = @"联系人";
    vc2.tabBarItem.image = [UIImage imageNamed:@"tab_buddy_nor"];
    [tabVC addChildViewController:vc2];
    
    // 创建第三个控制器
    UIViewController *vc3 = [[UIViewController alloc] init];
    vc3.view.backgroundColor = [UIColor whiteColor];
    vc3.tabBarItem.title = @"动态";
    vc3.tabBarItem.image = [UIImage imageNamed:@"tab_qworld_nor"];
    [tabVC addChildViewController:vc3];
    
    // 初始化时，选择的子控制器
    tabVC.selectedIndex = 1;
    
    self.window.rootViewController = tabVC;
    // 3.显示窗口
    [self.window makeKeyAndVisible];
    return YES;
}

///  支持旋转的代理
- (UIInterfaceOrientationMask)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window {
    if (!self.orientation) {
        self.orientation = UIInterfaceOrientationMaskPortrait;
    }
    return self.orientation;
}
@end
