//
//  Shops.h
//  SuperGroupBuying
//
//  Created by lanouhn on 14-4-7.
//  Copyright (c) 2014年 lanouhn. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Shops : NSObject

@property (nonatomic,copy) NSString *business_id;//商店ID
@property (nonatomic,copy) NSString *name;//店名
@property (nonatomic,copy) NSString *branch_name;//分店名
@property (nonatomic,copy) NSString *s_photo_url;//商店图片链接
@property (nonatomic,copy) NSString *rating_s_img_url;//服务星级图片
@property (nonatomic,copy) NSString *distance;//商户与参数坐标的距离，单位为米，如不传入经纬度坐标，结果为-1
@property (nonatomic,copy) NSString *review_count;//点评数量
- (id)initWithDic:(NSDictionary *)dic;

@end
