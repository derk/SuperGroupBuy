//
//  DropDown.m
//  DropDownLsit
//
//  Created by lanouhn on 14-4-6.
//  Copyright (c) 2014年 lanouhn. All rights reserved.
//

#import "DropDown.h"
#import "NewDorpDown.h"
@interface DropDown ()
{
//    NewDorpDown *_newDropDown;
}
@property(nonatomic,retain)NSArray *list;
@property(nonatomic,retain)NSMutableArray * array;//点击 某个cell解析得到的数组
@property(nonatomic,retain)NSMutableArray *countArr;//每个二级列表中cell的个数




@end
@implementation DropDown

- (id)initWithButton:(UIButton *)button array:(NSArray *)array height:(CGFloat)height
{
    self = [super init];
    if (self)
    {
        self.button = button;
        self.list = [NSArray arrayWithArray:array];
        
        self.frame = CGRectMake(0, self.button.frame.origin.y+self.button.frame.size.height, 160, height);
        
        self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 160, height)];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.backgroundColor = [UIColor whiteColor];
       [self addSubview:_tableView];
        
        [self.button.superview.superview addSubview:self];
        [self.button.superview.superview bringSubviewToFront:self];

        [self.tableView reloadData];
        self.backgroundColor = [UIColor lightGrayColor];
        self.array = [[NSMutableArray alloc]init];
        self.countArr = [[NSMutableArray alloc] init];
        

    }
    return self;
}

- (void)analysisSelf_dic
{
    [_countArr removeAllObjects];

    if ([self.dic objectForKey:@"districts"] != nil){
        NSArray *cityArr = [self.dic objectForKey:@"districts"];
        for (NSDictionary *dic in cityArr) {
            NSArray *arr = [dic objectForKey:@"neighborhoods"];
            [_countArr addObject:[NSString stringWithFormat:@"%d",[arr count]]];
        }
        
    }else if ([self.dic objectForKey:@"categories"] != nil){
        NSArray *arr = [self.dic objectForKey:@"categories"];
        for (NSDictionary *dic in arr) {
            NSArray *arr = [dic objectForKey:@"subcategories"];
            [_countArr addObject:[NSString stringWithFormat:@"%d",[arr count]]];
        }
    }
}

//2级列表
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.contentView.backgroundColor = [UIColor lightGrayColor];
    if (self.dropDown_Flag != 1) {
        [self analysisSelf_dicWithCell:cell];
    }
    [self towListAppearWithCell:cell];
  
}
//是否出现2级列表
- (void)towListAppearWithCell:(UITableViewCell*)cell;
{
    if (self.dropDown_Flag == 1||[_array count] == 0) {
        [self.button setTitle:cell.textLabel.text forState:UIControlStateNormal];
        [self.delegate dropDownDelegateWithDropDown:self];
    }else
    {
        if (self.theNewDropDown == nil) {
            self.theNewDropDown = [[NewDorpDown alloc]initWithButton:self.button array:_array height:250];
            self.theNewDropDown.delegate = self;
            
        }else{
            [self.theNewDropDown removeFromSuperview];
            self.theNewDropDown.delegate = nil;
            [_theNewDropDown release];
            self.theNewDropDown = [[NewDorpDown alloc]initWithButton:self.button array:_array height:250];
            self.theNewDropDown.delegate = self;
        }
    }
}
//cell解析商区列表的数据字典
- (void)analysisSelf_dicWithCell:(UITableViewCell*)cell;
{
    [_array removeAllObjects];
    if ([self.dic objectForKey:@"districts"] != nil){
        NSArray *cityArr = [self.dic objectForKey:@"districts"];
        
        for (NSDictionary *dicTemp in cityArr) {
            if ([[dicTemp objectForKey:@"district_name"] isEqualToString:cell.textLabel.text]) {
                [_array addObjectsFromArray:[dicTemp objectForKey:@"neighborhoods"]];
            }
        }
    }else if ([self.dic objectForKey:@"categories"] != nil){
        NSArray *arr = [self.dic objectForKey:@"categories"];
        for (NSDictionary *tempDic in arr) {
            if ([[tempDic objectForKey:@"category_name"] isEqualToString:cell.textLabel.text]) {
                NSArray *arr = [tempDic objectForKey:@"subcategories"];
                if ([arr count] != 0) {
                    id li = [arr objectAtIndex:0];
                    if ([li isKindOfClass:[NSDictionary class]]) {
                        for (NSDictionary *tempForTowDic in arr) {
                            [_array addObject:[tempForTowDic objectForKey:@"category_name"]];
                        }
                    }else{
                        for (NSString *str in arr) {
                            [_array addObject:str];
                        }
                    }
                }
                
                
            }
        }
    }

}
//2级列表代理方法
- (void)dropDownDelegateMethod
{
    [self.delegate dropDownDelegateWithDropDown:self];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_list count];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return self.button.frame.size.height;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *reUse = @"reUse";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reUse];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:reUse]autorelease];
    }
    cell.textLabel.font = [UIFont systemFontOfSize:14.0];
    cell.textLabel.text = [_list objectAtIndex:indexPath.row];
    if ([_countArr count] > 0) {
        cell.detailTextLabel.text = [NSString stringWithFormat:@"(%@)",[_countArr objectAtIndex:indexPath.row]];
//        if ([[_countArr objectAtIndex:indexPath.row] intValue] > 0) {
//            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
//        }
    }
    
//    cell.selectionStyle = UITableViewCellSelectionStyleNone; 
    

    return cell;
}
- (void)dealloc
{
    [_countArr release];
    [_array release];
    [_tableView release];
    [_list release];
    [_dic release];
    [_theNewDropDown release];
    [super dealloc];
}
@end
