//
//  ShopDetailVC.m
//  SuperGroupBuying
//
//  Created by lanouhn on 14-4-2.
//  Copyright (c) 2014年 lanouhn. All rights reserved.
//

#import "ShopDetailVC.h"
#import "WebVC.h"
#import "CommentVC.h"
#import "NetWorkRequest.h"
#import "SignatrueEncryption.h"
#import "CommonDefine.h"
#import "ShopDetail.h"
#import "WebImageManager.h"
#import "UIWindow+YzdHUD.h"
#import "UMSocial.h"
#import "UserInfoHandle.h"
#import "UsersVC.h"
#import <MapKit/MapKit.h>
#import <AddressBook/AddressBook.h>
#import "DetailedCoupons.h"
#import "GroupShopList.h"
#import "CouponsVCForShop.h"
#import "ShopGroupList.h"
#define X 0
#define Y 10
@interface ShopDetailVC ()
{
    UIScrollView *_scrollView;
    NetWorkRequest *_request;
    
    UILabel *_nameLabel;
    UIImageView *_photo_url;
    UIImageView *_rating_img_url;
    UILabel *_decoration_grade;
    UILabel *_service_grade;
    UILabel *_address;
    UILabel *_avg_price;
    UIButton *_telephone;
//    UILabel *_coupon_description;
//    UILabel *_deals_description;
    UIButton *_moreBtn;
    UIButton *_commentBtn;
    UIButton *_collectBtn;
    UIView *_btnView;
    NSString *_business_url;
    BOOL user;
    MKMapView *_mapView;
}
@property (nonatomic,retain) ShopDetail *shopDetail;
@property (nonatomic,retain) NSMutableData *data;
@property (nonatomic,retain) UIAlertView *callPhoneAlertView;
@property (nonatomic,retain) UITableView *tableView;

@end

@implementation ShopDetailVC

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
    [self loadData];
    _request.deligate = self;
    self.tabBarController.tabBar.hidden = YES;
    if ([UserInfoHandle sharedHanle].userDic != nil) {
        user = YES;
    }else{
        user = NO;
    }
    NSArray *readArr = [NSArray arrayWithContentsOfFile:[self getFilePath]];
    
    for (NSString *str in readArr) {
        if ([self.shopID intValue] == [str intValue]) {
            [_collectBtn setImage:[UIImage imageNamed:@"icon_merchant_collect_selected@2x.png"] forState:UIControlStateNormal];
        }
    }
    
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    
    self.view.backgroundColor = [UIColor whiteColor];
    
//    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] init];
//    backItem.title = @"";
//    
//    self.navigationItem.backBarButtonItem = backItem;
    
    _scrollView = [[UIScrollView alloc] initWithFrame:self.view.frame];
//    _scrollView.backgroundColor = [UIColor orangeColor];
    _scrollView.contentSize = CGSizeMake(320, 560); //480*3/2
    _scrollView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:_scrollView];
    
    _request = [[NetWorkRequest alloc] init];
    [self layout];
    
    
    
    
    
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
//    self.navigationItem.leftBarButtonItems = arr;
    [rightItem release];
    [rightItem2 release];
  
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] init];
    barButtonItem.title = @"";
    self.navigationItem.backBarButtonItem = barButtonItem;
    [barButtonItem release];

    
}



