//
//  CouponCell.m
//  SuperGroupBuying
//
//  Created by lanouhn on 14-4-2.
//  Copyright (c) 2014年 lanouhn. All rights reserved.
//

#import "CouponCell.h"
#import "WebImageManager.h"

@interface CouponCell ()
@property(nonatomic,retain)UIImageView *logo_img_url;//店面图片(优惠券图片)
@property(nonatomic,retain)UILabel *businesses_name;//商户名
@property(nonatomic,retain)UILabel *description;//优惠券描述
@property(nonatomic,retain)UILabel *download_count;//优惠券下载数量
@property(nonatomic,retain)UILabel *categories;//优惠券类型
//@property(nonatomic,retain)UILabel *title;//优惠券标题
@property(nonatomic,retain)UILabel *regions;//优惠券商户所在行政区域
@end

@implementation CouponCell
- (void)queryCoupon:(Coupons *)coupon
{
    WebImageManager *web = [[WebImageManager alloc]init];
    web.imageView = _logo_img_url;
    [web downloadImageWithImageURL:coupon.logo_img_url placeHolderImage:[UIImage imageNamed:@"loading.jpg"]];
    _businesses_name.text = [[coupon.businesses objectAtIndex:0]objectForKey:@"name"];
    _description.text = coupon.description;
    _download_count.text = [NSString stringWithFormat:@"下载量：%@",coupon.download_count];
    _categories.text = [coupon.categories objectAtIndex:0];
    [web release];

    
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.logo_img_url = [[UIImageView alloc]init];
        _logo_img_url.frame = CGRectMake(5, 5, 120, 90);
        //        _logo_img_url.backgroundColor = [UIColor redColor];
        [self.contentView addSubview:_logo_img_url];
        [_logo_img_url release];
        
        self.businesses_name = [[UILabel alloc]init];
        _businesses_name.frame = CGRectMake(130, 5, 190, 30);
//        _businesses_name.backgroundColor = [UIColor redColor];
        [self.contentView addSubview:_businesses_name];
        [_businesses_name release];
        
        self.description = [[UILabel alloc]init];
        _description.frame = CGRectMake(130, 40, 170, 30);
        //        _description.backgroundColor = [UIColor redColor];
        [self.contentView addSubview:_description];
        [_description release];
        
        self.download_count = [[UILabel alloc]init];
        _download_count.frame = CGRectMake(240, 75, 80, 20);
//        _download_count.backgroundColor = [UIColor redColor];
        _download_count.font = [UIFont systemFontOfSize:12.0];
        [self.contentView addSubview:_download_count];
        [_download_count release];
        
        self.categories = [[UILabel alloc] initWithFrame:CGRectMake(130, 75, 110, 20)];
//        _categories.backgroundColor = [UIColor orangeColor];
        _categories.font = [UIFont systemFontOfSize:12.0];
        [self.contentView addSubview:_categories];
        [_categories release];
        

        
    }
    return self;
}
- (void)dealloc
{
    [_regions release];
    [_categories release];
    [_download_count release];
    [_description release];
    [_businesses_name release];
    [_logo_img_url release];
    [super dealloc];
}
- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
