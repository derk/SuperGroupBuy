//
//  ShopDetail.m
//  SuperGroupBuying
//
//  Created by lanouhn on 14-4-7.
//  Copyright (c) 2014年 lanouhn. All rights reserved.
//

#import "ShopDetail.h"

@implementation ShopDetail


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
    [_name release];//商店名
    [_photo_url release];//商店图片链接
    [_rating_img_url release];//评价星级
    [_decoration_grade release];//环境评价
    [_service_grade release];//服务评价
    [_avg_price release];//人均价格
    [_address release];//地址
    [_telephone release];//电话
    [_coupon_description release];//优惠券描述
    [_deals_description release];//团购描述
    [_has_coupon release];
    [_has_deal release];
    [_business_url release];//详情界面
    [super dealloc];

}
@end