- (void)loadData
{
//    [self.view.window showHUDWithText:@"加载中" Type:ShowLoading Enabled:YES];
    
    NSMutableDictionary *dicIn = [[NSMutableDictionary alloc] initWithObjectsAndKeys:self.shopID,@"business_id",nil];
    NSMutableDictionary *dicOut = [SignatrueEncryption encryptedParamsWithBaseParams:dicIn];
    
    NSString *urlString = [NSString stringWithFormat:@"http://api.dianping.com/v1/business/get_single_business?appkey=%@&sign=%@&business_id=%@",kAPP_KEY,[dicOut objectForKey:@"sign"],[dicOut objectForKey:@"business_id"]];
//    NSLog(@"%@",urlString);
    [_request loadDataWithURLString:urlString];
    [dicIn release];
}
//请求数据成功之后执行代理方法
- (void)request:(NetWorkRequest *)netWorkRequest
   didFinishing:(NSData *)data
{
//    [self.view.window showHUDWithText:nil Type:ShowDismiss Enabled:YES];
    
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
    
    NSArray *array = [dic objectForKey:@"businesses"];

    NSDictionary *dicDetail = [array objectAtIndex:0];
    
    self.shopDetail = [[ShopDetail alloc] initWithDic:dicDetail];
    
    _nameLabel.text = _shopDetail.name;
    _decoration_grade.text = [NSString stringWithFormat:@"环境评价:  %.1f分",[_shopDetail.decoration_grade floatValue]];
    _service_grade.text = [NSString stringWithFormat:@"服务评价:  %.1f分",[_shopDetail.service_grade floatValue]];
    _address.text = _shopDetail.address;
    _avg_price.text = [NSString stringWithFormat:@"人均价格:  %.1f元",[_shopDetail.avg_price floatValue]];

//    NSLog(@"%@",_shopDetail.telephone);
    [_telephone setTitle:[NSString stringWithFormat:@"%@",_shopDetail.telephone ]forState:UIControlStateNormal];
    [_telephone addTarget:self action:@selector(callPhone:) forControlEvents:UIControlEventTouchUpInside];
    
    _business_url = _shopDetail.business_url;
    
    
    
    WebImageManager *manager = [[WebImageManager alloc] init];
    manager.imageView = _photo_url;
    [manager downloadImageWithImageURL:_shopDetail.photo_url placeHolderImage:[UIImage imageNamed:@"loading.jpg"]];
    
    [manager release];
    
    WebImageManager *manager2 = [[WebImageManager alloc] init];
    manager2.imageView = _rating_img_url;
    [manager2 downloadImageWithImageURL:_shopDetail.rating_img_url placeHolderImage:nil];
    [manager2 release];
 
    [self.tableView reloadData];
//    NSLog(@"有没有团购%@",self.shopDetail.has_deal);
//    NSLog(@"团购数量%@",self.shopDetail.deal_count);
//    NSLog(@"有没有优惠劵%@",self.shopDetail.has_coupon);
//    NSLog(@"优惠券ID%@",self.shopDetail.coupon_id);
//    NSLog(@"团购列表%@",self.shopDetail.deals);
    
    
}
//请求数据失败之后执行代理方法
- (void)request:(NetWorkRequest *)netWorkRequest
didFailWithError:(NSError *)error
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"网络连接失败" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    
    [alertView show];
    [alertView release];
}
- (void)layout
{
    
    int my_y = 0;
    if (self.view.frame.size.height == 568) {
        my_y = 0;
    }else{
        my_y = Y;
    }
    
    
    _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(X+5, my_y, 320-10, 30)];
    _nameLabel.text = @"店名";
    _nameLabel.backgroundColor = [UIColor whiteColor];
    _nameLabel.textAlignment = NSTextAlignmentCenter;
    [_scrollView addSubview:_nameLabel];
    
    
    _photo_url = [[UIImageView alloc] initWithFrame:CGRectMake(X+5, my_y+ 35, 145, 140)];
    _photo_url.backgroundColor = [UIColor whiteColor];
    [_scrollView  addSubview:_photo_url];
    
    
    _rating_img_url = [[UIImageView alloc] initWithFrame:CGRectMake(X+155, my_y+ 35, 160, 30)];
    _rating_img_url.backgroundColor = [UIColor whiteColor];
    [_scrollView addSubview:_rating_img_url];
    
    
    _decoration_grade = [[UILabel alloc] initWithFrame:CGRectMake(X+155, my_y+ 72, 160, 30)];
    _decoration_grade.backgroundColor = [UIColor whiteColor];
    _decoration_grade.text = @"环境评价";
    _decoration_grade.textAlignment = NSTextAlignmentCenter;
    [_scrollView addSubview:_decoration_grade];
    
    
    _service_grade = [[UILabel alloc] initWithFrame:CGRectMake(X+155, my_y+ 107, 160, 30)];
    _service_grade.backgroundColor = [UIColor whiteColor];
    _service_grade.text = @"服务评价";
    _service_grade.textAlignment = NSTextAlignmentCenter;
    [_scrollView addSubview:_service_grade];
    
    
    _avg_price = [[UILabel alloc] initWithFrame:CGRectMake(X+155, my_y+ 145, 160, 30)];
    _avg_price.backgroundColor = [UIColor whiteColor];
    _avg_price.text = @"人均价格";
    _avg_price.textAlignment = NSTextAlignmentCenter;
    [_scrollView addSubview:_avg_price];
    
    
    UIImageView *imageView_1 = [[UIImageView alloc] initWithFrame:CGRectMake(X+5, my_y+190, 25, 25)];
//    imageView_1.backgroundColor = [UIColor orangeColor];
    imageView_1.image = [UIImage imageNamed:@"detail_map@2x.png"];
    [_scrollView addSubview:imageView_1];
    [imageView_1 release];
    
    UIImageView *imageView_2 = [[UIImageView alloc] initWithFrame:CGRectMake(X+5, my_y+250, 25, 25)];
//    imageView_2.backgroundColor = [UIColor orangeColor];
    imageView_2.image = [UIImage imageNamed:@"detail_tel@2x.png"];
    [_scrollView addSubview:imageView_2];
    [imageView_2 release];
    
    
    
    _address = [[UILabel alloc] initWithFrame:CGRectMake(X+35, my_y+180, 280, 60)];
    _address.text = @"地址";
