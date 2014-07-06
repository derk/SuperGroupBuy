//
//  NewDorpDown.m
//  DropDownLsit
//
//  Created by lanouhn on 14-4-6.
//  Copyright (c) 2014年 lanouhn. All rights reserved.
//

#import "NewDorpDown.h"


@interface NewDorpDown ()
@property(nonatomic,retain)NSArray *list;
@property(nonatomic,retain)UITableView *tableView;
@end

@implementation NewDorpDown

- (id)initWithButton:(UIButton *)button array:(NSArray *)array height:(CGFloat)height
{
    self = [super init];
    if (self)
    {
        self.button = button;
        self.list = [NSArray arrayWithArray:array];
        
        self.frame = CGRectMake(160, self.button.frame.origin.y+self.button.frame.size.height, 160, height);
        
        self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 160, height)];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.backgroundColor = [UIColor lightGrayColor];
        
        [self addSubview:_tableView];
        

        
        [self.button.superview.superview addSubview:self];
     
    }
    
    return self;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    [self.button setTitle:cell.textLabel.text forState:UIControlStateNormal];
    [self.delegate dropDownDelegateMethod];
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
        cell = [[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reUse]autorelease];
    }
    cell.textLabel.font = [UIFont systemFontOfSize:14.0];
    cell.textLabel.text = [_list objectAtIndex:indexPath.row];
    cell.contentView.backgroundColor = [UIColor lightGrayColor];
    return cell;
}
- (void)dealloc
{
    [_tableView release];
    [_list release];
    [super dealloc];
}


@end
