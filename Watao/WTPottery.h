//
//  WTPottery.h
//  Watao
//
//  Created by 连 承亮 on 14-2-28.
//  Copyright (c) 2014年 连 承亮. All rights reserved.
//

#ifndef Watao_WTPottery_h
#define Watao_WTPottery_h

#import <UIKit/UIKit.h>
#import <GLKit/GLKit.h>
#import <Foundation/Foundation.h>
#import <math.h>
#import "WTMeshObject.h"
#import "WTPotteryData.h"
#import "WTRuler.h"

#define WT_NUM_LEVEL 50
#define WT_NUM_VERTEX 81
#define WT_TOUCH_RIM_WIDTH 0.3
#define WT_TOUCH_RIM_HEIGHT 0.9

typedef struct{
    float maxHeight;
    float minHeight;
    float maxRadius;
    float minRadius;
    float height;
    float maxRadiusNow;//define the radius now
}BoundingBox;


@interface WTPottery : WTMeshObject <WTRuler>{
    float _thickness;
    float _scale;
    //indicate the position of each vertex with two levels
    GLfloat _radius[WT_NUM_LEVEL];
    //define an array to store the index
    GLKVector4 _initRandSet[WT_NUM_LEVEL];
    //save the parameters of initial random at each level
    BoundingBox _boundingBox;
    //define the max possible radius and max possible height
}

@property (nonatomic,readonly) float initRadius;
@property (nonatomic) GLuint textureID;

-(id)WTPotteryIH:(float)initHeight IR:(float)initRadius MINH:(float)minHeight MINR:(float)minRadius MAXH:(float)maxHeight MAXR:(float)maxRadius TH:(float)thickness;
-(id)initFromPottery: (WTPottery *)p;
-(id)init;
-(void)setFromTxt:(NSString *)txtName; //set Config from file
//init the pottery
-(void)updateVertex:(int)level;
-(void)initIndex;
//compute update when changes
-(void)thinner:(int) level :(float)scale;
-(void)fatter:(int)level :(float)scale;
-(void)shorter:(int)level :(float)scale;
-(void)taller:(int)level :(float)scale;
-(float)gaussianDelta: (float) delta Mean: (float) mean X: (float) x;
//response the user actions
-(BoundingBox)getBoundingBox;
-(float)getThickness;
-(float)getHeight;
-(GLKVector4 *)getInitRandSet;
//important getters
-(BOOL)withinBoundingBox:(float)y
                        :(float)scale
                        :(float)distance;
//decide whether the finger is within range or not
-(float) justifyY: (float)y
                 : (float)scale;
//if y sits on the rim, then drag y within main body
-(GLfloat *)getRadius;
-(float)getRadius:(int) i;
-(float) getMaxRadius;
-(int)getRadiusCount;
//important getter
-(void)saveToFile: (NSString *)fileName;
-(void)loadFromFile: (NSString*)fileName;
//save to file and read from it
-(void)scale:(float)s;
-(void)dealloc;
//- (id)copyWithZone:(NSZone *)zone;

@end


#endif
