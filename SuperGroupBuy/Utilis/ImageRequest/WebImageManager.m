//
//  WebImageManager.m
//  LessonProject
//
//  Created by lanouhn on 14-4-8.
//  Copyright (c) 2014年 lanouhn. All rights reserved.
//

#import "WebImageManager.h"

@interface WebImageManager ()
{
    NSString *_newFilePath;
}

@property (nonatomic,retain) NSURLConnection *connection;
@property (nonatomic,retain) NSMutableData *data;
@end


@implementation WebImageManager

- (void)downloadImageWithImageURL:(id)imageURL
                 placeHolderImage:(UIImage *)image
{
    //isKindOfClass:判断当前对象的类型是否和给定类型相同，或者是否是给定类型的子类
    //isMemberOfClass:判断当前对象的类型，和给定的类型是否相同
    self.imageView.image = image;
    NSURL *url = nil;
    
    if ([imageURL isKindOfClass:[NSURL class]]) {
        url = imageURL;
    }else if([imageURL isKindOfClass:[NSString class]]){
        url = [NSURL URLWithString:imageURL];
    }
    
    NSString *imageDir = [NSString stringWithFormat:@"%@/Library/Caches/%@", NSHomeDirectory(), @"image"];
    BOOL isDir = NO;
    NSFileManager *fileManager2 = [NSFileManager defaultManager];
    BOOL existed = [fileManager2 fileExistsAtPath:imageDir isDirectory:&isDir];
    if ( !(isDir == YES && existed == YES) )
    {
        [fileManager2 createDirectoryAtPath:imageDir withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
    //1.先获取Caches文件夹的路径
//    NSString *cachesPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0];//yes 绝对路径

    
    //2.拼接图片文件路径
    NSString *imageName = [[url absoluteString] stringByReplacingOccurrencesOfString:@"/" withString:@"_"];//图片请求的URL唯一标识图片
    
    _newFilePath = [[imageDir stringByAppendingPathComponent:imageName] retain];
    
    //3.创建 NSFileManager 对象
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    //4.判断该文件是否存在
    if ([fileManager fileExistsAtPath:_newFilePath]) {
        //如果存在，说明有缓存，则直接从本地读取
        self.imageView.image = [UIImage imageWithContentsOfFile:_newFilePath];
    }else {
        //如果没有，则从网络上请求数据
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        self.connection = [NSURLConnection connectionWithRequest:request delegate:self];
 
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
    self.imageView.image = [UIImage imageWithData:self.data];
}

-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    NSLog(@"%@",[error userInfo]);
}

- (void)connectionTerminate
{
    [self.connection cancel];
}

-(void)dealloc
{
    [_connection release];
    [_data release];
    [_imageView release];
    [_newFilePath release];
    [super dealloc];
}





@end
