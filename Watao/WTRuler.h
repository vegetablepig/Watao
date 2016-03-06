//
//  WTRuler.h
//  Watao
//
//  Created by 连 承亮 on 14-5-13.
//  Copyright (c) 2014年 连 承亮. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WTPottery.h"
enum{
    WT_OPERATION_FATTER,
    WT_OPERATION_THINNER,
    WT_OPERATION_TALLER,
    WT_OPERATION_SHORTER
};


@protocol WTRuler <NSObject>
@property (nonatomic) float* backupRadius;
@property (nonatomic) float backupHeight;

-(BOOL)couldOperate:(int)operation
                   :(int)level
                   :(float)scale;


-(void)initBackupRadius;

-(void)freeBackupRadius;

@end 


