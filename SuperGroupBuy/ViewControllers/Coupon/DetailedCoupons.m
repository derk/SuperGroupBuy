//
//  DetailedCoupons.m
//  SuperGroupBuying
//
//  Created by lanouhn on 14-4-2.
//  Copyright (c) 2014年 lanouhn. All rights reserved.
//

#import "DetailedCoupons.h"
#import "WebVC.h"
#import "WebImageManager.h"
#import "GroupShopList.h"
#import "UserInfoHandle.h"
#import "UMSocial.h"
#import "RennSDK/RennSDK.h"
#import "UIWindow+YzdHUD.h"
#define X 5
#define Y 10
@interface DetailedCoupons ()
{
    UILabel *_businesses_name;//商户名
    UILabel *_description;//优惠描述,点击可推入Html网页
    UILabel *_valid_time;//有效时间
    UILabel *_publish_date;//起止日期
    UIImageView *_imageView;//优惠券图标,自己给定
    UILabel *_categories;//优惠券类型
    UILabel *_regions;//行政区域
    UIButton *_businesses;//全部使用商户可点击
    UIButton *_coupon_url;//优惠的具体内容可点击推入WEB
    UILabel *_business;//适用店家列表
    BOOL user;
    UIButton *_collectBtn;
}
//@property(nonatomic,retain)NSMutableData *data;
@property (nonatomic,retain)UITableView *tableView;
@property (nonatomic,retain) NSMutableData *data;
@end

@implementation DetailedCoupons

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc
{
    [_imageView release];
    [_businesses_name release];
    [_description release];
    [_valid_time release];
    [_publish_date release];
    [_coupon_url release];
    [_tableView release];
    [super dealloc];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if ([UserInfoHandle sharedHanle].userDic != nil) {
        user = YES;
    }else{
        user = NO;
    }
    NSArray *readArr = [NSArray arrayWithContentsOfFile:[self getFilePath]];
    
    for (NSString *str in readArr) {
        if ([self.coupon.coupon_id intValue] == [str intValue]) {
            [_collectBtn setImage:[UIImage imageNamed:@"icon_merchant_collect_selected@2x.png"] forState:UIControlStateNormal];
        }
    }
//    self.tabBarController.tabBar.hidden = YES;
//    self.tabBarController.tabBar.hidden = NO;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationController.navigationBar.tintColor = [UIColor orangeColor];
    self.navigationItem.title = @"优惠券详情";
    self.tabBarController.tabBar.hidden = YES;
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] init];
    barButtonItem.title = @"";
    self.navigationItem.backBarButtonItem = barButtonItem;
    [barButtonItem release];
    
    if ([UserInfoHandle sharedHanle].userDic != nil) {
        user = YES;
    }else{
        user = NO;
    }
    
    int my_y = 0;
    if (self.view.frame.size.height == 568) {
        my_y = 20;
    }else{
        my_y = Y;
    }

    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:self.view.frame];
    scrollView.contentSize = CGSizeMake(320, 480+30);
    scrollView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:scrollView];
    [scrollView release];
    
    
    _businesses_name = [[UILabel alloc] initWithFrame:CGRectMake(X, my_y-5, 310, 30)];
    _businesses_name.text = self.coupon.title;
    _businesses_name.textAlignment = NSTextAlignmentCenter;
    [scrollView addSubview:_businesses_name];
    
    
    _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(X, my_y+30, 310, 180)];
    [scrollView addSubview:_imageView];
    
    WebImageManager *manager = [[WebImageManager alloc] init];
    manager.imageView = _imageView;
    [manager downloadImageWithImageURL:self.coupon.logo_img_url placeHolderImage:[UIImage imageNamed:@"loading.jpg"]];
    [manager release];
    
    _description = [[UILabel alloc] initWithFrame:CGRectMake(X, my_y+215, 310, 45)];
    _description.text = self.coupon.description;
    _description.textAlignment = NSTextAlignmentCenter;
    _description.numberOfLines = 0;
