//
//  CouponCollectionVC.m
//  SuperGroupBuy
//
//  Created by lanou3g on 14-4-22.
//  Copyright (c) 2014年 lanouhn. All rights reserved.
//

#import "CouponCollectionVC.h"
#import "NetWorkRequest.h"
#import "SignatrueEncryption.h"
#import "CommonDefine.h"
#import "Coupons.h"
#import "UIWindow+YzdHUD.h"
#import "CouponCell.h"
@interface CouponCollectionVC ()
@property (nonatomic,retain)NSMutableArray *arr;
@property (nonatomic,retain)NSMutableArray *couponArr;
@end

@implementation CouponCollectionVC

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = NO;
    self.navigationController.navigationBar.tintColor = [UIColor orangeColor];
}
- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"我收藏的优惠券";
    NSArray *readArr = [NSArray arrayWithContentsOfFile:[self getFilePath]];
    
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] init];
    backItem.title = @"";
    self.navigationItem.backBarButtonItem = backItem;
    [backItem release];
    
    self.arr = [NSMutableArray arrayWithArray:readArr];
    self.couponArr = [[NSMutableArray alloc] init];
    
    for (NSString *str in _arr) {
        [self loadData:str];
    }
    
    UIButton *deleteBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    deleteBtn.frame = CGRectMake(0, 0, 25, 25);
    [deleteBtn setImage:[UIImage imageNamed:@"btn_search_clearhistory@2x.png"] forState:UIControlStateNormal];
    [deleteBtn addTarget:self action:@selector(deleteAll) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:deleteBtn];
    self.navigationItem.rightBarButtonItem = rightItem;
    [rightItem release];

    
}

- (void)deleteAll
{
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"确定要删除所有收藏的优惠券吗？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alertView show];
    [alertView release];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        NSArray *readArr_1 = [NSArray arrayWithContentsOfFile:[self getFilePath]];
        NSMutableArray *arr = [NSMutableArray arrayWithArray:readArr_1];
        [arr removeAllObjects];
        [arr writeToFile:[self getFilePath] atomically:YES];
        NSArray *readArr = [NSArray arrayWithContentsOfFile:[self getFilePath]];
        self.arr = [NSMutableArray arrayWithArray:readArr];
        [self.couponArr removeAllObjects];
        
        for (NSString *str in _arr) {
            [self loadData:str];
        }
        [self.tableView reloadData];
        
    }
}

- (void)loadData:(NSString *)coupon_id;
{
    NSLog(@"%@",coupon_id);
    
    NSMutableDictionary *dicIn = [NSMutableDictionary dictionaryWithObjectsAndKeys:coupon_id,@"coupon_id",nil];
    
    
    NSMutableDictionary *dicOut = [SignatrueEncryption encryptedParamsWithBaseParams:dicIn];
    
    NSString *urlString = [NSString stringWithFormat:@"http://api.dianping.com/v1/coupon/get_single_coupon?appkey=%@&sign=%@&coupon_id=%@",kAPP_KEY,[dicOut objectForKey:@"sign"],[dicOut objectForKey:@"coupon_id"]];
        NSLog(@"%@",urlString);
    NetWorkRequest *request = [[NetWorkRequest alloc] init];
    request.deligate = self;
    [request loadDataWithURLString:urlString];
    [request release];
}

#pragma mark 请求请求数据完成后
//请求数据成功之后执行代理方法
- (void)request:(NetWorkRequest *)netWorkRequest
   didFinishing:(NSData *)data
{
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
    NSArray *arr = [dic objectForKey:@"coupons"];
    NSDictionary *tempDic = [arr objectAtIndex:0];
    Coupons *coupon = [[Coupons alloc] initWithDictionary:tempDic];
    [_couponArr addObject:coupon];
    [coupon release];
    if ([_couponArr count] == [_arr count]) {
        [self tableView:self.tableView cellForRowAtIndexPath:self.tableView.indexPathForSelectedRow];
        [self.tableView reloadData];
    }
    
}

//请求数据失败之后执行代理方法
- (void)request:(NetWorkRequest *)netWorkRequest
didFailWithError:(NSError *)error
{
    [self.view.window showHUDWithText:@"加载失败" Type:ShowPhotoNo Enabled:YES];
}

//文件路径
- (NSString *)getFilePath
{
    NSString *filePath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    NSString *newFliePath = [filePath stringByAppendingPathComponent:@"CouponsCollect.txt"];
    return newFliePath;
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 110;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_couponArr count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *reuser = @"reuse";
    CouponCell *cell = [tableView dequeueReusableCellWithIdentifier:reuser];
    if (cell == nil) {
        cell = [[[CouponCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:reuser] autorelease];
    }
    Coupons *coupons = [_couponArr objectAtIndex:indexPath.row];
    [cell queryCoupon:coupons];
    return cell;

}


// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}



- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [_couponArr removeObjectAtIndex:indexPath.row];
        [_arr removeObjectAtIndex:indexPath.row];
        [_arr writeToFile:[self getFilePath] atomically:YES];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
}


/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

 */

@end
