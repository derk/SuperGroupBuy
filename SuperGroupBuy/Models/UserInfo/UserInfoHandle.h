//
//  UserInfoHandle.h
//  SuperGroupBuy
//
//  Created by lanouhn on 14-4-12.
//  Copyright (c) 2014年 lanouhn. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserInfoHandle : NSObject

+ (UserInfoHandle *)sharedHanle;

@property (nonatomic,retain) NSDictionary *userDic;

@end
