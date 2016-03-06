//
//  WTImageManager.h
//  Watao
//
//  Created by 连 承亮 on 14-5-1.
//  Copyright (c) 2014年 连 承亮. All rights reserved.
//

#import <Foundation/Foundation.h>
//preload the image into the manager in order to promote efficiency
#define WT_QINHUA_CAPACITY 3
#define WT_YANSE_CAPACITY 4

@interface WTImageManager : NSObject

@property (nonatomic, strong) NSMutableDictionary  *imgTable;
@property (nonatomic, strong) NSMutableArray* qinhuaTextureCount;
@property (nonatomic, strong) NSMutableArray* yanseTextureCount;

-(void)loadAllImgFromPath:(NSString *)path;
-(id)init;
-(UIImage *)getUIimg:(NSString *)name;
-(int)getYanseTypeCount;
-(int)getQinhuaTypeCount;
+(UIImage *)resizeImage:(UIImage *)image toSize:(CGSize)reSize;

@end
