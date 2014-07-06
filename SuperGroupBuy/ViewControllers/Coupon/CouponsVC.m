//
//  CouponsVC.m
//  SuperGroupBuying
//
//  Created by lanouhn on 14-4-2.
//  Copyright (c) 2014年 lanouhn. All rights reserved.
//

#import "CouponsVC.h"
#import "CityListVC.h"
#import "DropDown.h"
#import "SignatrueEncryption.h"
#import "CommonDefine.h"
#import "NetWorkRequest.h"
#import "Coupons.h"
@interface CouponsVC ()
{
//    NSMutableArray *_countArr;
    NSMutableArray *_couponsArr;

    
    //----------------
    
    NetWorkRequest *_request;//商家请求数据
    NetWorkRequest *_regionRequest;//分区列表请求数据
    NetWorkRequest *_categoryRequest;//分类列表请求
    NetWorkRequest *_cityRequest;//城市定位请求
    NSInteger _page;//页数
    //    NSString *_city;//切换城市
    UIButton *_LeftItemBtn;//当前城市按钮
    UIButton *_areaBtn;//分区按钮
    UIButton *_classBtn;//分类按钮
    UIButton *_sortBtn;//排序按钮
    NSDictionary *_sortDic;//排序字典
    NSInteger _sortNum;//排序字典对应的key
    NSString *_region;//所选分区
    NSMutableArray *_regionArr;//分区列表数组
    //    NSDictionary *_cityDic;//请求分区得到当前城市字典（包含所有分区和街道）传往2级列表
    NSString *_category;//所选分类
    NSMutableArray *_categoryArr;//分类列表数组
    //    NSDictionary *_categoryDic;//请求分类得到的所有分类字典，传往2级列表
    UIView *_shadeView;
}
@property(nonatomic,retain)DropDown *dropDown;
@property(nonatomic,retain)DropDown *dropDown2;
@property(nonatomic,retain)DropDown *dropDown3;
@property(nonatomic,retain)NSString *city;


@property(nonatomic,retain)NSDictionary *cityDic;//请求分区得到当前城市字典（包含所有分区和街道）传往2级列表
@property(nonatomic,retain)NSDictionary *categoryDic;//请求分类得到的所有分类字典，传往2级列表
@property(nonatomic,retain)NSMutableDictionary *dicIn;
@end