//    _address.backgroundColor = [UIColor orangeColor];
    _address.textAlignment = NSTextAlignmentCenter;
    _address.font = [UIFont systemFontOfSize:15.0];
    _address.numberOfLines = 0;
    _address.userInteractionEnabled = YES;
    [_scrollView addSubview:_address];
    
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(navigation:)];
    tap.numberOfTapsRequired = 1;
    tap.numberOfTouchesRequired = 1;
    
    [_address addGestureRecognizer:tap];
    [tap release];
    
    
    
    _telephone = [[UIButton alloc] initWithFrame:CGRectMake(X+35, my_y+240, 280, 40)];
    [_telephone setTitle:@"联系电话" forState:UIControlStateNormal];
//    _telephone.backgroundColor = [UIColor orangeColor];
    [_telephone setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    [_scrollView addSubview:_telephone];

    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(X+5, my_y+300, 310, 80) style:UITableViewStylePlain];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    _tableView.backgroundColor = [UIColor orangeColor];
    [_scrollView addSubview:_tableView];
    [_tableView release];
    
    
    
    _btnView = [[UIView alloc] initWithFrame:CGRectMake(X+5, my_y+390, 310, 160)];
    [_scrollView addSubview:_btnView];
    
    _moreBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    _moreBtn.frame = CGRectMake(0, 0, 310, 40);
    [_moreBtn setTitle:@"获得更多商家信息" forState:UIControlStateNormal];
    [_moreBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    _moreBtn.backgroundColor = [UIColor orangeColor];
    [_moreBtn addTarget:self action:@selector(more) forControlEvents:UIControlEventTouchUpInside];
    [_btnView addSubview:_moreBtn];
    
    _commentBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    _commentBtn.frame = CGRectMake(0, 50, 310, 40);
    [_commentBtn setTitle:@"获得商家点评信息" forState:UIControlStateNormal];
    [_commentBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    _commentBtn.backgroundColor = [UIColor orangeColor];
    [_commentBtn addTarget:self action:@selector(comment) forControlEvents:UIControlEventTouchUpInside];
    [_btnView addSubview:_commentBtn];
    
}
#pragma mark - tableView_delegate
//点击cell触发事件
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        if ([self.shopDetail.has_deal intValue] == 1) {
            NSMutableArray *arr = [[NSMutableArray alloc] init];
//            NSLog(@"%@",self.shopDetail.deals);
            for (NSDictionary *dic in self.shopDetail.deals) {
                [arr addObject:[dic objectForKey:@"id"]];
            }
            ShopGroupList *shop = [[ShopGroupList alloc] init];
            shop.shopGropArr = arr;
            shop.title = @"该商家支持的团购";
            [self.navigationController pushViewController:shop animated:YES];
            [shop release];
            
//            NSLog(@"支持的团购数组 = %@",arr);
            [arr release];
            
        }
    }else{
        if ([self.shopDetail.has_coupon intValue] == 1) {
            NSLog(@"支持的优惠券ID = %@",self.shopDetail.coupon_id);
            CouponsVCForShop *couponForShop = [[CouponsVCForShop alloc] init];
            couponForShop.CouponID = self.shopDetail.coupon_id;
            [self.navigationController pushViewController:couponForShop animated:YES];
            [couponForShop release];
        }
        
    }
