//
//  InterfaceRequest.h
//  Demo
//
//  Created by lanouhn on 14-4-9.
//  Copyright (c) 2014年 niuyuping. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef enum
{
    CategotyInterface,
    RegionInterface,
    CityInteface
}InterfaceRequestOptions;
typedef enum
{
    InterfaceRequestCateroyBusiness,
    InterfaceRequestCateroyGroupon,
    InterfaceRequestCateroyCoupon
}InterfaceRequestCateroyOptions;

@interface InterfaceRequest : NSObject
//根据选定的城市以及指定的商家或者团购,优惠券,以及指定的区域,分类,排序 封装成一个URLString
+ (NSString *)getURLStringByInterfaceWithCateroyOption:(InterfaceRequestCateroyOptions)categoryOption requestOption:(InterfaceRequestOptions)requestOption city:(NSString *)city;
//根据指定的商家或者团购,优惠券 以及拼接的参数字典封装成一个URLString
+ (NSString *)getURLStringByFindCategoryWithCateroyOption:(InterfaceRequestCateroyOptions)categoryOption parmDic:(NSMutableDictionary *)parmDic;
@end
