//
//  CityListVC.m
//  SuperGroupBuying
//
//  Created by lanouhn on 14-4-2.
//  Copyright (c) 2014年 lanouhn. All rights reserved.
//

#import "CityListVC.h"
#import "SignatrueEncryption.h"
#import "CommonDefine.h"
#import "NetWorkRequest.h"
#import "ChineseToPinyin.h"
#import "UIWindow+YzdHUD.h"
@interface CityListVC ()
{
    NetWorkRequest *_request;
    NSMutableArray *_cityArr;
    NSMutableArray *_pinyinArr;
    NSMutableArray *_titleArr;
    NSMutableDictionary *_pinyinAndCity;
    NSMutableArray *_sectionArr;
    UISearchDisplayController *_searchDisplayController;
    
}
@property (nonatomic,retain)NSMutableArray *filterArr;
@end

@implementation CityListVC

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    
    if (self.cityFlag == 1) {
        self.navigationItem.title = @"商家支持城市";
    }else if(self.cityFlag == 2){
        self.navigationItem.title = @"优惠券支持城市";
    }else if (self.cityFlag == 3){
        self.navigationItem.title = @"团购支持城市";
    }
    self.navigationController.navigationBar.translucent = NO;
    self.navigationController.navigationBar.tintColor = [UIColor orangeColor];
//    self.tableView.showsVerticalScrollIndicator = NO;
    [self createLeftItem];
    [self createSearchBar];

    _request = [[NetWorkRequest alloc] init];
    
    _request.deligate = self;
    
    _cityArr = [[NSMutableArray alloc] init];
    _pinyinArr = [[NSMutableArray alloc] init];
    _titleArr = [[NSMutableArray alloc] init];
    _pinyinAndCity = [[NSMutableDictionary alloc] init];
    _sectionArr = [[NSMutableArray alloc] init];
    [self loadData];
    
    
    
}

- (void)createSearchBar
{
    UISearchBar *searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    searchBar.placeholder = @"搜索";
    self.tableView.tableHeaderView = searchBar;
    searchBar.delegate = self;
    [searchBar release];
    
    _searchDisplayController = [[UISearchDisplayController alloc] initWithSearchBar:searchBar contentsController:self];
    _searchDisplayController.searchResultsDataSource = self;
    _searchDisplayController.delegate = self;
    _searchDisplayController.searchResultsDelegate = self;
    
}
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF contains [cd] %@",searchText];
    for(int i=0; i< [searchText length];i++){
        int a = [searchText characterAtIndex:i];
        if( a > 0x4e00 && a < 0x9fff){
            self.filterArr = [NSMutableArray arrayWithArray:[[_cityArr filteredArrayUsingPredicate:predicate] sortedArrayUsingSelector:@selector(compare:)]];
        }else{
            self.filterArr = [NSMutableArray arrayWithArray:[[_pinyinArr filteredArrayUsingPredicate:predicate] sortedArrayUsingSelector:@selector(compare:)]];
        }
    }

}

