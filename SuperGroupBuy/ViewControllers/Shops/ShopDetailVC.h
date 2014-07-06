//
//  ShopDetailVC.h
//  SuperGroupBuying
//
//  Created by lanouhn on 14-4-2.
//  Copyright (c) 2014年 lanouhn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NetWorkRequest.h"
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>
#import "RennSDK/RennSDK.h"
@interface ShopDetailVC : UIViewController<NetWorkRequesDelegate,UIAlertViewDelegate,MKMapViewDelegate,UIActionSheetDelegate,RennLoginDelegate,UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,copy) NSString *shopID;
@property(nonatomic,retain)CLLocation *theNewLocation;//当前坐标
@end
