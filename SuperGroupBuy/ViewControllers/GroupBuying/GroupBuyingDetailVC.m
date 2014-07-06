//
//  GroupBuyingDetailVC.m
//  SuperGroupBuying
//
//  Created by lanouhn on 14-4-2.
//  Copyright (c) 2014年 lanouhn. All rights reserved.
//

#import "GroupBuyingDetailVC.h"
#import "WebVC.h"
#import "GroupBuyingVC.h"
#import "GroupBuying.h"
#import "WebImageManager.h"
#import "WebImageView.h"
#import "GroupShopList.h"
#import "UMSocial.h"
#import "CollectGroupVC.h"
#import "UserInfoHandle.h"
#import "RennSDK/RennSDK.h"
#import "UIWindow+YzdHUD.h"

#define MARGIN_LEFT 5
#define MARGIN_TOP 200
@interface GroupBuyingDetailVC ()
{
    UIScrollView *_scrollView;
    WebImageView *_image;
    CollectGroupVC *_collect;
    NSMutableArray *_array;
    NSMutableArray *_all ;
    UIButton *_collectBtn;
    BOOL user;
}
@property (nonatomic,retain) NSMutableData *data;
@end

@implementation GroupBuyingDetailVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
//        _collect = [[CollectGroupVC alloc] init];
    }
    return self;
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
//    self.tabBarController.tabBar.hidden = YES;
    if ([UserInfoHandle sharedHanle].userDic != nil) {
        user = YES;
    }else{
        user = NO;
    }
    NSArray *readArr = [NSArray arrayWithContentsOfFile:[self getFilePath]];
    
    for (NSString *str in readArr) {
        if ([self.groupDetail.deal_id intValue] == [str intValue]) {
            [_collectBtn setImage:[UIImage imageNamed:@"icon_merchant_collect_selected@2x.png"] forState:UIControlStateNormal];
        }
    }

}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
//    self.view.backgroundColor = [UIColor lightTextColor];
    self.navigationItem.title = @"团购详情";
    _array = [[NSMutableArray alloc] init];
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
   _all = [[NSMutableArray alloc]init];
    [self creatView];
    
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] init];
    barButtonItem.title = @"";
    self.navigationItem.backBarButtonItem = barButtonItem;[barButtonItem release];

    
}
- (void)shaerd
{
    [UMSocialSnsService presentSnsIconSheetView:self
                                         appKey:@"533e61c556240b5a190127cc"
                                      shareText:[NSString stringWithFormat:@"%@真的很不错哦，快来看看吧！",_groupDetail.title]
                                     shareImage:_image.image
                                shareToSnsNames:[NSArray arrayWithObjects:UMShareToSina,UMShareToTencent,UMShareToRenren,nil]
                                       delegate:nil];
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
            [arr addObject:self.groupDetail.deal_id];
            [arr writeToFile:[self getFilePath] atomically:YES];
            
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"收藏成功" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
            [alertView show];
            [alertView release];
            [_collectBtn setImage:[UIImage imageNamed:@"icon_merchant_collect_selected@2x.png"] forState:UIControlStateNormal];
        }else{
            if ([arr containsObject:self.groupDetail.deal_id]) {
                
                [arr removeObject:self.groupDetail.deal_id];
                [arr writeToFile:[self getFilePath] atomically:YES];
                
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"取消收藏" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
                [alertView show];
                [alertView release];
                [_collectBtn setImage:[UIImage imageNamed:@"icon_merchant_collect@2x.png"] forState:UIControlStateNormal];
            }else
            {
                [arr addObject:self.groupDetail.deal_id];
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

//文件路径
- (NSString *)getFilePath
{
    NSString *filePath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    NSString *newFliePath = [filePath stringByAppendingPathComponent:@"GroupBuyingCollect.txt"];
    return newFliePath;
}

- (void)creatView
{
    _scrollView = [[UIScrollView alloc] initWithFrame:self.view.frame];
    _scrollView.showsVerticalScrollIndicator = NO;
    //团购图片
    _image = [[WebImageView alloc] initWithFrame:CGRectMake(MARGIN_LEFT, 0, 310, 200)];
    _image.backgroundColor = [UIColor greenColor];
    _image.placeholderImage = [UIImage imageNamed:@"loading.jpg"];
    _image.imageURL = [NSURL URLWithString:self.groupDetail.image_url];
    
    [_scrollView addSubview:_image];
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(MARGIN_LEFT, MARGIN_TOP, 310, 90)];
//        view.backgroundColor = [UIColor grayColor];
    [_scrollView addSubview:view];
    [view release];

    
    
    
    UILabel *curretLable = [[UILabel alloc] initWithFrame:CGRectMake(0, 0,200, 50)];
    curretLable.text = [NSString stringWithFormat:@" ¥%.2f",self.groupDetail.current_price];
    curretLable.textColor = [UIColor orangeColor];
    curretLable.font = [UIFont fontWithName:@"Arial" size:20];
    [view addSubview:curretLable];
    [curretLable release];
    
    
   //原价值
    UILabel *list_priceLable = [[UILabel alloc] initWithFrame:CGRectMake(0, 40, 150, 40)];
    
    list_priceLable.text = [NSString stringWithFormat:@"¥ %.2f",self.groupDetail.list_price];
//    list_priceLable.backgroundColor = [UIColor redColor];
    [self setCenterLineView:list_priceLable];
    
    [view addSubview:list_priceLable];
    [list_priceLable release];
    //立即抢购
    UIButton *snappedUpBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    snappedUpBtn.frame = CGRectMake(235, 2, 70, 40);
    snappedUpBtn.backgroundColor = [UIColor orangeColor];
    [snappedUpBtn setTitle:@"立即抢购" forState:UIControlStateNormal];
    [snappedUpBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [snappedUpBtn addTarget:self action:@selector(purchase:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:snappedUpBtn];
    //结束日期
    UILabel *purchase_deadline = [[UILabel alloc] initWithFrame:CGRectMake(160, 45, 200, 40)];
    purchase_deadline.text = [NSString stringWithFormat:@"截止 %@",self.groupDetail.purchase_deadline] ;
//    purchase_deadline.backgroundColor = [UIColor redColor];
    
    [view addSubview:purchase_deadline];
    [purchase_deadline release];
    
    UILabel *titleLable = [[UILabel alloc] initWithFrame:CGRectMake(MARGIN_LEFT,MARGIN_TOP+90, 310, 50)];
    titleLable.text = @"团购描述";
    [_scrollView addSubview:titleLable];
    [titleLable release];
    //团购详情
    UILabel *descriptionLable = [[UILabel alloc] initWithFrame:CGRectMake(MARGIN_LEFT, MARGIN_TOP+140, 310, [self heightForString:self.groupDetail.description])];
    descriptionLable.text = self.groupDetail.description;
    descriptionLable.layer.borderColor = [UIColor grayColor].CGColor;
    descriptionLable.layer.borderWidth = 1;
    [descriptionLable setNumberOfLines:0];
    [_scrollView addSubview:descriptionLable];
    [descriptionLable release];
    NSMutableArray *idArr = [[NSMutableArray alloc] init];
    for (NSDictionary *tempDic in self.groupDetail.businesses) {
        [idArr addObject:[tempDic objectForKey:@"id"]];
    }

    //适合团购的商家列表
    UIButton *shopListBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    shopListBtn.frame = CGRectMake(MARGIN_LEFT, [self heightForString:self.groupDetail.description] + MARGIN_TOP+140, 310, 50);
    [shopListBtn setTitle:[NSString stringWithFormat:@"适合团购的商家(%d)",[idArr count]] forState:UIControlStateNormal];
    [idArr release];
    [shopListBtn addTarget:self action:@selector(shoplist:) forControlEvents:UIControlEventTouchUpInside];
    shopListBtn.backgroundColor = [UIColor orangeColor];
    [shopListBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_scrollView addSubview:shopListBtn];

    _scrollView.contentSize = CGSizeMake(320,[self heightForString:self.groupDetail.description] + MARGIN_TOP+140+50+70);
 
    

    
    [self.view addSubview:_scrollView];
}
//设置中划线
- (void)setCenterLineView:(UILabel *)label
{
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:1],NSStrikethroughStyleAttributeName, nil];
    label.font = [UIFont fontWithName:@"Thonburi-Bold" size:12];
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:label.text attributes:dic];
    label.attributedText = str;
}


