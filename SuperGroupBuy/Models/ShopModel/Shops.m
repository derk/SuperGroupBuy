//
//  Shops.m
//  SuperGroupBuying
//
//  Created by lanouhn on 14-4-7.
//  Copyright (c) 2014年 lanouhn. All rights reserved.
//

#import "Shops.h"

@implementation Shops
- (id)initWithDic:(NSDictionary *)dic
{
    self = [super init];
    if (self) {
        [self setValuesForKeysWithDictionary:dic];
    }
    return self;
}
//实现此方法，当key没有找到可赋值的对象的时候，就会自动调用该方法
-(void)setValue:(id)value forUndefinedKey:(NSString *)key
{
//    NSLog(@"%@",key);
}
//当实现此方法，当key没有找到可输出 对象的时候，就会调用这个方法
-(id)valueForUndefinedKey:(NSString *)key
{
    return @"";
}
-(void)dealloc
{
    [_name release];
    [_s_photo_url release];
    [_rating_s_img_url release];
    [_branch_name release];
    [_distance release];
    [super dealloc];
}
@end
