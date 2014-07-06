//
//  CollectGroupVC.m
//  SuperGroupBuy
//
//  Created by lanouhn on 14-4-15.
//  Copyright (c) 2014年 lanouhn. All rights reserved.
//

#import "CollectGroupVC.h"
#import "GroupBuyingDetailVC.h"
#import "GroupBuying.h"
#import "GroupBuyingCell.h"
#import "GroupBuyingDetailVC.h"
#import "UIWindow+YzdHUD.h"
#import "NetWorkRequest.h"
#import "SignatrueEncryption.h"
#import "CommonDefine.h"

@interface CollectGroupVC ()
@property (nonatomic,retain)NSMutableArray *arr;
@property (nonatomic,retain)NSMutableArray *groupArr;

@end

@implementation CollectGroupVC

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
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationController.navigationBar.tintColor = [UIColor orangeColor];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"我的团购收藏";

    NSArray *readArr = [NSArray arrayWithContentsOfFile:[self getFilePath]];
    
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] init];
    backItem.title = @"";
    self.navigationItem.backBarButtonItem = backItem;
    [backItem release];
    
    self.arr = [NSMutableArray arrayWithArray:readArr];
    self.groupArr = [[NSMutableArray alloc] init];
    
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
        [self.groupArr removeAllObjects];
        
        for (NSString *str in _arr) {
            [self loadData:str];
        }
        [self.tableView reloadData];
        
    }
}

- (void)loadData:(NSString *)deal_id;
{
    NSLog(@"%@",deal_id);
    
    NSMutableDictionary *dicIn = [NSMutableDictionary dictionaryWithObjectsAndKeys:deal_id,@"deal_id",nil];
    
    
    NSMutableDictionary *dicOut = [SignatrueEncryption encryptedParamsWithBaseParams:dicIn];
    
    NSString *urlString = [NSString stringWithFormat:@"http://api.dianping.com/v1/deal/get_single_deal?appkey=%@&sign=%@&deal_id=%@",kAPP_KEY,[dicOut objectForKey:@"sign"],[dicOut objectForKey:@"deal_id"]];
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
    NSArray *arr = [dic objectForKey:@"deals"];
    NSDictionary *tempDic = [arr objectAtIndex:0];
    GroupBuying *groupBuying = [[GroupBuying alloc] initWithGroupBuying:tempDic];
    [_groupArr addObject:groupBuying];
    [groupBuying release];
    
    [self tableView:self.tableView cellForRowAtIndexPath:self.tableView.indexPathForSelectedRow];
    [self.tableView reloadData];
    
    
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
    NSString *newFliePath = [filePath stringByAppendingPathComponent:@"GroupBuyingCollect.txt"];
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
    return [_groupArr count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *reuser = @"reuse";
    GroupBuyingCell *cell = [tableView dequeueReusableCellWithIdentifier:reuser];
    if (cell == nil) {
        cell = [[[GroupBuyingCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:reuser] autorelease];
    }
    GroupBuying *groupBuying = [_groupArr objectAtIndex:indexPath.row];
    [cell configurationGroupBuyingCell:groupBuying];
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
        [_groupArr removeObjectAtIndex:indexPath.row];
        [_arr removeObjectAtIndex:indexPath.row];
        [_arr writeToFile:[self getFilePath] atomically:YES];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
}

-(void)dealloc
{
    [_arr release];
    [_groupArr release];
    [super dealloc];
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

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
