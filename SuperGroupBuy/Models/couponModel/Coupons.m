//
//  Coupons.m
//  SuperGroupBuying
//
//  Created by lanouhn on 14-4-5.
//  Copyright (c) 2014年 lanouhn. All rights reserved.
//

#import "Coupons.h"

@implementation Coupons

- (id)initWithDictionary:(NSDictionary *)dictionary{
    self = [super init];
    if (self) {
        [self setValuesForKeysWithDictionary:dictionary];
    }
    return self;
}
- (void)setValue:(id)value forUndefinedKey:(NSString *)key{
    
}
- (id)valueForUndefinedKey:(NSString *)key{
    return nil;
}
- (void)dealloc
{
    [_coupon_id release];
    [_regions release];//商户所在行政区
    [_categories release];//优惠券所属分类
    [_download_count release];//当前下载数量
    [_publish_date release];//上线日期
    [_expiration_date release];//截止日期
    [_description release];//优惠券描述
    [_title release];//优惠券标题
    [_logo_img_url release];//优惠券图片
    [_coupon_h5_url release];//优惠券的WEb 网页
    [super dealloc];
}

@end
