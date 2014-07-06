//
//  GroupBuying.m
//  SuperGroupBuying
//
//  Created by lanouhn on 14-4-3.
//  Copyright (c) 2014年 lanouhn. All rights reserved.
//

#import "GroupBuying.h"

@implementation GroupBuying
- (id)initWithGroupBuying:(NSDictionary *)dic
{
    self = [super init];
    if (self) {
        [self setValuesForKeysWithDictionary:dic];
    }
    return self;
}
- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    
//    NSLog(@"%@",key);
    
}
- (id)valueForUndefinedKey:(NSString *)key
{
    
    return nil;
}

- (void)dealloc
{
    [_status release];
    
    [_deal_id release];
    [_title release];
    [_description release];
    [_city release];
    
    
    [_regions release];
    [_categories release];
    
    [_publish_date release];
    [_purchase_deadline release];
    [_distance release];
    
    [_image_url release];
    [_s_image_url release];
    [_deal_h5_url release];
    [_businesses release];
    [super dealloc];
}

@end
