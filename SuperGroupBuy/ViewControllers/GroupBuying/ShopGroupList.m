//
//  ShopGroupList.m
//  SuperGroupBuy
//
//  Created by lanou3g on 14-4-22.
//  Copyright (c) 2014年 lanouhn. All rights reserved.
//

#import "ShopGroupList.h"
#import "SignatrueEncryption.h"
#import "CommonDefine.h"
#import "NetWorkRequest.h"
#import "GroupBuying.h"
#import "GroupBuyingDetailVC.h"
#import "GroupBuyingCell.h"

@interface ShopGroupList ()
{
    NetWorkRequest *_request;
    NSMutableArray *_groupBuyingArr;

}
@end

@implementation ShopGroupList

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
    _request = [[NetWorkRequest alloc] init];
    _request.deligate = self;
    _groupBuyingArr = [[NSMutableArray alloc] init];
    self.view.backgroundColor = [UIColor whiteColor];
//    UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    leftButton.frame = CGRectMake(10, 0, 30, 30);
//    [leftButton addTarget:self action:@selector(returnBtn:) forControlEvents:UIControlEventTouchUpInside];
//    [leftButton setBackgroundImage:[UIImage imageNamed:@"common_navi_bar_icon_back_rest@2x"] forState:UIControlStateNormal];
//    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
//    self.navigationItem.leftBarButtonItem = leftItem;
//    [leftItem release];

    for (NSString *str in self.shopGropArr) {
        [self loadDate:str];
//        NSLog(@"========%@",str);
    }
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] init];
    barButtonItem.title = @"";
    self.navigationItem.backBarButtonItem = barButtonItem;[barButtonItem release];

    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}
- (void)loadDate:(NSString *)str
{
    NSMutableDictionary *parmDic = [NSMutableDictionary dictionaryWithObjectsAndKeys:str,@"deal_ids", nil];
    NSMutableDictionary *enCryDic = [SignatrueEncryption encryptedParamsWithBaseParams:parmDic];
    
    //    NSLog(@"0000000000000%@",str);
    NSString *urlString = [NSString stringWithFormat:@"http://api.dianping.com/v1/deal/get_batch_deals_by_id?appkey=%@&sign=%@&deal_ids=%@",kAPP_KEY,[enCryDic objectForKey:@"sign"],[enCryDic objectForKey:@"deal_ids"]];
    //    NSLog(@"++++++++++++%@",urlString);
    
//    NSLog(@";;;;;;;;;;;;;%@",urlString);
    
    [_request loadDataWithURLString:urlString];
//    [self.tableView reloadData];





}

- (void)request:(NetWorkRequest *)netWorkRequest
   didFinishing:(NSData *)data
{
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
    NSArray *dealArr = [dic objectForKey:@"deals"];
    for (NSDictionary *tempDic in dealArr) {
        GroupBuying *groupBuy = [[GroupBuying alloc] initWithGroupBuying:tempDic];
//        NSLog(@"____________________++++++++++%@", groupBuy);
        [_groupBuyingArr addObject:groupBuy];
        [groupBuy release];
    }
    [self.tableView reloadData];
}

//请求数据失败之后执行代理方法
- (void)request:(NetWorkRequest *)netWorkRequest
didFailWithError:(NSError *)error
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"警告" message:@"网络链接失败" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:@"完成", nil];
    [alertView show];
    [alertView release];
    NSLog(@"警告");

}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 106;
    
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{

    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    // Return the number of rows in the section.
    return [_groupBuyingArr count];
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    GroupBuyingDetailVC *groupDetail = [[GroupBuyingDetailVC alloc] init];
    [self.navigationController pushViewController:groupDetail animated:YES];
    groupDetail.groupDetail = [_groupBuyingArr objectAtIndex:indexPath.row];
    [groupDetail release];
    
    
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *str = @"reuse";
    GroupBuyingCell *cell = [tableView dequeueReusableCellWithIdentifier:str];
    if (cell == nil) {
        cell = [[[GroupBuyingCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:str] autorelease];
    }
    
    // Configure the cell...
    //    cell.textLabel.text = [_groupBuyingArr objectAtIndex:indexPath.row];
    GroupBuying *group = [_groupBuyingArr objectAtIndex:indexPath.row];;
    [cell configurationGroupBuyingCell:group];
    
    return cell;

}
- (void)returnBtn:(UIButton *)button
{
    [self.navigationController popViewControllerAnimated:YES];
    
    
    
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
