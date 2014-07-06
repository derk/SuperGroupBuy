//
//  UsersVC.m
//  SuperGroupBuying
//
//  Created by lanouhn on 14-4-2.
//  Copyright (c) 2014年 lanouhn. All rights reserved.
//

#import "UsersVC.h"
#import "ShopCollectionVC.h"
#import "CouponCollectionVC.h"
#import "UserInfoHandle.h"
#import "RennSDK/RennSDK.h"
#import "UIWindow+YzdHUD.h"
#import "CollectGroupVC.h"
#define X 60
#define Y 150
#define W 200
#define H 40
@interface UsersVC ()
{
    UIButton *_setUpBtn;
}
@property (nonatomic,retain) NSMutableData *data;
@property (nonatomic,retain) UIAlertView *clearAlertView;
@end

@implementation UsersVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationItem.title = @"用户";
    self.tabBarController.navigationItem.leftBarButtonItem.customView.hidden = YES;
    NSString *imageDir = [NSString stringWithFormat:@"%@/Library/Caches/%@", NSHomeDirectory(), @"image"];
    float image = [self folderSizeAtPath:imageDir];
    [_setUpBtn setTitle:[NSString stringWithFormat:@"清除图片缓存(%.1fMB)",image] forState:UIControlStateNormal];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    int my_y = 0;
    if (self.view.frame.size.height == 568) {
        my_y = 140;
    }else{
        my_y = Y;
    }
    
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:self.view.frame];
    scrollView.contentSize = CGSizeMake(self.view.frame.size.width, self.view.frame.size.height+10);
    scrollView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:scrollView];
    
    
    UIImageView *userImageView = [[UIImageView alloc] initWithFrame:CGRectMake(X+50, my_y-135, 100, 100)];