//    NSLog(@"section  = %d  row = %d",indexPath.section,indexPath.row);
}
//设置某一个cell的高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView;
{
    return 1;
}
//配置每个分区中有多少行
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *reuseIdentifier = @"reuse";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    
    if (nil == cell) {
//        NSLog(@"创建了 cell");
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:reuseIdentifier] autorelease];
    }
    
    if (indexPath.row == 0) {
        cell.textLabel.text = @"该商家支持的团购";
        cell.detailTextLabel.text = [NSString stringWithFormat:@"(%@)",[(NSNumber *)self.shopDetail.deal_count stringValue]];;
        
        if ([(NSNumber *)self.shopDetail.deal_count intValue]  > 0) {
             cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
    }else{
        cell.textLabel.text = @"该商家支持的优惠券";
        cell.detailTextLabel.text = [NSString stringWithFormat:@"(%@)",[(NSNumber *)self.shopDetail.has_coupon stringValue]];
        
        if ([(NSNumber *)self.shopDetail.has_coupon intValue] > 0) {
             cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;

   
    return cell;
    
    
}
# pragma mark 导航
- (void)navigation:(UITapGestureRecognizer *)tap
{
    //开始的地标
    MKPlacemark *startMark = [[MKPlacemark alloc] initWithCoordinate:CLLocationCoordinate2DMake(self.theNewLocation.coordinate.latitude, self.theNewLocation.coordinate.longitude) addressDictionary:[NSDictionary dictionaryWithObjectsAndKeys:@"我的位置",(NSString *)kABPersonAddressStreetKey, nil]];
    MKMapItem *startItem = [[MKMapItem alloc] initWithPlacemark:startMark];
    [startMark release];
    //结束的地标
    NSString *lat = self.shopDetail.latitude;
    NSString *log = self.shopDetail.longitude;
    
    MKPlacemark *endMark = [[MKPlacemark alloc] initWithCoordinate:CLLocationCoordinate2DMake([lat floatValue], [log floatValue]) addressDictionary:[NSDictionary dictionaryWithObjectsAndKeys:self.shopDetail.address,(NSString *)kABPersonAddressStreetKey, nil]];
    MKMapItem *endItem = [[MKMapItem alloc] initWithPlacemark:endMark];
    [endMark release];
    
    NSArray *items = [NSArray arrayWithObjects:startItem,endItem, nil];
    [startItem release];
    [endItem release];
    
    //打开系统地图
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:MKLaunchOptionsDirectionsModeDriving,MKLaunchOptionsDirectionsModeKey, nil];
    [MKMapItem openMapsWithItems:items launchOptions:dic];
}

- (void)callPhone:(UIButton *)btn
{
    NSString *phoneNum = [btn titleForState:UIControlStateNormal];// 电话号码
    NSString *num = [[NSString alloc]initWithFormat:@"确定要拨打%@吗？",phoneNum]; //而这个方法则打电话前先弹框 是否打电话 然后打完电话之后回到程序中 网上说这个方法可能不合法 无法通过审核
    self.callPhoneAlertView = [[UIAlertView alloc] initWithTitle:@"提示" message:num delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [_callPhoneAlertView show];
}


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
            [arr addObject:self.shopID];
            [arr writeToFile:[self getFilePath] atomically:YES];
            
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"收藏成功" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
            [alertView show];
            [alertView release];
            [_collectBtn setImage:[UIImage imageNamed:@"icon_merchant_collect_selected@2x.png"] forState:UIControlStateNormal];
        }else{
            if ([arr containsObject:self.shopID]) {
                
                [arr removeObject:self.shopID];
                [arr writeToFile:[self getFilePath] atomically:YES];
                
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"取消收藏" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
                [alertView show];
                [alertView release];
                [_collectBtn setImage:[UIImage imageNamed:@"icon_merchant_collect@2x.png"] forState:UIControlStateNormal];
            }else
            {
                [arr addObject:self.shopID];
                [arr writeToFile:[self getFilePath] atomically:YES];
                
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"收藏成功" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
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


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView == _callPhoneAlertView && buttonIndex == 1) {
        NSString *phoneNum = [_telephone titleForState:UIControlStateNormal];// 电话号码
        NSString *num = [[NSString alloc]initWithFormat:@"tel://%@",phoneNum]; //而这个方法则打电话前先弹框 是否打电话 然后打完电话之后回到程序中 网上说这个方法可能不合法 无法通过审核
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:num]];
    }
}


- (void)shaerd
{
    [UMSocialSnsService presentSnsIconSheetView:self
                                         appKey:@"533e61c556240b5a190127cc"
                                      shareText:[NSString stringWithFormat:@"%@真的很不错哦，快来看看吧！就在%@",_shopDetail.name,_shopDetail.address]
                                     shareImage:_photo_url.image
                                shareToSnsNames:[NSArray arrayWithObjects:UMShareToSina,UMShareToTencent,UMShareToRenren,nil]
                                       delegate:nil];
}

//文件路径
- (NSString *)getFilePath
{
    NSString *filePath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    NSString *newFliePath = [filePath stringByAppendingPathComponent:@"ShopsCollect.txt"];
    return newFliePath;
}


- (void)comment
{
    CommentVC *commentVC = [[CommentVC alloc] init];
    commentVC.title = @"商家点评";
    commentVC.shopID = self.shopID;
    [self.navigationController pushViewController:commentVC animated:YES];
    [commentVC release];
}
- (void)more
{
    WebVC *webVC = [[WebVC alloc] init];
    webVC.title = @"商家更多信息";
    webVC.h5Url = _business_url;
    [self.navigationController pushViewController:webVC animated:YES];
    [webVC release];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)dealloc
{
    [_shopDetail release];
    [_scrollView release];
    [_request release];
    
    [_nameLabel release];
    [_photo_url release];
    [_rating_img_url release];
    [_decoration_grade release];
    [_service_grade release];
    [_avg_price release];
    [_address release];
    [_telephone release];
//    [_coupon_description release];
//    [_deals_description release];
    [_btnView release];
    [_callPhoneAlertView release];
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
