//
//  CityListVC.h
//  SuperGroupBuying
//
//  Created by lanouhn on 14-4-2.
//  Copyright (c) 2014年 lanouhn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NetWorkRequest.h"



@protocol CityListVCDelegate <NSObject>

- (void)setCityListDelegate:(NSString *)city;

@end

@interface CityListVC : UITableViewController<NetWorkRequesDelegate,UISearchDisplayDelegate,UISearchBarDelegate>

@property(nonatomic,assign) id<CityListVCDelegate> delegete;
@property (nonatomic,assign) NSInteger cityFlag;


@end
