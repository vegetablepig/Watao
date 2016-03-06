//
//  WTPotteryData.h
//  Watao
//
//  Created by 连 承亮 on 14-5-8.
//  Copyright (c) 2014年 连 承亮. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WTPottery.h"



@interface WTPotteryData : NSObject<NSCoding>{
    NSString * _fileName;
}

@property (strong, nonatomic) NSNumber* thickness;
@property (strong, nonatomic) NSMutableArray* radius;
@property (strong, nonatomic) NSMutableArray* randSet;
//
@property (strong, nonatomic) NSNumber* maxHeight;
@property (strong, nonatomic) NSNumber* minHeight;
@property (strong, nonatomic) NSNumber* maxRadius;
@property (strong, nonatomic) NSNumber* minRadius;
@property (strong, nonatomic) NSNumber* height;
@property (strong, nonatomic) NSNumber* maxRadiusNow;

-(id)init:(NSString *)name;

@end
