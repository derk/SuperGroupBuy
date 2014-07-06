//
//  EGORefreshTableViewController.h
//  RefreshAndLoadMore
//
//  Created by cyy on 13-9-17.
//  Copyright (c) 2013年 www.lanou3g.com 北京蓝鸥科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EGORefreshTableFooterView.h"
#import "EGORefreshTableHeaderView.h"
#import "EGOViewCommon.h"
@interface EGORefreshTableViewController : UIViewController <EGORefreshTableDelegate, UITableViewDelegate, UITableViewDataSource>
{
    EGORefreshTableHeaderView *_refreshHeaderView;
    EGORefreshTableFooterView *_refreshFooterView;
    
    UITableView *_tableView;
}
@property(nonatomic, retain)UITableView *tableView;

// create/remove footer/header view, reset the position of the footer/header views
-(void)setFooterView;
-(void)removeFooterView;
-(void)createHeaderView;
-(void)removeHeaderView;

// overide method
-(void)beginToReloadData:(EGORefreshPos)aRefreshPos;



-(void)finishReloadingData;

// force to refresh
-(void)showRefreshHeader:(BOOL)animated;

@end
