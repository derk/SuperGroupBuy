//
//  ShopGroupList.h
//  SuperGroupBuy
//
//  Created by lanou3g on 14-4-22.
//  Copyright (c) 2014年 lanouhn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NetWorkRequest.h"
@interface ShopGroupList : UITableViewController<NetWorkRequesDelegate>
@property (nonatomic, retain) NSArray *shopGropArr;
@end
