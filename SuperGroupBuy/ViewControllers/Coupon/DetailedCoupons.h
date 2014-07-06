//
//  DetailedCoupons.h
//  SuperGroupBuying
//
//  Created by lanouhn on 14-4-2.
//  Copyright (c) 2014年 lanouhn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CouponsVC.h"
#import "NetWorkRequest.h"
#import "RennSDK/RennSDK.h"
#import "UIWindow+YzdHUD.h"
@interface DetailedCoupons : UIViewController<NSURLConnectionDataDelegate,UITableViewDataSource,UITableViewDelegate,UIActionSheetDelegate,RennLoginDelegate,UIAlertViewDelegate>
@property(nonatomic,retain)Coupons *coupon;
@end
