//
//  ShopCell.m
//  SuperGroupBuying
//
//  Created by lanouhn on 14-4-2.
//  Copyright (c) 2014年 lanouhn. All rights reserved.
//

#import "ShopCell.h"
#import "Shops.h"
#import "WebImageManager.h"
#define X 5
#define Y 10

@interface ShopCell ()

@property (nonatomic,retain) UIImageView *s_photo_url;
@property (nonatomic,retain) UILabel *name;
@property (nonatomic,retain) UILabel *branch_name;
@property (nonatomic,retain) UIImageView *rating_s_img_url;
@property (nonatomic,retain) UILabel *starName;
@property (nonatomic,retain) UILabel *review_count;
@end
@implementation ShopCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.s_photo_url = [[UIImageView alloc] initWithFrame:CGRectMake(X, Y, 120, 90)];

        [self.contentView addSubview:_s_photo_url];
        [_s_photo_url release];
        self.name = [[UILabel alloc] initWithFrame:CGRectMake(X+130, Y, 160, 20)];
        _name.text = @"店名";
        _name.numberOfLines = 0;
        _name.font = [UIFont systemFontOfSize:14.0];
        [self.contentView addSubview:_name];
        [_name release];
        
        self.starName = [[UILabel alloc] initWithFrame:CGRectMake(X+130, Y+30, 40, 20)];
        _starName.text = @"评分";
        _starName.font = [UIFont systemFontOfSize:14.0];
        self.rating_s_img_url = [[UIImageView alloc] initWithFrame:CGRectMake(X+130, Y+30, 110, 20)];
        [self.contentView addSubview:_rating_s_img_url];
        [_rating_s_img_url release];
        
        self.branch_name = [[UILabel alloc] initWithFrame:CGRectMake(X+130, Y+65, 100, 20)];
        _branch_name.text = @"分店";
        _branch_name.font = [UIFont systemFontOfSize:12.0];
        [self.contentView addSubview:_branch_name];
        [_branch_name release];
        
        self.review_count = [[UILabel alloc] initWithFrame:CGRectMake(X+230, Y+65, 80, 20)];
        _review_count.text = @"点评数量";
        _review_count.font = [UIFont systemFontOfSize:12.0];
        [self.contentView addSubview:_review_count];
        [_review_count release];


    }
    return self;
}
- (void)configerCellWithShop:(Shops *)shop
{
    self.name.text = shop.name;
    if ([shop.branch_name isEqualToString:@""]) {
        self.branch_name.text = @"暂无分店";
    }else{
        self.branch_name.text = shop.branch_name;
    }
    
    self.review_count.text = [NSString stringWithFormat:@"点评量:  %@",[(NSNumber *)shop.review_count stringValue]];

    WebImageManager *manager = [[WebImageManager alloc] init];
    manager.imageView = self.s_photo_url;
    [manager downloadImageWithImageURL:shop.s_photo_url placeHolderImage:[UIImage imageNamed:@"loading.jpg"]];
    
    [manager release];
    
    WebImageManager *manager2 = [[WebImageManager alloc] init];
    manager2.imageView = self.rating_s_img_url;
    [manager2 downloadImageWithImageURL:shop.rating_s_img_url placeHolderImage:nil];
    [manager2 release];
   
//    NSLog(@"距离：%@",shop.distance);
}

-(void)dealloc
{
    [_s_photo_url release];
    [_name release];
    
//    [_starName release];
    [_rating_s_img_url release];
    [_branch_name release];
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
