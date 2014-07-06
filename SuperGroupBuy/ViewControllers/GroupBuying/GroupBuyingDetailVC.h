//
//  GroupBuyingDetailVC.h
//  SuperGroupBuying
//
//  Created by lanouhn on 14-4-2.
//  Copyright (c) 2014年 lanouhn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GroupBuyingVC.h"
#import "RennSDK/RennSDK.h"
@class GroupBuying;
@interface GroupBuyingDetailVC : UIViewController<UIAlertViewDelegate,RennLoginDelegate,UIActionSheetDelegate>
@property (nonatomic,retain)GroupBuying *groupDetail;
@property (nonatomic, copy) NSString *string;
@property (nonatomic, retain) NSMutableArray *detailCollArr;
@end

