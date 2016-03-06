//
//  WTPotteryData.m
//  Watao
//
//  Created by 连 承亮 on 14-5-8.
//  Copyright (c) 2014年 连 承亮. All rights reserved.
//

//save the pottery to file and recover from it
#import "WTPotteryData.h"

@implementation WTPotteryData

@synthesize  thickness;
@synthesize  radius;
@synthesize  randSet;
//
@synthesize  maxHeight;
@synthesize  minHeight;
@synthesize  maxRadius;
@synthesize  minRadius;
@synthesize  height;
@synthesize  maxRadiusNow;

-(id)init:(NSString *)name{
    if (self = [super init]) {
        _fileName = name;
    }
    return self;
}


- (void) encodeWithCoder:(NSCoder *)encoder {
    [encoder encodeObject:thickness forKey:@"thickness"];
    [encoder encodeObject:radius forKey:@"radius"];
    [encoder encodeObject:randSet forKey:@"initRandSet"];
    //
    [encoder encodeObject:maxHeight forKey:@"maxHeight"];
    [encoder encodeObject:minHeight forKey:@"minHeight"];
    [encoder encodeObject:maxRadius forKey:@"maxRadius"];
    [encoder encodeObject:minRadius forKey:@"minRadius"];
    [encoder encodeObject:height forKey:@"height"];
    [encoder encodeObject:maxRadiusNow forKey:@"maxRadiusNow"];
    
}

- (id)initWithCoder:(NSCoder *)decoder {
    thickness = [decoder decodeObjectForKey:@"thickness"];
    radius = [decoder decodeObjectForKey:@"radius"];
    randSet = [decoder decodeObjectForKey:@"initRandSet"];
    //
    maxHeight = [decoder decodeObjectForKey:@"maxHeight"];
    minHeight = [decoder decodeObjectForKey:@"minHeight"];
    maxRadius = [decoder decodeObjectForKey:@"maxRadius"];
    minRadius = [decoder decodeObjectForKey:@"minRadius"];
    height = [decoder decodeObjectForKey:@"height"];
    maxRadiusNow = [decoder decodeObjectForKey:@"maxRadiusNow"];
    return self;
}

@end
