//
//  GroupBuyingCell.m
//  SuperGroupBuying
//
//  Created by lanouhn on 14-4-2.
//  Copyright (c) 2014年 lanouhn. All rights reserved.
//

#import "GroupBuyingCell.h"
#import "GroupBuying.h"
#define MARGIN_LEFT 15
#define MARGIN_TOP 10
#define MARGIN_HEIGHT 20
#import "WebImageManager.h"
#import "WebVC.h"
@implementation GroupBuyingCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        [self creatGroupBuyingCellView];
    }
    return self;
}
- (void)creatGroupBuyingCellView
{
    //商户图片

    
    
    self.s_image_url = [[WebImageView alloc] initWithFrame:CGRectMake(MARGIN_LEFT, MARGIN_TOP, 120, 90)];
    self.s_image_url.placeholderImage = [UIImage imageNamed:@"loading.jpg"];
//    self.s_image_url.backgroundColor = [UIColor redColor];
    
    [self.contentView addSubview:_s_image_url];
    
    [_s_image_url release];
    //团购标题
    self.titleLable = [[UILabel alloc] initWithFrame:CGRectMake(MARGIN_LEFT + 130, MARGIN_TOP+5,160, MARGIN_HEIGHT)];
//    self.titleLable.backgroundColor = [UIColor redColor];
//    self.titleLable.adjustsFontSizeToFitWidth = YES;
    [self.contentView addSubview:_titleLable];
    [_titleLable release];
    //团购所属分类
    self.categoriesLable = [[UILabel alloc] initWithFrame:CGRectMake(MARGIN_LEFT + 130, MARGIN_TOP + MARGIN_HEIGHT + 5+10, 100, MARGIN_HEIGHT)];
//    self.categoriesLable.backgroundColor = [UIColor redColor];
    [self.contentView addSubview:_categoriesLable];
    [_categoriesLable release];
    //价格
    self.current_priceLable = [[UILabel alloc] initWithFrame:CGRectMake(MARGIN_LEFT + 130, MARGIN_TOP + MARGIN_HEIGHT*2+10+10+10, 100, MARGIN_HEIGHT)];
//    self.current_priceLable.backgroundColor = [UIColor redColor];
    
    [self.contentView addSubview:_current_priceLable];
    [_current_priceLable release];
  //价值
    self.list_priceLable = [[UILabel alloc] initWithFrame:CGRectMake(MARGIN_LEFT +200  + 30, MARGIN_TOP + MARGIN_HEIGHT*2+10+10+10, 70, MARGIN_HEIGHT)];
//    [self setCenterLineView:self.list_priceLable];
//    self.list_priceLable.backgroundColor = [UIColor redColor];
    [self.contentView addSubview:_list_priceLable];
    [_list_priceLable release];
    
    //距离
//    self.distanceLable = [[UILabel alloc] initWithFrame:CGRectMake(MARGIN_LEFT +200 + 20 + 30, MARGIN_TOP + MARGIN_HEIGHT*2+10, 50, MARGIN_HEIGHT)];
////    self.distanceLable.backgroundColor = [UIColor redColor];
//    [self.contentView addSubview:_distanceLable];
//    [_distanceLable release];
}
//设置中划线
- (void)setCenterLineView:(UILabel *)label
{
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:1],NSStrikethroughStyleAttributeName, nil];
    label.font = [UIFont fontWithName:@"Thonburi-Bold" size:14];
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:label.text attributes:dic];
    label.attributedText = str;
    [str release];
}

- (void)configurationGroupBuyingCell:(GroupBuying *)groupBuying
{
    self.deal_h5_url = groupBuying.deal_h5_url;
    self.s_image_url.imageURL = [NSURL URLWithString:groupBuying.s_image_url];
    // [group release];
    self.titleLable.text = groupBuying.title;
    
    for (NSString *temp in groupBuying.categories) {
        self.categoriesLable.text = [NSString stringWithFormat:@"%@ ",temp];
    }
    self.current_priceLable.text = [NSString stringWithFormat:@"￥%.1f",groupBuying.current_price];
    self.current_priceLable.font = [UIFont fontWithName:nil size:20];
    self.list_priceLable.text = [NSString stringWithFormat:@"￥ %.1f",groupBuying.list_price];
    [self setCenterLineView:_list_priceLable];
    
    self.distanceLable.text = [NSString stringWithFormat:@"%@ km",groupBuying.distance];


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
- (void) dealloc
{
    [_s_image_url release];
    [_titleLable release];
    [_current_priceLable release];
    [_categoriesLable release];
    [_distanceLable release];
    [super dealloc];
    
    
}@end
