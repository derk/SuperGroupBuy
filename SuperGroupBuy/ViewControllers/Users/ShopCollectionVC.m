//
//  ShopCollectionVC.m
//  SuperGroupBuying
//
//  Created by lanouhn on 14-4-3.
//  Copyright (c) 2014年 lanouhn. All rights reserved.
//

#import "ShopCollectionVC.h"
#import "NetWorkRequest.h"
#import "SignatrueEncryption.h"
#import "CommonDefine.h"
#import "Shops.h"
#import "ShopCell.h"
#import "ShopDetailVC.h"
#import "UIWindow+YzdHUD.h"
@interface ShopCollectionVC ()
@property (nonatomic,retain)NSMutableArray *arr;
@property (nonatomic,retain)NSMutableArray *shopArr;
@end

@implementation ShopCollectionVC

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
    
//    self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    self.navigationItem.title = @"我收藏的商家";
    NSArray *readArr = [NSArray arrayWithContentsOfFile:[self getFilePath]];
    
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] init];
    backItem.title = @"";
    self.navigationItem.backBarButtonItem = backItem;
    [backItem release];
    
    self.arr = [NSMutableArray arrayWithArray:readArr];
    self.shopArr = [[NSMutableArray alloc] init];
    
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
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"确定要删除所有收藏的商家吗？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
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
//        self.shopArr = [[NSMutableArray alloc] init];
        [self.shopArr removeAllObjects];
        
        for (NSString *str in _arr) {
            [self loadData:str];
        }
        [self.tableView reloadData];
        
    }
}

- (void)loadData:(NSString *)business_ids;
{
    [self.view.window showHUDWithText:@"加载中" Type:ShowLoading Enabled:YES];
    NSMutableDictionary *dicIn = [NSMutableDictionary dictionaryWithObjectsAndKeys:business_ids,@"business_ids",nil];
    
    
    NSMutableDictionary *dicOut = [SignatrueEncryption encryptedParamsWithBaseParams:dicIn];
    
    NSString *urlString = [NSString stringWithFormat:@"http://api.dianping.com/v1/business/get_batch_businesses_by_id?appkey=%@&sign=%@&business_ids=%@",kAPP_KEY,[dicOut objectForKey:@"sign"],[dicOut objectForKey:@"business_ids"]];
//    NSLog(@"%@",urlString);
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
    NSArray *arr = [dic objectForKey:@"businesses"];
    NSDictionary *tempDic = [arr objectAtIndex:0];
    Shops *shop = [[Shops alloc] initWithDic:tempDic];
    [_shopArr addObject:shop];
    [shop release];
    if ([_shopArr count] == [_arr count]) {
        [self tableView:self.tableView cellForRowAtIndexPath:self.tableView.indexPathForSelectedRow];
        [self.tableView reloadData];
    }
    [self.view.window showHUDWithText:@"加载成功" Type:ShowPhotoYes Enabled:YES];
}

//请求数据失败之后执行代理方法
- (void)request:(NetWorkRequest *)netWorkRequest
didFailWithError:(NSError *)error
{
    [self.view.window showHUDWithText:@"加载失败" Type:ShowPhotoNo Enabled:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    Shops *shop = [_shopArr objectAtIndex:indexPath.row];
    ShopDetailVC *shopDetailVC = [[ShopDetailVC alloc] init];
    shopDetailVC.title = @"商家详情";
    shopDetailVC.shopID = shop.business_id;
    [self.navigationController pushViewController:shopDetailVC animated:YES];
    [shopDetailVC release];
}
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
    return [_shopArr count];
}

//文件路径
- (NSString *)getFilePath
{
    NSString *filePath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    NSString *newFliePath = [filePath stringByAppendingPathComponent:@"ShopsCollect.txt"];
    return newFliePath;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *reuser = @"reuse";
    ShopCell *cell = [tableView dequeueReusableCellWithIdentifier:reuser];
    if (cell == nil) {
        cell = [[[ShopCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:reuser] autorelease];
    }
    
    Shops *shop = [_shopArr objectAtIndex:indexPath.row];
    [cell configerCellWithShop:shop];
    return cell;

}
- (void)dealloc
{
    [_arr release];
    [_shopArr release];
    [super dealloc];
}
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [_shopArr removeObjectAtIndex:indexPath.row];
        [_arr removeObjectAtIndex:indexPath.row];
        [_arr writeToFile:[self getFilePath] atomically:YES];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
}

@end
