//
//  CouponsVCForShop.h
//  SuperGroupBuy
//
//  Created by lanou3g on 14-4-23.
//  Copyright (c) 2014年 lanouhn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NetWorkRequest.h"
@interface CouponsVCForShop : UITableViewController<NetWorkRequesDelegate>
@property (nonatomic,retain)NSString *CouponID;
@end
