//
//  GroupBuyingCell.h
//  SuperGroupBuying
//
//  Created by lanouhn on 14-4-2.
//  Copyright (c) 2014年 lanouhn. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "WebImageView.h"

@class GroupBuying;

@interface GroupBuyingCell : UITableViewCell
@property (nonatomic, retain) WebImageView *s_image_url; //商户图片
@property (nonatomic, retain) UILabel *titleLable; //团购标题
@property (nonatomic, retain) UILabel *categoriesLable; //团购所属分类
@property (nonatomic, retain) UILabel *current_priceLable; //价格
@property (nonatomic, retain) UILabel *list_priceLable;//价值
@property (nonatomic, retain) UILabel *distanceLable; //距离
@property (nonatomic, retain) NSString *deal_h5_url;

//配置团购信息
- (void)configurationGroupBuyingCell:(GroupBuying *)groupBuying;
@end