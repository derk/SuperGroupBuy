//
//  MyAnnotation.m
//  LessonMapDemo
//
//  Created by lanouhn on 14-4-11.
//  Copyright (c) 2014年 lanouhn. All rights reserved.
//

#import "MyAnnotation.h"

@implementation MyAnnotation
- (id)initWithLatitude:(CLLocationDegrees)latitude
             longitude:(CLLocationDegrees)longitude
                 titlt:(NSString *)title
              subtitle:(NSString *)subtitle
{
    self = [super init];
    if (self) {
        self.latitude = latitude;
        self.longtitude = longitude;
        self.title = title;
        self.subtitle = subtitle;
    }
    return self;
}

- (void)setCoordinate:(CLLocationCoordinate2D)newCoordinate
{
    self.latitude = newCoordinate.latitude;
    self.longtitude = newCoordinate.longitude;
}

- (CLLocationCoordinate2D)coordinate
{
    return CLLocationCoordinate2DMake(self.latitude, self.longtitude);
}
- (void)dealloc
{
    [_title release];
    [_subtitle release];
    [super dealloc];
}

@end
