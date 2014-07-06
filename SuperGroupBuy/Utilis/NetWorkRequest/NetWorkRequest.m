//
//  NetWorkRequest.m
//  LessonProject
//
//  Created by lanouhn on 14-4-1.
//  Copyright (c) 2014年 lanouhn. All rights reserved.
//

#import "NetWorkRequest.h"
#import "UIWindow+YzdHUD.h"
@interface NetWorkRequest ()

@property (nonatomic,retain) NSURLConnection *connection;
@property (nonatomic,retain) NSMutableData *data;
@end

@implementation NetWorkRequest


//get请求
- (void)loadDataWithURLString:(NSString *)urlString
{
    NSString *newUrlString = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *url = [NSURL URLWithString:newUrlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    self.connection  = [NSURLConnection connectionWithRequest:request delegate:self];
}


#pragma mark - NSURLConnectionDataDelegate
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
//    [[[UIApplication sharedApplication] keyWindow] showHUDWithText:@"加载中" Type:ShowLoading Enabled:YES];
    self.data = [NSMutableData data];
}
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [self.data appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    //判断代理是否实现了协议里的方法，如果实现了就调用，如果没有实现就不调用
    if ([self.deligate respondsToSelector:@selector(request:didFinishing:)]) {
        
        [self.deligate request:self didFinishing:self.data];
    }
    //当代理（viewController）被释放后，这如果没有取消连接，会导致程序崩在这行
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    
    if ([self.deligate respondsToSelector:@selector(request:didFailWithError:)]) {
        
        [self.deligate request:self didFailWithError:error];
    }
}//


//post请求
- (void)loadDataWithURLString:(NSString *)urlString
                   parmString:(NSString *)parmString
{
    NSURL *url  =  [NSURL URLWithString:urlString];
    NSData *parmData = [parmString dataUsingEncoding:NSUTF8StringEncoding];
    NSMutableURLRequest *request= [NSMutableURLRequest requestWithURL:url];
    [request setHTTPBody:parmData];
    [request setHTTPMethod:@"post"];
    
    self.connection = [NSURLConnection connectionWithRequest:request delegate:self];
    
}



//中断连接
- (void)connectionTerminate
{
    [self.connection cancel];
}



- (void)dealloc
{
    [_connection release];
    [_data release];
    [super dealloc];
}



@end
