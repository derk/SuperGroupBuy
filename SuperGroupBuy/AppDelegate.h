//
//  AppDelegate.h
//  SuperGroupBuy
//
//  Created by lanouhn on 14-4-10.
//  Copyright (c) 2014年 lanouhn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RennSDK/RennSDK.h"
@interface AppDelegate : UIResponder <UIApplicationDelegate,WeiboSDKDelegate,RennLoginDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) NSString *wbtoken;
@end