//    userImageView.backgroundColor = [UIColor orangeColor];
    userImageView.image = [UIImage imageNamed:@"TabMeSelected@2x.png"];
    [scrollView addSubview:userImageView];
    
    
    
    UIButton *loginBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    [loginBtn setTitle:@"登陆" forState:UIControlStateNormal];
    [loginBtn setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
    loginBtn.frame = CGRectMake(X, my_y-20, W, H);
    loginBtn.layer.cornerRadius = 10;
    [loginBtn.layer setBorderWidth:1.0];
    //    shopCollectionBtn.backgroundColor = [UIColor yellowColor];
    [loginBtn addTarget:self action:@selector(login:) forControlEvents:UIControlEventTouchUpInside];
    [scrollView addSubview:loginBtn];
    

 //我收藏的商家 按钮
    UIButton *shopCollectionBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    [shopCollectionBtn setTitle:@"收藏的商家" forState:UIControlStateNormal];
    shopCollectionBtn.frame = CGRectMake(X, my_y+40, W, H);
    shopCollectionBtn.layer.cornerRadius = 10;
    [shopCollectionBtn.layer setBorderWidth:1.0];
    [shopCollectionBtn setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
    [shopCollectionBtn addTarget:self action:@selector(shopCollection:) forControlEvents:UIControlEventTouchUpInside];
    [scrollView addSubview:shopCollectionBtn];
//我收藏的团购 按钮
    UIButton *GroupBuyingBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    [GroupBuyingBtn setTitle:@"收藏的团购" forState:UIControlStateNormal];
    GroupBuyingBtn.frame = CGRectMake(X, my_y+100, W, H);
    GroupBuyingBtn.layer.cornerRadius = 10;
    [GroupBuyingBtn setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
    [GroupBuyingBtn.layer setBorderWidth:1.0];
    [GroupBuyingBtn addTarget:self action:@selector(GroupBuyingCollection:) forControlEvents:UIControlEventTouchUpInside];
    [scrollView addSubview:GroupBuyingBtn];
 //我收藏的优惠劵 按钮
    UIButton *CouponsCollectionBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    [CouponsCollectionBtn setTitle:@"收藏的优惠劵" forState:UIControlStateNormal];
    CouponsCollectionBtn.frame = CGRectMake(X, my_y+160, W, H);
    CouponsCollectionBtn.layer.cornerRadius = 10;
    [CouponsCollectionBtn setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
    [CouponsCollectionBtn.layer setBorderWidth:1.0];
    [CouponsCollectionBtn addTarget:self action:@selector(CouponsCollection:) forControlEvents:UIControlEventTouchUpInside];
    [scrollView addSubview:CouponsCollectionBtn];
 //设置
    
    NSString *imageDir = [NSString stringWithFormat:@"%@/Library/Caches/%@", NSHomeDirectory(), @"image"];
    float image = [self folderSizeAtPath:imageDir];
    _setUpBtn = [[UIButton buttonWithType:UIButtonTypeSystem] retain];
    [_setUpBtn setTitle:[NSString stringWithFormat:@"清除图片缓存(%.1fMB)",image] forState:UIControlStateNormal];
    _setUpBtn.layer.cornerRadius = 10;
//    _setUpBtn.backgroundColor = [UIColor yellowColor];
    [_setUpBtn setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
    [_setUpBtn.layer setBorderWidth:1.0];
    _setUpBtn.frame = CGRectMake(X, my_y+220, W, H);
    [_setUpBtn addTarget:self action:@selector(setUp:) forControlEvents:UIControlEventTouchUpInside];
    [scrollView addSubview:_setUpBtn];

    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] init];
    backItem.title = @"";
    self.navigationItem.backBarButtonItem = backItem;
    [backItem release];
   
}



- (void)login:(UIButton *)btn
{
    UIActionSheet *actionSheet = [[UIActionSheet alloc]
                                  initWithTitle:@"请选择登陆方式"
                                  delegate:self
                                  cancelButtonTitle:@"取消"
                                  destructiveButtonTitle:@"新浪微博登陆"
                                  otherButtonTitles:@"人人网登陆",nil];
    actionSheet.actionSheetStyle = UIActionSheetStyleBlackOpaque ;
    actionSheet.destructiveButtonIndex=2;
    [actionSheet showInView:self.view];
    [actionSheet release];
}
-(void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if(buttonIndex == 0) {
        if ([UserInfoHandle sharedHanle].userDic != nil) {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"已登陆" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
            [alertView show];
            [alertView release];
        }else{
            WBAuthorizeRequest *request = [WBAuthorizeRequest request];
            request.redirectURI = kRedirectURI;
            request.scope = @"all";
            request.userInfo = @{@"SSO_From": @"UsersVC",
                                 @"Other_Info_1": [NSNumber numberWithInt:123],
                                 @"Other_Info_2": @[@"obj1", @"obj2"],
                                 @"Other_Info_3": @{@"key1": @"obj1", @"key2": @"obj2"}};
            [WeiboSDK sendRequest:request];
        }
    }else if (buttonIndex == 1){
        if ([UserInfoHandle sharedHanle].userDic != nil) {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"已登陆" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
            [alertView show];
            [alertView release];
        }else{
            if (![RennClient isLogin]) {
                [RennClient loginWithDelegate:self];
            }
        }

    }
}
- (void)requestDataByAccessToken:(NSString *)accessToken userID:(NSString *)userID
{
    NSString *urlString = [[NSString stringWithFormat:@"https://api.renren.com/v2/user/get?access_token=%@&userId=%@", accessToken, userID] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSLog(@"%@",urlString);
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [NSURLConnection connectionWithRequest:request delegate:self];
}
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    self.data = [NSMutableData data];
}
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [self.data appendData:data];
}
- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSDictionary *dic = nil;
    if (self.data != nil) {
        dic = [NSJSONSerialization JSONObjectWithData:self.data options:0 error:nil];
        [UserInfoHandle sharedHanle].userDic = dic;
    }
    NSLog(@"%@",dic);
    
}
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    [self.view.window showHUDWithText:@"加载失败" Type:ShowPhotoNo Enabled:YES];
}

