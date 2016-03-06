//
//  WTTextureList.h
//  Watao
//
//  Created by 连 承亮 on 14-5-12.
//  Copyright (c) 2014年 连 承亮. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WTTextureAttached.h"

@interface WTTextureList : NSObject

@property (nonatomic) float topHeight;
@property (nonatomic,strong) NSMutableArray* list;

-(id)init: (float) t;
-(void)dealloc;

-(void)addTexture:(WTTextureAttached*)texture;
-(void)deleteTexture:(WTTextureAttached*)texture;
-(void)newaddTexture:(WTTextureAttached *)texture;
-(BOOL)couldAddTexture:(WTTextureAttached*)texture;
-(int)texturenumber;


@end
