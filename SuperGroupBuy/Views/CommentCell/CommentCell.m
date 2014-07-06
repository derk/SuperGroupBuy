//
//  CommentCell.m
//  SuperGroupBuying
//
//  Created by lanouhn on 14-4-3.
//  Copyright (c) 2014年 lanouhn. All rights reserved.
//

#import "CommentCell.h"
#import "WebImageManager.h"
#define X 5
#define Y 5

@interface CommentCell ()
{
    UILabel *_user_nickname;
    UILabel *_text_excerpt;
    UIImageView *_rating_s_img_url;
    UILabel *_created_time;
}
@end
@implementation CommentCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        _user_nickname = [[UILabel alloc] initWithFrame:CGRectMake(X, Y, 310, 25)];
//        _user_nickname.backgroundColor = [UIColor orangeColor];
        _user_nickname.text = @"点评作者用户名";
        _user_nickname.textAlignment = NSTextAlignmentCenter;
        _user_nickname.font = [UIFont systemFontOfSize:14.0];
        [self.contentView addSubview:_user_nickname];
        
        _text_excerpt = [[UILabel alloc] initWithFrame:CGRectMake(X, Y+30, 310, 85)];
//        _text_excerpt.backgroundColor = [UIColor orangeColor];
        _text_excerpt.text = @"点评文字片断，前50字";
        _text_excerpt.textAlignment = NSTextAlignmentLeft;
        _text_excerpt.font = [UIFont systemFontOfSize:14.0];
        _text_excerpt.numberOfLines = 0;
        [self.contentView addSubview:_text_excerpt];
        
        _rating_s_img_url = [[UIImageView alloc] initWithFrame:CGRectMake(X, Y+120, 140, 25)];
//        _rating_s_img_url.backgroundColor = [UIColor orangeColor];
        [self.contentView addSubview:_rating_s_img_url];
        
        _created_time = [[UILabel alloc] initWithFrame:CGRectMake(X+160, Y+120, 150, 25)];
//        _created_time.backgroundColor = [UIColor orangeColor];
        _created_time.text = @"点评时间";
        _created_time.textAlignment = NSTextAlignmentCenter;
        _created_time.font = [UIFont systemFontOfSize:14.0];
        [self.contentView addSubview:_created_time];

        
    }
    return self;
}
- (void)configerCellWithShopComment:(ShopComment *)shopComment
{
    _user_nickname.text = shopComment.user_nickname;
    _created_time.text = shopComment.created_time;
    _text_excerpt.text = shopComment.text_excerpt;
    
    WebImageManager *manager = [[WebImageManager alloc] init];
    manager.imageView = _rating_s_img_url;
    [manager downloadImageWithImageURL:shopComment.rating_img_url placeHolderImage:nil];
    
    [manager release];
}

-(void)dealloc
{
    [_user_nickname release];
    [_text_excerpt release];
    [_rating_s_img_url release];
    [_created_time release];
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
