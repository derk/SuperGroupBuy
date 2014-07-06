//
//  NewDorpDown.h
//  DropDownLsit
//
//  Created by lanouhn on 14-4-6.
//  Copyright (c) 2014年 lanouhn. All rights reserved.
//

#import <UIKit/UIKit.h>



@protocol NewDorpDownDelegate <NSObject>

@optional
- (void)dropDownDelegateMethod;

@end

@interface NewDorpDown : UIView<UITableViewDataSource,UITableViewDelegate>

@property(nonatomic,assign)id <NewDorpDownDelegate> delegate;

@property(nonatomic,retain)UIButton *button;

- (id)initWithButton:(UIButton *)button array:(NSArray *)array height:(CGFloat)height;

@end
