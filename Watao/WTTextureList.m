//
//  WTTextureList.m
//  Watao
//
//  Created by 连 承亮 on 14-5-12.
//  Copyright (c) 2014年 连 承亮. All rights reserved.
//

#import "WTTextureList.h"

@implementation WTTextureList

@synthesize topHeight;
@synthesize list;
-(id)init: (float) t{
    if (self = [super init]) {
        list = [[NSMutableArray alloc] init];
        topHeight = t;
    }
    return self;
}

-(void)dealloc{
    list = nil;
}

-(void)addTexture:(WTTextureAttached *)texture{
    int shouldAddLlist = -1;
    for (int i = 0; i < list.count; i++) {
        WTTextureAttached* t = [list objectAtIndex:i];
        if (texture.bottom > t.bottom) {
            continue;
        }else{
            shouldAddLlist = i;
            break;
        }
    }
    texture.order = list.count;
    if (shouldAddLlist != -1) {
        [list insertObject:texture atIndex:shouldAddLlist];
    }else{
        [list insertObject:texture atIndex:list.count];
    }
    for (int i = 0; i < list.count ;i++) {
        WTTextureAttached *t = [list objectAtIndex:i];
        NSLog(@"index:%d, %d, %f, %f",i, t.order,t.bottom,t.height);
    }
    NSLog(@"!===!");
}

-(BOOL)couldAddTexture:(WTTextureAttached *)texture{
    int i = -1;
    for (WTTextureAttached *t in list) {
        i++;
        if (texture.bottom > t.bottom) {
            continue;
        }
        else{
            float top,root;
            top = ((WTTextureAttached *)[list objectAtIndex:i]).bottom;
            if (i == 0) {
                root = -1;
            }else{
                root = ((WTTextureAttached *)[list objectAtIndex:i-1]).bottom + ((WTTextureAttached *)[list objectAtIndex:i-1]).height;
            }
            if (texture.bottom + texture.height <= top  && texture.bottom >= root) {
                return true;
            }
            else{
                return false;
            }
        }
    }
    //at top
    float root = -1;
    if (list.count != 0) {
        root = ((WTTextureAttached *)[list objectAtIndex:list.count-1]).bottom + ((WTTextureAttached *)[list objectAtIndex:list.count-1]).height;
    }
    if (texture.bottom >= root && texture.bottom +texture.height <=2048) {
        return true;
    }else{
        return false;
    }
}

-(void)newaddTexture:(WTTextureAttached *)texture{
    int i = -1;
    int j = -1;
    int a[100];
    for (WTTextureAttached *t in list) {
        i++;
        if ((t.bottom >= texture.bottom && t.bottom <=texture.bottom+texture.height) ||
            (t.bottom +t.height >=texture.bottom && t.bottom+t.height <= texture.bottom+texture.height) ||
            (t.bottom <= texture.bottom && t.bottom+t.height >= texture.bottom+texture.height))
        {
            //[list removeObjectAtIndex:i];
            j++;
            a[j] = i;
        }
    }
    for (int i = j; i >= 0; i --)
    [list removeObjectAtIndex:a[i]];
    [self addTexture:texture];
     NSLog(@"!===!");
}

-(void)deleteTexture:(WTTextureAttached *)texture{
    int i = -1;
    int j = -1;
    int a[100];
    for (WTTextureAttached *t in list) {
        i++;
        if ((t.bottom >= texture.bottom && t.bottom <=texture.bottom+texture.height) ||
            (t.bottom +t.height >=texture.bottom && t.bottom+t.height <= texture.bottom+texture.height) ||
            (t.bottom <= texture.bottom && t.bottom+t.height >= texture.bottom+texture.height))
        {
            //[list removeObjectAtIndex:i];
            j++;
            a[j] = i;
        }
    }
    for (int i = j; i >= 0; i --)
        [list removeObjectAtIndex:a[i]];
}


-(int)texturenumber{
    return list.count;
}

@end
