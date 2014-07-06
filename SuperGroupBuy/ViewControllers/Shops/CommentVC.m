//
//  CommentVC.m
//  SuperGroupBuying
//
//  Created by lanouhn on 14-4-3.
//  Copyright (c) 2014年 lanouhn. All rights reserved.
//

#import "CommentVC.h"
#import "WebVC.h"
#import "CommentCell.h"
#import "NetWorkRequest.h"
#import "SignatrueEncryption.h"
#import "CommonDefine.h"
#import "ShopComment.h"
#import "UIWindow+YzdHUD.h"
@interface CommentVC ()
{
    NetWorkRequest *_request;
    NSMutableArray *_commentArr;
}
@end

@implementation CommentVC

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
    [self.tableView reloadData];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] init];
    barButtonItem.title = @"";
    self.navigationItem.backBarButtonItem = barButtonItem;
    self.tableView.showsVerticalScrollIndicator = NO;
    
    _commentArr = [[NSMutableArray alloc] init];
    
    _request = [[NetWorkRequest alloc] init];
    _request.deligate = self;
    [self loadData];
    [self.tableView reloadData];

}

- (void)loadData
{
    NSMutableDictionary *dicIn = [[NSMutableDictionary alloc] initWithObjectsAndKeys:self.shopID,@"business_id",@"2",@"platform",nil];
    NSMutableDictionary *dicOut = [SignatrueEncryption encryptedParamsWithBaseParams:dicIn];
    
    NSString *urlString = [NSString stringWithFormat:@"http://api.dianping.com/v1/review/get_recent_reviews?appkey=%@&sign=%@&business_id=%@&platform=%d",kAPP_KEY,[dicOut objectForKey:@"sign"],[dicOut objectForKey:@"business_id"],[[dicOut objectForKey:@"platform"] intValue]];
//    NSLog(@"%@",urlString);
    [_request loadDataWithURLString:urlString];
}

//请求数据成功之后执行代理方法
- (void)request:(NetWorkRequest *)netWorkRequest
   didFinishing:(NSData *)data
{
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
    
    NSArray *array = [dic objectForKey:@"reviews"];
    

    for (NSDictionary *tempDic in array) {
        ShopComment *shopComment = [[ShopComment alloc] initWithDic:tempDic];
        [_commentArr addObject:shopComment];
        [shopComment release];
    }
    [self.tableView reloadData];
    
//    UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
//    btn.frame = CGRectMake(0, 0, 320, 44);
//    [btn setTitle:@"更多点评" forState:UIControlStateNormal];
//    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//    [btn addTarget:self action:@selector(more) forControlEvents:UIControlEventTouchUpInside];
//    self.tableView.tableFooterView = btn;
    [self.view.window showHUDWithText:@"加载成功" Type:ShowPhotoYes Enabled:YES];
}

- (void)more
{
    ShopComment *shopComment = [_commentArr objectAtIndex:0];
    WebVC *webVC = [[WebVC alloc] init];
    webVC.title = @"更多点评";
//    NSLog(@"%@",shopComment.additional_info_more_reviews_url);
    
    webVC.h5Url = shopComment.additional_info_more_reviews_url;
    [self.navigationController pushViewController:webVC animated:YES];
    [webVC release];
}
//请求数据失败之后执行代理方法
- (void)request:(NetWorkRequest *)netWorkRequest
didFailWithError:(NSError *)error
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"网络连接失败" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    
    [alertView show];
    [alertView release];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ShopComment *shopComment = [_commentArr objectAtIndex:indexPath.row];
    WebVC *webVC = [[WebVC alloc] init];
    webVC.title = @"点评详情";
    webVC.h5Url = shopComment.review_url;
    [self.navigationController pushViewController:webVC animated:YES];
    [webVC release];
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 150;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_commentArr count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *reuser = @"reuse";
    CommentCell *cell = [tableView dequeueReusableCellWithIdentifier:reuser];
    if (cell == nil) {
        cell = [[[CommentCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:reuser] autorelease];
    }
    
//    NSLog(@"%d",[_commentArr count]);
    
    ShopComment *shopComment = [_commentArr objectAtIndex:indexPath.row];
    [cell configerCellWithShopComment:shopComment];
    
    return cell;
}

-(void)dealloc
{
    [_request release];
    [_commentArr release];
    [super dealloc];
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
