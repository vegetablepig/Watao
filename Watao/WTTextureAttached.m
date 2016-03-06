//
//  WTTextureAttaced.m
//  Watao
//
//  Created by 连 承亮 on 14-5-12.
//  Copyright (c) 2014年 连 承亮. All rights reserved.
//

#import "WTTextureAttached.h"

@implementation WTTextureAttached

@synthesize order;
@synthesize bottom;
@synthesize height;
@synthesize name;

-(id)init:(int)o :(float)b :(float)h :(NSString*)n{
    if(self = [super init]){
        order = o;
        bottom = b;
        height = h;
        name = n;
    }
    return self;
}

-(id)init:(float)b :(float)h :(NSString*)n{
    if(self = [super init]){
        bottom = b;
        height = h;
        name = n;
    }
    return self;
}

@end