- (void)rennLoginSuccess
{
    NSLog(@"Login Success");
    RennAccessToken *token = [RennClient accessToken];
    NSString *uid = [RennClient uid];
    NSLog(@" accessToken %@ %@", token.accessToken, uid);
    [self requestDataByAccessToken:token.accessToken userID:uid];
//    [self showAlertViewWithTitle:@"恭喜" message:@"您登录成功"];
}



- (void)showAlertViewWithTitle:(NSString *)title message:(NSString *)message
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title message:message delegate:nil cancelButtonTitle:@"cancel" otherButtonTitles:@"Done", nil];
    [alertView show];
    [alertView release];
}

- (void)shopCollection:(UIButton *)shopCollectionBtn
{
    if ([UserInfoHandle sharedHanle].userDic != nil) {
        ShopCollectionVC *shopCollectionVC = [[ShopCollectionVC alloc] init];
        [self.navigationController pushViewController:shopCollectionVC animated:YES];
        [shopCollectionVC release];
    }else{
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请登陆" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alertView show];
        [alertView release];
    }
    

}
- (void)GroupBuyingCollection:(UIButton *)GroupBuyingCollectionBtn
{
    if ([UserInfoHandle sharedHanle].userDic != nil) {
        CollectGroupVC *collectGroupVC = [[CollectGroupVC alloc] init];
        [self.navigationController pushViewController:collectGroupVC animated:YES];
        [collectGroupVC release];
    }else{
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请登陆" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alertView show];
        [alertView release];
    }
}
- (void)CouponsCollection:(UIButton *)CouponsCollectionBtn
{
    if ([UserInfoHandle sharedHanle].userDic != nil) {
        CouponCollectionVC *couponCollection = [[CouponCollectionVC alloc] init];
        [self.navigationController pushViewController:couponCollection animated:YES];
        [couponCollection release];
    }else{
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请登陆" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alertView show];
        [alertView release];
    }
    

}
- (void)setUp:(UIButton *)setUpBtn
{
    self.clearAlertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"确定要清除本地图片缓存？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [_clearAlertView show];
    
   
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if ( alertView == _clearAlertView && buttonIndex == 1) {
        NSString *imageDir = [NSString stringWithFormat:@"%@/Library/Caches/%@", NSHomeDirectory(), @"image"];
        NSFileManager *fileManager = [NSFileManager defaultManager];
        [fileManager removeItemAtPath:imageDir error:nil];
        float image = [self folderSizeAtPath:imageDir];
        [_setUpBtn setTitle:[NSString stringWithFormat:@"清除图片缓存(%.1fMB)",image] forState:UIControlStateNormal];
    }
}
- (long long) fileSizeAtPath:(NSString*) filePath
{
    NSFileManager* manager = [NSFileManager defaultManager];
    if ([manager fileExistsAtPath:filePath]){
        return [[manager attributesOfItemAtPath:filePath error:nil] fileSize];
    }
    return 0;
}
- (float )folderSizeAtPath:(NSString*)folderPath
{
    NSFileManager* manager = [NSFileManager defaultManager];
    if (![manager fileExistsAtPath:folderPath]) return 0;
    NSEnumerator *childFilesEnumerator = [[manager subpathsAtPath:folderPath] objectEnumerator];
    NSString* fileName;
    long long folderSize = 0;
    while ((fileName = [childFilesEnumerator nextObject]) != nil){
        NSString* fileAbsolutePath = [folderPath stringByAppendingPathComponent:fileName];
        folderSize += [self fileSizeAtPath:fileAbsolutePath];
    }
    return folderSize/(1024.0*1024.0);
}
-(void)dealloc
{
    [_setUpBtn release];
    [_clearAlertView release];
    [super dealloc];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
