//
//  DropDown.h
//  DropDownLsit
//
//  Created by lanouhn on 14-4-6.
//  Copyright (c) 2014年 lanouhn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NewDorpDown.h"

@class DropDown;
@protocol DropDownDelegate <NSObject>

- (void)dropDownDelegateWithDropDown:(DropDown *)dropDown;

@end
@interface DropDown : UIView<UITableViewDataSource,UITableViewDelegate,NewDorpDownDelegate>

@property(nonatomic,assign)id<DropDownDelegate> delegate;
@property(nonatomic,retain)UIButton *button;

- (id)initWithButton:(UIButton *)button array:(NSArray *)array height:(CGFloat)height;

@property(nonatomic,retain)NewDorpDown *theNewDropDown;
@property(nonatomic,assign)NSInteger dropDown_Flag;
@property(nonatomic,retain)UITableView *tableView;
@property(nonatomic,retain)NSDictionary *dic;
@property(nonatomic,retain)NSArray *twoListArr;

- (void)analysisSelf_dic;



@end
