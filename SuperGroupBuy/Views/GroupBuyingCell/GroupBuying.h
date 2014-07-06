//
//  GroupBuying.h
//  SuperGroupBuying
//
//  Created by lanouhn on 14-4-3.
//  Copyright (c) 2014年 lanouhn. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GroupBuying : NSObject
@property (nonatomic, copy) NSString *status;//本次API访问状态
@property (nonatomic, assign) int count;//本次API访问所获取的单页团购数量
@property (nonatomic, assign) int total_count; //所有页面团购总数
@property (nonatomic, copy) NSString *deal_id;//团购单ID
@property (nonatomic, copy) NSString *title; //团购标题
@property (nonatomic, copy) NSString *description;
@property (nonatomic, copy) NSString *city; //城市名称
@property (nonatomic, assign) float list_price;//团购包含商品原价值
@property (nonatomic, assign) float current_price; //价格
@property (nonatomic, copy) NSMutableArray *regions;
@property (nonatomic, copy) NSMutableArray *categories; //团购所属分类
@property (nonatomic, assign) float purchase_count; //团购当前已购买数
@property (nonatomic, copy) NSString *publish_date; //团购发布上线时间

@property (nonatomic, copy) NSString *purchase_deadline;//团购单的截止购买日期
@property (nonatomic, copy) NSString *distance; //距离
@property (nonatomic, copy) NSString *image_url;//团购图片链接
@property (nonatomic, copy) NSString *s_image_url;//小尺寸团购图片链接
@property (nonatomic, copy) NSString *deal_h5_url;//团购HTML5页面链接
@property (nonatomic, copy) NSString *commission_ratio;//当前团单的佣金比例
@property (nonatomic, copy) NSMutableArray *businesses;//团购所适用的商户列表
- (id)initWithGroupBuying:(NSDictionary *)dic;
 


@end
