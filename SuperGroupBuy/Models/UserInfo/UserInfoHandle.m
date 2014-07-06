//
//  UserInfoHandle.m
//  SuperGroupBuy
//
//  Created by lanouhn on 14-4-12.
//  Copyright (c) 2014年 lanouhn. All rights reserved.
//

#import "UserInfoHandle.h"

@implementation UserInfoHandle

static UserInfoHandle * user;
+ (UserInfoHandle *)sharedHanle;
{
    if (user == nil) {
        user = [[UserInfoHandle alloc] init];
    }
    return user;
}
@end