- (void)createLeftItem
{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
    btn.frame = CGRectMake(0, 0, 40, 40);
    [btn setTitle:@"返回" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(pop) forControlEvents:UIControlEventTouchUpInside ];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
    self.navigationItem.leftBarButtonItem = leftItem;
    [leftItem release];
}
- (void)pop
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)loadData
{
    if (self.cityFlag == 1) {
        NSMutableDictionary *dicIn = [[NSMutableDictionary alloc] initWithObjectsAndKeys:nil];
        NSMutableDictionary *dicOut = [SignatrueEncryption encryptedParamsWithBaseParams:dicIn];
        
        NSString *urlString = [NSString stringWithFormat:@"http://api.dianping.com/v1/metadata/get_cities_with_businesses?appkey=%@&sign=%@",kAPP_KEY,[dicOut objectForKey:@"sign"]];
        NSLog(@"%@",urlString);
        [_request loadDataWithURLString:urlString];

    }else if(self.cityFlag == 2){
        NSMutableDictionary *dicIn = [[NSMutableDictionary alloc] initWithObjectsAndKeys:nil];
        NSMutableDictionary *dicOut = [SignatrueEncryption encryptedParamsWithBaseParams:dicIn];
        
        NSString *urlString = [NSString stringWithFormat:@"http://api.dianping.com/v1/metadata/get_cities_with_coupons?appkey=%@&sign=%@",kAPP_KEY,[dicOut objectForKey:@"sign"]];
        [_request loadDataWithURLString:urlString];
    }else if (self.cityFlag == 3){
        NSMutableDictionary *dicIn = [[NSMutableDictionary alloc] initWithObjectsAndKeys:nil];
        NSMutableDictionary *dicOut = [SignatrueEncryption encryptedParamsWithBaseParams:dicIn];
        
        NSString *urlString = [NSString stringWithFormat:@"http://api.dianping.com/v1/metadata/get_cities_with_deals?appkey=%@&sign=%@",kAPP_KEY,[dicOut objectForKey:@"sign"]];
        [_request loadDataWithURLString:urlString];
    }
   
}
//请求数据成功之后执行代理方法
- (void)request:(NetWorkRequest *)netWorkRequest
   didFinishing:(NSData *)data
{
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
//    NSLog(@"%@",dic);
    NSArray *arr = [dic objectForKey:@"cities"];
    for (NSString *str in arr) {
        [_cityArr addObject:str];
    }
    NSMutableArray *letterArr = [[NSMutableArray alloc] init];
    for (NSString *pinyin in _cityArr) {
        if ([[ChineseToPinyin pinyinFromChiniseString:pinyin] isEqualToString:@"ZHONGQING"]) {
            pinyin = @"CHONGQING";
            [_pinyinArr addObject:pinyin];
            [letterArr addObject:[pinyin substringWithRange:NSMakeRange(0, 1)]];
            [_pinyinAndCity setValue:@"重庆" forKey:pinyin];
        }else{
            [_pinyinArr addObject:[ChineseToPinyin pinyinFromChiniseString:pinyin]];
            [letterArr addObject:[[ChineseToPinyin pinyinFromChiniseString:pinyin] substringWithRange:NSMakeRange(0, 1)]];
            [_pinyinAndCity setValue:pinyin forKey:[ChineseToPinyin pinyinFromChiniseString:pinyin]];
        }
        
    }
    NSMutableArray *section = nil;
    NSSet *set = [NSSet setWithArray:letterArr];
    [letterArr release];
    NSMutableArray *arrSet = [[NSMutableArray alloc] init];
    for (NSString *str in set) {
        [arrSet addObject:str];
    }
    NSArray *arrAllASet = [NSArray arrayWithArray:[arrSet sortedArrayUsingSelector:@selector(compare:)]];
    [arrSet release];
    for (NSString *str in arrAllASet) {
        [_titleArr addObject:str];
        section = [[NSMutableArray alloc] init];
        [_sectionArr addObject:section];
        [section release];
    }
    for (NSString *bigStr in _titleArr) {
        for (NSString *str in _pinyinArr) {
            if ([[str substringWithRange:NSMakeRange(0, 1)] isEqualToString:bigStr]) {
                [[_sectionArr objectAtIndex:[_titleArr indexOfObject:bigStr]] addObject:str];
            }
        }
    }
    [self.tableView reloadData];

}

//请求数据失败之后执行代理方法
- (void)request:(NetWorkRequest *)netWorkRequest
didFailWithError:(NSError *)error
{
    [self.view.window showHUDWithText:@"加载失败" Type:ShowPhotoNo Enabled:YES];
}
#pragma mark - Table view data source
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    [self.delegete setCityListDelegate:cell.textLabel.text];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    if (tableView == self.tableView) {
        return _titleArr;
    }
    return nil;
}


//给每个分区设置一个title
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (tableView == self.tableView) {
        return [_titleArr objectAtIndex:section];
    }
    return @"";
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{

    if (tableView == self.tableView) {
        return [_titleArr count];
    }
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    if (tableView == self.tableView) {
        return [[_sectionArr objectAtIndex:section] count];
    }
    return [_filterArr count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *reuser = @"reuse";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuser];
    if (cell == nil)
    {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:reuser] autorelease];
    }
    
    if (tableView == self.tableView)
    {
        cell.textLabel.text = [_pinyinAndCity objectForKey:[[_sectionArr objectAtIndex:indexPath.section] objectAtIndex:indexPath.row]];
        return cell;
    }
    else
    {
        NSString *str = [_filterArr objectAtIndex:0];
        for(int i=0; i < [str length];i++){
            int a = [str characterAtIndex:i];
            if( a > 0x4e00 && a < 0x9fff){
                cell.textLabel.text = [_filterArr objectAtIndex:indexPath.row];
                return cell;
            }else{
                cell.textLabel.text = [_pinyinAndCity objectForKey:[_filterArr objectAtIndex:indexPath.row]];
                return cell;
            }
        }
        
    }
    
    return nil;
}

-(void)dealloc
{
    [_request release];
    [_cityArr release];
    [_filterArr release];
    [_titleArr release];
    [_pinyinAndCity release];
    [_sectionArr release];
    [_searchDisplayController release];
    [super dealloc];
}


@end
