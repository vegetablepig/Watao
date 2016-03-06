//
//  WTTextureAttaced.h
//  Watao
//
//  Created by 连 承亮 on 14-5-12.
//  Copyright (c) 2014年 连 承亮. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WTTextureAttached : NSObject
-(id)init:(int)o :(float)b :(float)h :(NSString*)n;
-(id)init:(float)b :(float)h :(NSString*)n;

@property (nonatomic) float bottom;
@property (nonatomic) float height;
@property (nonatomic) int order;
@property (nonatomic) NSString *name;

@end
