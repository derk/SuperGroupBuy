//
//  InterfaceRequest.m
//  Demo
//
//  Created by lanouhn on 14-4-9.
//  Copyright (c) 2014年 niuyuping. All rights reserved.
//

#import "InterfaceRequest.h"
#import "CommonDefine.h"
#import "SignatrueEncryption.h"
#define URL @"http://api.dianping.com/v1/metadata"
#define kFind_Business @"http://api.dianping.com/v1/business/find_businesses"
#define kFind_Deals @"http://api.dianping.com/v1/deal/find_deals"
#define kFind_Coupon @"http://api.dianping.com/v1/coupon/find_coupons"
@implementation InterfaceRequest
+ (NSString *)getURLStringByInterfaceWithCateroyOption:(InterfaceRequestCateroyOptions)categoryOption requestOption:(InterfaceRequestOptions)requestOption city:(NSString *)city;
{
    NSMutableDictionary *parmDic = [NSMutableDictionary  dictionaryWithObjectsAndKeys:city,@"city",nil];
    NSMutableDictionary *encryDic = [SignatrueEncryption encryptedParamsWithBaseParams:parmDic];
    NSString *categoryString = nil;
    switch (categoryOption) {
        case InterfaceRequestCateroyBusiness:
            categoryString = @"businesses";
            break;
        case InterfaceRequestCateroyGroupon:
            categoryString = @"deals";
            break;
        case InterfaceRequestCateroyCoupon:
            categoryString = @"coupons";
            break;
        default:
            break;
    }
    NSString *requestString = nil;
    switch (requestOption) {
        case CategotyInterface:
            requestString = @"categories";
            break;
        case RegionInterface:
            requestString = @"regions";
            break;
        case CityInteface:
            requestString = @"cities";
            break;
        default:
            break;
    }
    NSString *urlString = [NSString stringWithFormat:@"%@/get_%@_with_%@?appkey=%@&sign=%@&city=%@", URL, requestString, categoryString, kAPP_KEY, [encryDic objectForKey:@"sign"], [encryDic objectForKey:@"city"]];
//    return [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    return urlString;
}
+ (NSString *)getURLStringByFindCategoryWithCateroyOption:(InterfaceRequestCateroyOptions)categoryOption parmDic:(NSMutableDictionary *)parmDic
{
    NSMutableDictionary *encryDic = [SignatrueEncryption encryptedParamsWithBaseParams:parmDic];
    NSArray *allKeys = [parmDic allKeys];
    NSString *categoryString = nil;
    switch (categoryOption) {
        case InterfaceRequestCateroyBusiness:
            categoryString = kFind_Business;
            break;
        case InterfaceRequestCateroyGroupon:
            categoryString = kFind_Deals;
            break;
        case InterfaceRequestCateroyCoupon:
            categoryString = kFind_Coupon;
            break;
        default:
            break;
    }
    NSMutableString *str = [NSMutableString stringWithFormat:@"%@?appkey=%@&sign=%@", categoryString, kAPP_KEY, [encryDic objectForKey:@"sign"]];
    for (NSString *key in allKeys) {
        [str appendFormat:@"&%@=%@", key, [parmDic objectForKey:key]];
    }
//    return [str stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    return str;
}
@end
