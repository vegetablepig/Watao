//
//  WTBackground.h
//  Watao
//
//  Created by 连 承亮 on 14-4-9.
//  Copyright (c) 2014年 连 承亮. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WTMeshObject.h"

@interface WTBackground : WTMeshObject{
    float _BCx;
    float _BCy;
    float _BCheight;
    float _BCwidth;
}

//@property (nonatomic) GLuint textureID;

-(id)init;
-(id)initWithSize:(float)x
                 :(float)y
                 :(float)w
                 :(float)h;
-(void)initVertex;

@end
