//
//  GroupShopList.h
//  SuperGroupBuy
//
//  Created by lanouhn on 14-4-14.
//  Copyright (c) 2014年 lanouhn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NetWorkRequest.h"
@interface GroupShopList : UITableViewController<NetWorkRequesDelegate>
@property (nonatomic, retain) NSArray *businessArr;
@end
