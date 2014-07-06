//
//  ShopDetail.h
//  SuperGroupBuying
//
//  Created by lanouhn on 14-4-7.
//  Copyright (c) 2014年 lanouhn. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ShopDetail : NSObject
@property (nonatomic,copy) NSString *name;//商店名
@property (nonatomic,copy) NSString *photo_url;//商店图片链接
@property (nonatomic,copy) NSString *rating_img_url;//评价星级
@property (nonatomic,copy) NSString *decoration_grade;//环境评价
@property (nonatomic,copy) NSString *service_grade;//服务评价
@property (nonatomic,copy) NSString *avg_price;//人均价格
@property (nonatomic,copy) NSString *address;//地址
@property (nonatomic,copy) NSString *telephone;//电话
@property (nonatomic,copy) NSString *coupon_description;//优惠券描述
@property (nonatomic,copy) NSString *deals_description;//团购描述
@property (nonatomic,copy) NSString *has_coupon;//是否有优惠券
@property (nonatomic,copy) NSString *has_deal;//是否有团购
@property (nonatomic,copy) NSString *business_url;//
@property (nonatomic,copy) NSString *latitude;//纬度坐标
@property (nonatomic,copy) NSString *longitude;//经度坐标
@property (nonatomic,copy) NSString *deal_count;//商户当前在线团购数量
@property (nonatomic,copy) NSString *coupon_id;//优惠券ID
@property (nonatomic,retain) NSArray *deals;//团购列表
- (id)initWithDic:(NSDictionary *)dic;

@end
