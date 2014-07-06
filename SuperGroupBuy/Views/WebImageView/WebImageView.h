//
//  WebImageView.h
//  LessonProject
//
//  Created by lanouhn on 14-4-8.
//  Copyright (c) 2014年 lanouhn. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WebImageView : UIImageView<NSURLConnectionDataDelegate>

@property (nonatomic,retain) NSURL *imageURL;//请求数据URL
@property (nonatomic,retain) UIImage *placeholderImage;//默认图片


@end
