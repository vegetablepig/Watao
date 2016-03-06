//
//  WTUtility.h
//  Watao
//
//  Created by 连 承亮 on 14-3-26.
//  Copyright (c) 2014年 连 承亮. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GLKit/GLKit.h>

typedef struct{
    GLKVector3 pa;
    GLKVector3 pb;
}WTLine;

typedef struct{
    GLKVector3 pa;
    GLKVector3 pb;
    GLKVector3 pc;
    //pay attention that these three point must not be in a line
}WTPlane;


@interface WTUtility : NSObject{
    WTLine _la; //must be the rear and the top point of axis
    WTLine _lb;
    GLfloat *_radius;
    GLfloat _height;
    int _radiusCount;
    //above is given, bellow is calculated
    WTPlane _planeB;
    float _distance;
    GLKVector3 _nearestPoint;
}
//line b is considered to be the target line where nearest point is on
-(id)init:(WTLine)la :(WTLine)lb;
//init
-(float)getDistance;
//return the distance
-(GLKVector3)getNearestPoint;
//return the nearest point (deprecated)
-(GLKVector3)calPointOnPlane:(GLKVector3)pointP
                            :(GLKVector3)normalP
                            :(GLKVector3)pointL
                            :(GLKVector3)normalL;
//calculate the intersect point of plane and line
-(BOOL)isVertical:(GLKVector3)v1
                 :(GLKVector3)v2;
-(BOOL)isVertical;
//test whether parallel or not
-(float)distance:(GLKVector3)pa
                :(GLKVector3)pb;
//calculate distance
-(void)setRadius:(GLfloat *) radius :(int) radiusCount;
-(void)setHeight:(GLfloat)height;
@end