@implementation CouponsVC
- (void)dealloc
{
    [_couponsArr release];
    [_request release];
    //----------------
    [_city release];
//    [_dropDown release];
//    [_dropDown2 release];
//    [_dropDown3 release];
    [_LeftItemBtn release];
    [_areaBtn removeObserver:self forKeyPath:@"titleLabel.text"];
    [_areaBtn release];
    [_cityDic release];////请求分区得到当前城市字典（包含所有分区和街道）传往2级列表
    [_regionArr release];//地区列表
    [_region release];//所选地区
    [_classBtn removeObserver:self forKeyPath:@"titleLabel.text"];
    [_classBtn release];
    [_category release];//所选分类
    [_categoryArr release];//分类列表数组
    [_categoryDic release];//请求分类得到的所有分类字典，传往2级列表
    [_sortBtn removeObserver:self forKeyPath:@"titleLabel.text"];
    [_sortBtn release];
    [_sortDic release];
    [_shadeView release];
    [_cityRequest release];//城市定位请求
    [_dicIn release];
    [super dealloc];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = NO;
    if (_dropDown != nil) {
        [self dropDownRelease];
    }
    if (_dropDown2 != nil ) {
        [self dropDown2Release];
    }
    if (_dropDown3 != nil) {
        [self dropDown3Release];
    }
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationController.navigationBar.tintColor = [UIColor orangeColor];
    self.tableView.showsVerticalScrollIndicator = NO;
    //结果排序，1:最新发布优先，2:热门优惠优先，3:最优优惠优先，4:即将结束优先，5:离经纬度坐标距离近优先，如不传入，默认值为1
    _sortDic = [[NSDictionary alloc] initWithObjectsAndKeys:@"1",@"最新发布优先",@"2",@"热门优惠优先", @"3",@"最优优惠优先",@"4",@"即将结束优先",nil];
    self.navigationItem.title = @"优惠券";
    _request = [[NetWorkRequest alloc] init];
    _request.deligate = self;
    _regionRequest = [[NetWorkRequest alloc] init];
    _regionRequest.deligate = self;
    _categoryRequest = [[NetWorkRequest alloc] init];
    _categoryRequest.deligate = self;
    _cityRequest = [[NetWorkRequest alloc] init];
    _cityRequest.deligate = self;
    _couponsArr = [[NSMutableArray alloc] init];
    _regionArr = [[NSMutableArray alloc] init];
    _categoryArr = [[NSMutableArray alloc] init];
    _page = 1;
    self.city = @"上海";
    _category = @"美食";//默认分类
//    _region = @"长宁区";
    _region = nil;
    _sortNum = 1;
    _shadeView = [[UIView alloc] initWithFrame:self.tableView.frame];
    _shadeView.backgroundColor = [UIColor lightGrayColor];
    _shadeView.alpha = 0.7;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] init];
    tap.numberOfTapsRequired = 1;
    [tap addTarget:self action:@selector(tap:)];
    [_shadeView addGestureRecognizer:tap];
    [tap release];
    [self createClassiflyView];
    [self createLeftItem];
    [self loadData];
    [self createHeaderView];
    [self showRefreshHeader:YES];
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] init];
    barButtonItem.title = @"";
    self.navigationItem.backBarButtonItem = barButtonItem;
    
    
}
#pragma mark 遮罩手势
- (void)tap:(UIGestureRecognizer *)tap
{
    if (_dropDown != nil) {
        [self dropDownRelease];
    }
    if (_dropDown2 != nil ) {
        [self dropDown2Release];
    }
    if (_dropDown3 != nil) {
        [self dropDown3Release];
    }
}
#pragma mark 分类自定义View
- (void)createClassiflyView
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    view.backgroundColor = [UIColor clearColor];
    [self.view addSubview:view];
    [view release];
    _areaBtn = [[UIButton buttonWithType:UIButtonTypeSystem] retain];
    _areaBtn.frame = CGRectMake(0, 0, 107, 44);
    [_areaBtn setTitle:@"分区" forState:UIControlStateNormal];
    [_areaBtn.layer setBorderWidth:1.0];
    [_areaBtn.layer setBorderColor:[UIColor whiteColor].CGColor];
    [_areaBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_areaBtn addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
    _areaBtn.backgroundColor = [UIColor orangeColor];
    _areaBtn.titleLabel.font = [UIFont systemFontOfSize: 12.0];
    [_areaBtn addObserver:self forKeyPath:@"titleLabel.text" options:NSKeyValueObservingOptionNew context:0];
    [view addSubview:_areaBtn];
    
    _classBtn = [[UIButton buttonWithType:UIButtonTypeSystem] retain];
    _classBtn.frame = CGRectMake(107, 0, 107, 44);
    [_classBtn setTitle:_category forState:UIControlStateNormal];
    [_classBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _classBtn.backgroundColor = [UIColor orangeColor];
    [_classBtn.layer setBorderWidth:1.0];
    [_classBtn.layer setBorderColor:[UIColor whiteColor].CGColor];
    
    [_classBtn addTarget:self action:@selector(click2:) forControlEvents:UIControlEventTouchUpInside];
    _classBtn.titleLabel.font = [UIFont systemFontOfSize: 12.0];
    [_classBtn addObserver:self forKeyPath:@"titleLabel.text" options:NSKeyValueObservingOptionNew context:0];
    [view addSubview:_classBtn];
    
    _sortBtn = [[UIButton buttonWithType:UIButtonTypeSystem] retain];
    _sortBtn.frame = CGRectMake(214, 0, 106, 44);
    _sortBtn.backgroundColor = [UIColor orangeColor];
    [_sortBtn.layer setBorderWidth:1.0];
    [_sortBtn.layer setBorderColor:[UIColor whiteColor].CGColor];
    
    [_sortBtn setTitle:@"默认排序" forState:UIControlStateNormal];
    [_sortBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_sortBtn addTarget:self action:@selector(click3:) forControlEvents:UIControlEventTouchUpInside];
    _sortBtn.titleLabel.font = [UIFont systemFontOfSize: 12.0];
    [_sortBtn addObserver:self forKeyPath:@"titleLabel.text" options:NSKeyValueObservingOptionNew context:0];
    [view addSubview:_sortBtn];
    
}
#pragma mark 观察者事件
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if (object == _sortBtn) {
        _sortNum = [[_sortDic objectForKey:[change objectForKey:@"new"]] intValue];
        _page = 1;
        [self loadData];
        [self.tableView reloadData];
        
    }else if (object == _areaBtn) {
        [_region release];
        _region = [[change objectForKey:@"new"] retain];
        _page = 1;
        [self loadData];
        [self.tableView reloadData];
        
    }else if(object == _classBtn){
        _category = [[change objectForKey:@"new"] retain];
        _page = 1;
        [self loadData];
        [self.tableView reloadData];
        
    }
}
#pragma mark 分类点击事件
- (void)click:(UIButton *)btn
{
    if (_dropDown == nil) {
        if (_dropDown2 != nil) {
            [self dropDown2Release];
        }
        
        if (_dropDown3 != nil) {
            [self dropDown3Release];
        }
        [btn.superview.superview addSubview:_shadeView];
        _dropDown = [[DropDown alloc]initWithButton:btn array:_regionArr height:250];
        _dropDown.delegate = self;
        _dropDown.dic = _cityDic;
        [_dropDown analysisSelf_dic];
    }else
    {
        [self dropDownRelease];
    }
}
- (void)click2:(UIButton *)btn
{
    if (_dropDown2 == nil) {
        if (_dropDown != nil) {
            [self dropDownRelease];
        }
        
        if (_dropDown3 != nil) {
            [self dropDown3Release];
        }
        [btn.superview.superview addSubview:_shadeView];
        _dropDown2= [[DropDown alloc]initWithButton:btn array:_categoryArr height:250];
        _dropDown2.delegate = self;
        _dropDown2.dic = _categoryDic;
        _dropDown2.dropDown_Flag = 1;
//        [_dropDown2 analysisSelf_dic];
    }else
    {
        [self dropDown2Release];
    }
}
- (void)click3:(UIButton *)btn
{
    //结果排序，1:最新发布优先，2:热门优惠优先，3:最优优惠优先，4:即将结束优先，5:离经纬度坐标距离近优先，如不传入，默认值为1
    NSArray *array = [NSArray arrayWithObjects: @"最新发布优先",@"热门优惠优先",@"最优优惠优先",@"即将结束优先",nil];
    if (_dropDown3 == nil) {
        if (_dropDown2 != nil) {
            [self dropDown2Release];
        }
        
        if (_dropDown != nil) {
            [self dropDownRelease];
        }
        [btn.superview.superview addSubview:_shadeView];
        _dropDown3 = [[DropDown alloc]initWithButton:btn array:array height:250];
        _dropDown3.delegate = self;
        _dropDown3.dropDown_Flag = 1;
    }else
    {
        [self dropDown3Release];
    }
}
#pragma mark 下拉列表对象
- (void)dropDownDelegateWithDropDown:(DropDown *)dropDown;
{
    if (dropDown == _dropDown) {
        [self dropDownRelease];
    }else if (dropDown == _dropDown2){
        [self dropDown2Release];
    }else if (dropDown == _dropDown3){
        [self dropDown3Release];
    }
}
- (void)dropDownRelease
{
    _dropDown.hidden = YES;
    _dropDown.theNewDropDown.hidden = YES;
    _dropDown.delegate = nil;
    [_dropDown release];
    _dropDown = nil;
    [_shadeView removeFromSuperview];
}
- (void)dropDown2Release
{
    _dropDown2.hidden = YES;
    _dropDown2.theNewDropDown.hidden = YES;
    _dropDown2.delegate = nil;
    [_dropDown2 release];
    _dropDown2 = nil;
    [_shadeView removeFromSuperview];
}
- (void)dropDown3Release
{
    _dropDown3.hidden = YES;
    _dropDown3.theNewDropDown.hidden = YES;
    _dropDown3.delegate = nil;
    [_dropDown3 release];
    _dropDown3 = nil;
    [_shadeView removeFromSuperview];
}
#pragma mark 当前城市按钮
- (void)createLeftItem
{
    _LeftItemBtn = [[UIButton buttonWithType:UIButtonTypeSystem] retain];
    _LeftItemBtn.frame = CGRectMake(0, 0, 80, 35);
    [_LeftItemBtn setTitle:_city forState:UIControlStateNormal];
    [_LeftItemBtn addTarget:self action:@selector(push) forControlEvents:UIControlEventTouchUpInside ];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:_LeftItemBtn];
    self.navigationItem.leftBarButtonItem = leftItem;
    [leftItem release];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] init];
    backItem.title = @"";
    self.navigationItem.backBarButtonItem = backItem;
    [backItem release];
   
}
- (void)push
{
    CityListVC  *cityListVC = [[CityListVC alloc] init];
    UINavigationController *cityListNavigationVC = [[UINavigationController alloc] initWithRootViewController:cityListVC];
    [cityListVC release];
    cityListVC.cityFlag = 2;
    cityListVC.delegete = self;
    [self presentViewController:cityListNavigationVC animated:YES completion:nil];
    [cityListNavigationVC release];
}
-(void)beginToReloadData:(EGORefreshPos)aRefreshPos
{
    //上拉刷新
    if (aRefreshPos == EGORefreshHeader) {
        _page = 1;
    }else if (aRefreshPos == EGORefreshFooter){
        //下拉加载
        _page++;
    }
    [self loadData];
}
//城市列表代理方法
- (void)setCityListDelegate:(NSString *)city
{
    self.city = city;
    _region = nil;
    _category = @"美食";
    _page = 1;
    [_areaBtn setTitle:@"分区" forState:UIControlStateNormal];
    [_classBtn setTitle:_category forState:UIControlStateNormal];
    [_sortBtn setTitle:@"默认排序" forState:UIControlStateNormal];
    [_LeftItemBtn setTitle:_city forState:UIControlStateNormal];
    //当切换城市之后,根据选中的城市去请求该城市所对应的商家列表,商区以及分类
    [self loadData];
//    [self loadDataCategory];
//    [self loadDataRegion];
    [self.tableView reloadData];
}

