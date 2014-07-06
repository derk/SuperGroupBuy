//
//  CommentCell.h
//  SuperGroupBuying
//
//  Created by lanouhn on 14-4-3.
//  Copyright (c) 2014年 lanouhn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ShopComment.h"
@interface CommentCell : UITableViewCell
- (void)configerCellWithShopComment:(ShopComment *)shopComment;
@end
