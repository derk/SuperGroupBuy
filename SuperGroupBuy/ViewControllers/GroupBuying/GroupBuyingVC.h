//
//  GroupBuyingVC.h
//  SuperGroupBuying
//
//  Created by lanouhn on 14-4-2.
//  Copyright (c) 2014年 lanouhn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NetWorkRequest.h"
#import "EGORefreshTableViewController.h"
#import "CityListVC.h"
#import "DropDown.h"
@interface GroupBuyingVC : EGORefreshTableViewController<NSURLConnectionDataDelegate,NetWorkRequesDelegate,CityListVCDelegate,DropDownDelegate>
@property (nonatomic) NSInteger cityFlag;

@end