//    _description.backgroundColor = [UIColor orangeColor];
    [scrollView addSubview:_description];
    
    UILabel *valueTime = [[UILabel alloc] initWithFrame:CGRectMake(X+70, my_y+265, 75, 30)];
    valueTime.text = @"上线日期:";
//    valueTime.backgroundColor = [UIColor orangeColor];
    [scrollView addSubview:valueTime];
    [valueTime release];
    
    _valid_time = [[UILabel alloc] initWithFrame:CGRectMake(X+150, my_y+265, 100, 30)];
    _valid_time.text = self.coupon.publish_date;
//    _valid_time.backgroundColor = [UIColor orangeColor];
    [scrollView addSubview:_valid_time];
    
    
    UILabel *stopTime = [[UILabel alloc] initWithFrame:CGRectMake(X+70, my_y+300, 75, 30)];
    stopTime.text = @"截止日期:";
//    stopTime.backgroundColor = [UIColor orangeColor];
    [scrollView addSubview:stopTime];
    [stopTime release];
    
    _publish_date = [[UILabel alloc] initWithFrame:CGRectMake(X+150, my_y+300, 100, 30)];
    _publish_date.text = self.coupon.expiration_date;
//    _publish_date.backgroundColor = [UIColor orangeColor];
    [scrollView addSubview:_publish_date];
    
    _coupon_url = [[UIButton alloc] initWithFrame:CGRectMake(X, my_y+390, 310, 44)];
    _coupon_url.backgroundColor = [UIColor orangeColor];
    [_coupon_url setTitle:@"更多优惠券信息" forState:UIControlStateNormal];
    
    [_coupon_url setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//    [_coupon_url setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
    [_coupon_url addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
    [scrollView addSubview:_coupon_url];
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(X+5, my_y+335, 300, 40) style:UITableViewStylePlain];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [scrollView addSubview:_tableView];
    
    _collectBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    _collectBtn.frame = CGRectMake(0, 0, 30, 30);
    [_collectBtn setImage:[UIImage imageNamed:@"icon_merchant_collect@2x.png"] forState:UIControlStateNormal];
    [_collectBtn addTarget:self action:@selector(collect) forControlEvents:UIControlEventTouchUpInside];
    
    
    UIButton *sharedBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    sharedBtn.frame = CGRectMake(0, 0, 30, 30);
    [sharedBtn setImage:[UIImage imageNamed:@"icon_share_highlighted.png"] forState:UIControlStateNormal];
    [sharedBtn addTarget:self action:@selector(shaerd) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:sharedBtn];
    UIBarButtonItem *rightItem2 = [[UIBarButtonItem alloc] initWithCustomView:_collectBtn];
    NSArray *arr = [NSArray arrayWithObjects:rightItem,rightItem2, nil];
    
    self.navigationItem.rightBarButtonItems = arr;
    [rightItem release];
    [rightItem2 release];
    
}
#pragma mark 友盟分享
- (void)shaerd
{
    [UMSocialSnsService presentSnsIconSheetView:self
                                         appKey:@"533e61c556240b5a190127cc"
                                      shareText:[NSString stringWithFormat:@"%@真的很不错哦，快来看看吧！",self.coupon.title]
                                     shareImage:_imageView.image
                                shareToSnsNames:[NSArray arrayWithObjects:UMShareToSina,UMShareToTencent,UMShareToRenren,nil]
                                       delegate:nil];
}
#pragma mark 收藏
- (void)collect
{
    if ([UserInfoHandle sharedHanle].userDic != nil) {
        user = YES;
    }else{
        user = NO;
    }
    if (user == YES) {
        NSArray *readArr = [NSArray arrayWithContentsOfFile:[self getFilePath]];
        NSMutableArray *arr = [NSMutableArray arrayWithArray:readArr];
        if ([arr count] == 0) {
            [arr addObject:self.coupon.coupon_id];
            [arr writeToFile:[self getFilePath] atomically:YES];
            
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"收藏成功" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
            [alertView show];
            [alertView release];
            [_collectBtn setImage:[UIImage imageNamed:@"icon_merchant_collect_selected@2x.png"] forState:UIControlStateNormal];
        }else{
            if ([arr containsObject:self.coupon.coupon_id]) {
                
                [arr removeObject:self.coupon.coupon_id];
                [arr writeToFile:[self getFilePath] atomically:YES];
                
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"取消收藏" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
                [alertView show];
                [alertView release];
                [_collectBtn setImage:[UIImage imageNamed:@"icon_merchant_collect@2x.png"] forState:UIControlStateNormal];
            }else
            {
                [arr addObject:self.coupon.coupon_id];
                [arr writeToFile:[self getFilePath] atomically:YES];
                
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"收藏成功" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
                [alertView show];
                [alertView release];
                [_collectBtn setImage:[UIImage imageNamed:@"icon_merchant_collect_selected@2x.png"] forState:UIControlStateNormal];
            }
        }
    }else{
        UIActionSheet *actionSheet = [[UIActionSheet alloc]
                                      initWithTitle:@"请选择登陆方式"
                                      delegate:self
                                      cancelButtonTitle:@"取消"
                                      destructiveButtonTitle:@"新浪微博登陆"
                                      otherButtonTitles:@"人人网登陆",nil];
        
        actionSheet.destructiveButtonIndex=2;
        actionSheet.actionSheetStyle = UIActionSheetStyleBlackOpaque ;
        [actionSheet showInView:self.view];
        [actionSheet release];
        
        
    }
    
}

