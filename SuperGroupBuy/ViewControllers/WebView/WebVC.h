//
//  WebVC.h
//  SuperGroupBuying
//
//  Created by lanouhn on 14-4-2.
//  Copyright (c) 2014年 lanouhn. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WebVC : UIViewController<UIWebViewDelegate,UIScrollViewDelegate,UIGestureRecognizerDelegate>

@property (nonatomic,copy) NSString *h5Url;


@end
