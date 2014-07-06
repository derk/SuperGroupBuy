//
//  RootViewController.m
//  SuperGroupBuying
//
//  Created by lanouhn on 14-4-2.
//  Copyright (c) 2014年 lanouhn. All rights reserved.
//

#import "RootViewController.h"
#import "ShopsVC.h"
#import "GroupBuyingVC.h"
#import "CouponsVC.h"
#import "UsersVC.h"
#import "CityListVC.h"

@interface RootViewController ()
{
    UILabel *_ADView;
}
@end

@implementation RootViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    
    ShopsVC *shopsVC = [[ShopsVC alloc] init];
    UINavigationController *shopsNavigationVC = [[UINavigationController alloc] initWithRootViewController:shopsVC];
    shopsVC.tabBarItem.title = @"商家";
    shopsVC.tabBarItem.image = [UIImage imageNamed:@"c_60.png"];
    shopsNavigationVC.navigationBar.translucent = NO;
        //    shopsNavigationVC.tabBarItem.title = @"商家";
    
    
    GroupBuyingVC *groupBuyingVC = [[GroupBuyingVC alloc] init];
    UINavigationController *groupBuyingNavigationVC = [[UINavigationController alloc] initWithRootViewController:groupBuyingVC];
    groupBuyingVC.tabBarItem.title = @"团购";
    groupBuyingVC.tabBarItem.image = [UIImage imageNamed:@"c_20.png"];
    groupBuyingNavigationVC.navigationBar.translucent = NO;
    //    groupBuyingNavigationVC.tabBarItem.title = @"团购";
    
    
    CouponsVC *couponsVC = [[CouponsVC alloc] init];
    UINavigationController *couponsNavigationVC = [[UINavigationController alloc] initWithRootViewController:couponsVC];
    couponsVC.tabBarItem.title = @"优惠券";
    couponsVC.tabBarItem.image = [UIImage imageNamed:@"c_bank.png"];
    //    couponsNavigationVC.tabBarItem.title = @"优惠券";
    couponsNavigationVC.navigationBar.translucent = NO;
    
    
    
    UsersVC *usersVC = [[UsersVC alloc] init];
    UINavigationController *usersNavigationVC = [[UINavigationController alloc] initWithRootViewController:usersVC];
    usersVC.tabBarItem.title = @"用户";
    UIImage *myImage = [UIImage imageNamed:@"icon_tabbar_mine.png"];
//    myImage.scale = 0.5;
    
    usersVC.tabBarItem.image = [self OriginImage:myImage scaleToSize:CGSizeMake(24, 24)];
    //    usersNavigationVC.tabBarItem.title = @"用户";
    usersNavigationVC.navigationBar.translucent = NO;
    
    
    NSArray *vcArr = [NSArray arrayWithObjects:shopsNavigationVC,groupBuyingNavigationVC,couponsNavigationVC,usersNavigationVC, nil];
    
    self.viewControllers = vcArr;
    self.tabBar.tintColor = [UIColor orangeColor];

    
    [shopsVC release];
    [groupBuyingVC release];
    [couponsVC release];
    [usersVC release];
    
    _ADView = [[UILabel alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height-69, self.view.frame.size.width, 20)];
    _ADView.text = @"由大众点评提供数据";
    _ADView.backgroundColor = [UIColor blackColor];
    _ADView.textColor = [UIColor whiteColor];
    _ADView.textAlignment = NSTextAlignmentCenter;
    _ADView.alpha = 0.5;
    [self.view addSubview:_ADView];
    
    
    UIImageView *ADImageView = [[UIImageView alloc] initWithFrame:CGRectMake(65, 2, 16, 16)];
    ADImageView.image = [UIImage imageNamed:@"accr-logo2.237abf5a477e500c02971f2343b844df.png"];
    [_ADView addSubview:ADImageView];
    [ADImageView release];

    [self performSelector:@selector(removeAD) withObject:nil afterDelay:5];
    
    
}

- (void)removeAD
{
    [_ADView removeFromSuperview];
}


-(UIImage*)OriginImage:(UIImage *)image
           scaleToSize:(CGSize)size
{
    // 创建一个bitmap的context
    // 并把它设置成为当前正在使用的context
    UIGraphicsBeginImageContext(size);
    
    // 绘制改变大小的图片
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    
    // 从当前context中创建一个改变大小后的图片
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    
    // 使当前的context出堆栈
    UIGraphicsEndImageContext();
    
    // 返回新的改变大小后的图片
    return scaledImage;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    [_ADView release];
    [super dealloc];
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