- (CGFloat)heightForString:(NSString *)description
{
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:14],NSFontAttributeName, nil];
    CGSize size = [description boundingRectWithSize:CGSizeMake(200, 1000) options:NSStringDrawingUsesLineFragmentOrigin attributes:dic context:nil].size;
    return size.height;
}

//立即抢购
- (void)purchase:(UIButton *)snappedUpBtn
{
    WebVC *webVC = [[WebVC alloc] init];
//    NSArray *arr = [[NSMutableArray alloc] init];
//    arr = [self.groupDetail.deal_id componentsSeparatedByString:@"-"];
    
    webVC.h5Url = self.groupDetail.deal_h5_url;
    
//    [NSString stringWithFormat:@"http://m.dianping.com/tuan/buy/%@",[arr objectAtIndex:1]];

    
    webVC.title = @"立即抢购";
    [self.navigationController pushViewController:webVC animated:YES];
    [webVC release];
}
- (void)shoplist:(UIButton *)shopListBtn
{
    GroupShopList *shopList = [[GroupShopList alloc] init];

    shopList.businessArr = self.groupDetail.businesses;

    [self.navigationController pushViewController:shopList animated:YES];
    [shopList release];
    
    
}

//返回团购列表
- (void)returnBack
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)dealloc
{
    [_all release];
    [_image release];
    [_array release];
    [_collect release];
    [_scrollView release];
    [_string release];
    [_groupDetail release];
    [_detailCollArr release];
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
