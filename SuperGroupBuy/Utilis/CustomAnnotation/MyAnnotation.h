//
//  MyAnnotation.h
//  LessonMapDemo
//
//  Created by lanouhn on 14-4-11.
//  Copyright (c) 2014年 lanouhn. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
//自定义大头针，需要服从协议MKAnnotation,切记，我们定义的MyAnnotation类只是一个Modellei ,只是存储要显示的信息

@interface MyAnnotation : NSObject<MKAnnotation>

@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;//经纬度结构体变量
@property (nonatomic, copy) NSString *title;//标题
@property (nonatomic, copy) NSString *subtitle;//子标题

@property (nonatomic,assign) CLLocationDegrees latitude;//纬度
@property (nonatomic,assign) CLLocationDegrees longtitude;//经度
//初始化方法
- (id)initWithLatitude:(CLLocationDegrees)latitude
             longitude:(CLLocationDegrees)longitude
                 titlt:(NSString *)title
              subtitle:(NSString *)subtitle;
//设置新的经纬度
- (void)setCoordinate:(CLLocationCoordinate2D)newCoordinate;
@end