#pragma mark - loadData
//请求网络
-(void)loadData
{
    if (_region != nil) {
        self.dicIn = [NSMutableDictionary dictionaryWithObjectsAndKeys:_city,@"city",@"10",@"limit" ,[NSString stringWithFormat:@"%d",_page],@"page",[NSString stringWithFormat:@"%d",_sortNum],@"sort",_region,@"region",_category,@"category", nil];
        NSMutableDictionary *dicOut = [SignatrueEncryption encryptedParamsWithBaseParams:_dicIn];
        NSString *urlString = [NSString stringWithFormat:@"http://api.dianping.com/v1/coupon/find_coupons?appkey=%@&sign=%@&city=%@&category=%@&limit=%d&sort=%d&region=%@&page=%d",kAPP_KEY,[dicOut objectForKey:@"sign"],[dicOut objectForKey:@"city"],[dicOut objectForKey:@"category"],[[dicOut objectForKey:@"limit"] intValue],[[dicOut objectForKey:@"sort"] intValue],[dicOut objectForKey:@"region"],[[dicOut objectForKey:@"page"] intValue]];
        [_request loadDataWithURLString:urlString];
    }else{
        self.dicIn = [NSMutableDictionary dictionaryWithObjectsAndKeys:_city,@"city",@"10",@"limit" ,[NSString stringWithFormat:@"%d",_page],@"page",[NSString stringWithFormat:@"%d",_sortNum],@"sort",_category,@"category", nil];
        NSMutableDictionary *dicOut = [SignatrueEncryption encryptedParamsWithBaseParams:_dicIn];
        NSString *urlString = [NSString stringWithFormat:@"http://api.dianping.com/v1/coupon/find_coupons?appkey=%@&sign=%@&city=%@&category=%@&limit=%d&sort=%d&page=%d",kAPP_KEY,[dicOut objectForKey:@"sign"],[dicOut objectForKey:@"city"],[dicOut objectForKey:@"category"],[[dicOut objectForKey:@"limit"] intValue],[[dicOut objectForKey:@"sort"] intValue],[[dicOut objectForKey:@"page"] intValue]];
        [_request loadDataWithURLString:urlString];
    }
    [self loadDataRegion];
    [self loadDataCategory];
}
//请求分区列表
- (void)loadDataRegion
{
    NSMutableDictionary *regionDicIn = [NSMutableDictionary dictionaryWithObjectsAndKeys: nil];
    NSMutableDictionary *regionDicOut = [SignatrueEncryption encryptedParamsWithBaseParams:regionDicIn];
    
    NSString *regionUrlString = [NSString stringWithFormat:@"http://api.dianping.com/v1/metadata/get_regions_with_coupons?appkey=%@&sign=%@",kAPP_KEY,[regionDicOut objectForKey:@"sign"]];
    
    [_regionRequest loadDataWithURLString: regionUrlString];
    
}
//请求分类类表
- (void)loadDataCategory
{
    NSMutableDictionary *categoryDicIn = [NSMutableDictionary dictionaryWithObjectsAndKeys: nil];
    NSMutableDictionary *categoryDicOut = [SignatrueEncryption encryptedParamsWithBaseParams:categoryDicIn];
    NSString *categoryUrlString = [NSString stringWithFormat:@"http://api.dianping.com/v1/metadata/get_categories_with_coupons?appkey=%@&sign=%@",kAPP_KEY,[categoryDicOut objectForKey:@"sign"]];
    [_categoryRequest loadDataWithURLString:categoryUrlString];
}
#pragma mark - NetWorkRequesDelegate
//请求数据成功之后执行代理方法
- (void)request:(NetWorkRequest *)netWorkRequest
   didFinishing:(NSData *)data
{
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
    if (netWorkRequest == _request) {
        [self parseBusinessDataWithDic:dic];
    }else if(netWorkRequest == _regionRequest){
        [self parseRegionDataWithDic:dic];
    }else if(netWorkRequest == _categoryRequest){
        [self parseCategoryDataWithDic:dic];
    }
}
//解析商家请求得到的信息
- (void)parseBusinessDataWithDic:(NSDictionary *)dataDic
{
    if (_page == 1) {
        [_couponsArr removeAllObjects];
    }
    NSArray *arr = [dataDic objectForKey:@"coupons"];
    NSString *count = [dataDic objectForKey:@"count"];
    for (NSDictionary *tempDic in arr) {
        Coupons *coupon = [[Coupons alloc] initWithDictionary:tempDic];
        [_couponsArr addObject:coupon];
        [coupon release];
    }
    [self.tableView reloadData];
    [self finishReloadingData];
    if ([count intValue] == [[_dicIn objectForKey:@"limit"] intValue]) {
        [self setFooterView];
        [self.view.window showHUDWithText:[NSString stringWithFormat:@"成功加载%d条数据", [count intValue]] Type:ShowPhotoYes Enabled:YES];
    } else if ([count intValue] != [[_dicIn objectForKey:@"limit"] intValue]){
        [self.view.window showHUDWithText:[NSString stringWithFormat:@"成功加载%d条数据", [count intValue]] Type:ShowPhotoYes Enabled:YES];
        [self performSelector:@selector(removeFooter) withObject:nil afterDelay:1.5];
        [self removeFooterView];
    }//如果headView 和FootView 距离太近，刷新那个类会处理不敏感，刷新或者加载会走两次，所以需要判断是否要加FootView 而且要把上次的FootView移除
    //        [self setFooterView];//判断 是否可以上拉加载///////////////////////
}
//解析商区请求得到的数据
- (void)parseRegionDataWithDic:(NSDictionary *)dataDic
{
    NSArray *cityArr = [dataDic objectForKey:@"cities"] ;
    for (NSDictionary *dicTemp in cityArr) {
        if ([[dicTemp objectForKey:@"city_name"] isEqualToString:_city]) {
            self.cityDic = [NSDictionary dictionaryWithDictionary:dicTemp] ;//得到传往下一个列表的数据
        }
    }
    NSArray *regionBig = [_cityDic objectForKey:@"districts"];
    [_regionArr removeAllObjects];//每次请求清空一下地区数组
    for (NSDictionary *dicTemp in regionBig) {
        [_regionArr addObject:[dicTemp objectForKey:@"district_name"]];
    }
    //    [self.view.window showHUDWithText:@"加载成功" Type:ShowPhotoYes Enabled:YES];
//    [self.view.window showHUDWithText:nil Type:ShowDismiss Enabled:YES];
}
//解析分类请求得到的数据
- (void)parseCategoryDataWithDic:(NSDictionary *)dataDic
{
    self.categoryDic = dataDic;//得到传往下一个列表的数据
    NSArray *arr = [_categoryDic objectForKey:@"categories"];
    [_categoryArr removeAllObjects];//每次请求清空一下分类数组
    for (NSString *str in arr) {
        [_categoryArr addObject:str];
    }
    //    [self.view.window showHUDWithText:@"加载成功" Type:ShowPhotoYes Enabled:YES];
//    [self.view.window showHUDWithText:nil Type:ShowDismiss Enabled:YES];
}
//延迟取消 菊花, 显示没有更多数据了
- (void)removeFooter
{
    [self.view.window showHUDWithText:@"没有更多数据了" Type:ShowPhotoNo Enabled:YES];
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

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
 
    return [_couponsArr count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *reuser = @"reuse";
    CouponCell *cell = [tableView dequeueReusableCellWithIdentifier:reuser];
    if (cell == nil) {
        cell = [[[CouponCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:reuser] autorelease];
    }
    Coupons *coupons = [_couponsArr objectAtIndex:indexPath.row];
    [cell queryCoupon:coupons];
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 100;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    DetailedCoupons *detailed = [[DetailedCoupons alloc]init];
    [self.navigationController hidesBottomBarWhenPushed];
    detailed.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:detailed animated:YES];
    
    Coupons *tempCoupons = [_couponsArr objectAtIndex:indexPath.row];
    detailed.coupon = tempCoupons;
    [detailed release];
}



@end
