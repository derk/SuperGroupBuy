//
//  Coupons.h
//  SuperGroupBuying
//
//  Created by lanouhn on 14-4-5.
//  Copyright (c) 2014年 lanouhn. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Coupons : NSObject
//@property(nonatomic,copy)NSString *businesses_Name;//商户名
//@property(nonatomic,copy)NSString *businesses_id;//商户ID
@property(nonatomic,copy)NSString *coupon_id;//优惠券ID
@property(nonatomic,copy)NSString *title;//优惠券标题
@property(nonatomic,copy)NSString *description;//优惠券描述
@property(nonatomic,retain)NSMutableArray *regions;//商户所在行政区
@property(nonatomic,retain)NSMutableArray *categories;//优惠券所属分类
@property(nonatomic,copy)NSString *download_count;//当前下载数量
@property(nonatomic,copy)NSString *publish_date;//上线日期
@property(nonatomic,copy)NSString *expiration_date;//截止日期


//@property(nonatomic,assign)NSInteger distance;//


@property(nonatomic,copy)NSString *logo_img_url;//优惠券图片
@property(nonatomic,copy)NSString *coupon_h5_url;//优惠券的WEb 网页
@property(nonatomic,retain)NSMutableArray *businesses;//适用商家列表


- (id)initWithDictionary:(NSDictionary *)dictionary;
@end
