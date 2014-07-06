//
//  ShopComment.h
//  SuperGroupBuying
//
//  Created by lanouhn on 14-4-8.
//  Copyright (c) 2014年 lanouhn. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ShopComment : NSObject
@property (nonatomic,copy) NSString *user_nickname;
@property (nonatomic,copy) NSString *created_time;
@property (nonatomic,copy) NSString *text_excerpt;
@property (nonatomic,copy) NSString *rating_img_url;
@property (nonatomic,copy) NSString *review_url;
@property (nonatomic,copy) NSString *additional_info_more_reviews_url;
- (id)initWithDic:(NSDictionary *)dic;
@end