-(void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if(buttonIndex == 0) {
        if ([UserInfoHandle sharedHanle].userDic != nil) {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"已登陆" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
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
        if (![RennClient isLogin]) {
            [RennClient loginWithDelegate:self];
            
        }else{
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"已登陆" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
            [alertView show];
            [alertView release];
        }
    }
}

- (void)requestDataByAccessToken:(NSString *)accessToken userID:(NSString *)userID
{
    NSString *urlString = [[NSString stringWithFormat:@"https://api.renren.com/v2/user/get?access_token=%@&userId=%@", accessToken, userID] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
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
    NSLog(@" 用户信息 %@",dic);
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
    NSLog(@"%@ %@", token.accessToken, uid);
    [self requestDataByAccessToken:token.accessToken userID:uid];
    //    [self showAlertViewWithTitle:@"恭喜" message:@"您登录成功"];
}



- (void)showAlertViewWithTitle:(NSString *)title message:(NSString *)message
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title message:message delegate:nil cancelButtonTitle:@"cancel" otherButtonTitles:@"Done", nil];
    [alertView show];
    [alertView release];
}

//文件路径
- (NSString *)getFilePath
{
    NSString *filePath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    NSString *newFliePath = [filePath stringByAppendingPathComponent:@"CouponsCollect.txt"];
    return newFliePath;
}

#pragma mark tabelView
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    GroupShopList *shopList = [[GroupShopList alloc] init];
    shopList.businessArr = self.coupon.businesses;
    shopList.title = @"该优惠券支持的商家";
    [self.navigationController pushViewController:shopList animated:YES];
    [shopList release];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *reuseIdentifier = @"reuse";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    
    if (nil == cell) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:reuseIdentifier] autorelease];
    }
    cell.textLabel.text = @"该优惠券支持的商家";
    cell.detailTextLabel.text = [NSString stringWithFormat:@"(%d)",[self.coupon.businesses count]];;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
- (void)click:(UIButton *)scender
{
    WebVC *webVC = [[WebVC alloc] init];
    webVC.title = @"更多优惠";
    webVC.h5Url = self.coupon.coupon_h5_url;
    [self.navigationController pushViewController:webVC animated:YES];
    [webVC release];

}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
