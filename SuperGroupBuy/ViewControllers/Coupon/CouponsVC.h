//
//  CouponsVC.h
//  SuperGroupBuying
//
//  Created by lanouhn on 14-4-2.
//  Copyright (c) 2014年 lanouhn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CouponCell.h"
#import "DetailedCoupons.h"
#import "NetWorkRequest.h"
#import "SignatrueEncryption.h"
#import "CityListVC.h"
#import "EGORefreshTableViewController.h"
#import "DropDown.h"
@interface CouponsVC : EGORefreshTableViewController<NSURLConnectionDataDelegate,NetWorkRequesDelegate,CityListVCDelegate,DropDownDelegate>

@property (nonatomic) NSInteger cityFlag;

@end
