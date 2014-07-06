//
//  NetWorkRequest.h
//  LessonProject
//
//  Created by lanouhn on 14-4-1.
//  Copyright (c) 2014年 lanouhn. All rights reserved.
//

#import <Foundation/Foundation.h>
@class NetWorkRequest;

@protocol NetWorkRequesDelegate <NSObject>

@optional

//请求数据成功之后执行代理方法
- (void)request:(NetWorkRequest *)netWorkRequest
   didFinishing:(NSData *)data;

//请求数据失败之后执行代理方法
- (void)request:(NetWorkRequest *)netWorkRequest
didFailWithError:(NSError *)error;


@end


@interface NetWorkRequest : NSObject<NSURLConnectionDataDelegate>


@property (nonatomic,assign) id <NetWorkRequesDelegate> deligate;



//get请求
- (void)loadDataWithURLString:(NSString *)urlString;

//post请求
- (void)loadDataWithURLString:(NSString *)urlString
                   parmString:(NSString *)parmString;
//中断连接
- (void)connectionTerminate;


@end
