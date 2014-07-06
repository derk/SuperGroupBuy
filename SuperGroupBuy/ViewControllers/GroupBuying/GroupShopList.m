//
//  GroupShopList.m
//  SuperGroupBuy
//
//  Created by lanouhn on 14-4-14.
//  Copyright (c) 2014年 lanouhn. All rights reserved.
//

#import "GroupShopList.h"
#import "NetWorkRequest.h"
#import "SignatrueEncryption.h"
#import "CommonDefine.h"
#import "UIWindow+YzdHUD.h"
#import "Shops.h"
#import "ShopDetailVC.h"
#import "ShopCell.h"
@interface GroupShopList ()

@property (nonatomic,retain)NSMutableArray *shopArr;
@property (nonatomic,retain)NSMutableArray *shopIDArr;
@end

@implementation GroupShopList

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    self.navigationItem.title = @"适合团购的商家";
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] init];
    barButtonItem.title = @"";
    self.navigationItem.backBarButtonItem = barButtonItem;
    [barButtonItem release];

    self.shopArr = [[NSMutableArray alloc] init];
    self.shopIDArr = [[NSMutableArray alloc] init];
    for (NSDictionary *dic in self.businessArr) {
        NSString *str = [(NSNumber *)[dic objectForKey:@"id"] stringValue];
        [_shopIDArr addObject:str];
    }
//    NSLog(@"%@",_shopIDArr);
    for (NSString *str in _shopIDArr) {
        [self loadData:str];
    }
}
- (void)loadData:(NSString *)business_ids;
{
    
    NSMutableDictionary *dicIn = [NSMutableDictionary dictionaryWithObjectsAndKeys:business_ids,@"business_ids",nil];
    NSMutableDictionary *dicOut = [SignatrueEncryption encryptedParamsWithBaseParams:dicIn];
    
    NSString *urlString = [NSString stringWithFormat:@"http://api.dianping.com/v1/business/get_batch_businesses_by_id?appkey=%@&sign=%@&business_ids=%@",kAPP_KEY,[dicOut objectForKey:@"sign"],[dicOut objectForKey:@"business_ids"]];
    NetWorkRequest *request = [[NetWorkRequest alloc] init];
    request.deligate = self;
    [request loadDataWithURLString:urlString];
    NSLog(@"%@",urlString);
    [request release];
}
#pragma mark 请求请求数据完成后
//请求数据成功之后执行代理方法
- (void)request:(NetWorkRequest *)netWorkRequest
   didFinishing:(NSData *)data
{
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
    NSArray *arr = [dic objectForKey:@"businesses"];
    
    if ([arr count] != 0) {
        NSDictionary *tempDic = [arr objectAtIndex:0];
        Shops *shop = [[Shops alloc] initWithDic:tempDic];
        [_shopArr addObject:shop];
        [shop release];
        if ([_shopArr count] == [_shopIDArr count]) {
            [self tableView:self.tableView cellForRowAtIndexPath:self.tableView.indexPathForSelectedRow];
            [self.tableView reloadData];
        }
    }
   
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


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

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

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
