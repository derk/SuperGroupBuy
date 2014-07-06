//
//  WebImageManager.h
//  LessonProject
//
//  Created by lanouhn on 14-4-8.
//  Copyright (c) 2014年 lanouhn. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WebImageManager : NSObject<NSURLConnectionDataDelegate>

@property (nonatomic,retain)UIImageView *imageView;


- (void)downloadImageWithImageURL:(id)imageURL
                 placeHolderImage:(UIImage *)image;


- (void)connectionTerminate;

@end
