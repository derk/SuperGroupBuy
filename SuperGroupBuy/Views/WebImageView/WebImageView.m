//
//  WebImageView.m
//  LessonProject
//
//  Created by lanouhn on 14-4-8.
//  Copyright (c) 2014年 lanouhn. All rights reserved.
//

#import "WebImageView.h"



@interface WebImageView ()
{
    NSString *_newFilePath;
}
@property (nonatomic,retain) NSMutableData *data;
@property (nonatomic,retain) NSURLConnection *connection;
@end
@implementation WebImageView

//重写setImageURL 方法
- (void)setImageURL:(NSURL *)imageURL
{
    [self.connection cancel];//空 做任何事情都是无效，取消上次的连接，否则滑动太快重用会出现重复
    
    if (_imageURL != imageURL) {
        [_imageURL release];
        _imageURL = [imageURL retain];
    }
    
    self.image = _placeholderImage;
    
    if (self.imageURL) {//getter方法，不会死循环，不是直接调自己
        
        NSString *imageDir = [NSString stringWithFormat:@"%@/Library/Caches/%@", NSHomeDirectory(), @"image"];
        BOOL isDir = NO;
        NSFileManager *fileManager2 = [NSFileManager defaultManager];
        BOOL existed = [fileManager2 fileExistsAtPath:imageDir isDirectory:&isDir];
        if ( !(isDir == YES && existed == YES) )
        {
            [fileManager2 createDirectoryAtPath:imageDir withIntermediateDirectories:YES attributes:nil error:nil];
        }
        
//        //1.先获取Caches文件夹的路径
//        NSString *cachesPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0];//yes 绝对路径
        
        //2.拼接图片文件路径
        NSString *imageName = [[_imageURL absoluteString] stringByReplacingOccurrencesOfString:@"/" withString:@"_"];//图片请求的URL唯一标识图片
        
        _newFilePath = [[imageDir stringByAppendingPathComponent:imageName] retain];
        
        //3.创建 NSFileManager 对象
        NSFileManager *fileManager = [NSFileManager defaultManager];
        
        //4.判断该文件是否存在
        if ([fileManager fileExistsAtPath:_newFilePath]) {
            //如果存在，说明有缓存，则直接从本地读取
            self.image = [UIImage imageWithContentsOfFile:_newFilePath];
        }else {
            //如果没有，则从网络上请求数据
            NSURLRequest *request = [NSURLRequest requestWithURL:_imageURL];
         self.connection = [NSURLConnection connectionWithRequest:request delegate:self];
            
        }
        
    }
}

-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    self.data = [NSMutableData data];
}
-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [self.data appendData:data];
}
-(void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    [self.data writeToFile:_newFilePath atomically:YES];
    self.image = [UIImage imageWithData:self.data];
}

-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    NSLog(@"%@",[error userInfo]);
}


//重写setPlaceholderImage 方法

- (void)setPlaceholderImage:(UIImage *)placeholderImage
{
    if (_placeholderImage != placeholderImage) {
        [_placeholderImage release];
        _placeholderImage = [placeholderImage retain];
        self.image = placeholderImage;
    }
    
}

- (void)dealloc
{
    [_imageURL release];
    [_data release];
    [_newFilePath release];
    [_placeholderImage release];
    [_connection release];
    [super dealloc];
}

@end
