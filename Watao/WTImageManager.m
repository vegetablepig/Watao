//
//  WTImageManager.m
//  Watao
//
//  Created by 连 承亮 on 14-5-1.
//  Copyright (c) 2014年 连 承亮. All rights reserved.
//

#import "WTImageManager.h"

@implementation WTImageManager
@synthesize imgTable;
@synthesize qinhuaTextureCount;
@synthesize yanseTextureCount;

-(id)init{
    if (self = [super init]) {
        unsigned int qhCapacity = WT_QINHUA_CAPACITY;
        unsigned int ysCapacity = WT_YANSE_CAPACITY;
        //imgTable = [[NSMutableDictionary alloc]init];
        qinhuaTextureCount = [[NSMutableArray alloc] initWithCapacity:qhCapacity];
        yanseTextureCount = [[NSMutableArray alloc] initWithCapacity:ysCapacity];
        for (int i = 0; i < 3; i++) {
            [qinhuaTextureCount setObject:[NSNumber numberWithInt:0] atIndexedSubscript:i];
            [yanseTextureCount setObject:[NSNumber numberWithInt:0] atIndexedSubscript:i];
        }
        //initial the array
    }
    return self;
}

-(void)dealloc{
    qinhuaTextureCount = nil;
    yanseTextureCount = nil;
}

//load all image from path
-(void)loadAllImgFromPath:(NSString *)path{
    path = [[[NSBundle mainBundle] resourcePath]
                               stringByAppendingPathComponent:path];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error = nil;
    NSArray *fileList = [[NSArray alloc] init];
    //fileList便是包含有该文件夹下所有文件的文件名及文件夹名的数组
    fileList = [fileManager contentsOfDirectoryAtPath:path error:&error];
    NSLog(@"路径==%@,fileList%@",path,fileList);
    for (NSString *name in fileList){
        NSString *exter = [name pathExtension];
        if ([exter isEqualToString:@"png"] || [exter isEqualToString:@"jpg"]) {
            //indcate that it is a picture
            //UIImage *spriteImage = [UIImage imageNamed:name];
            //[imgTable setObject:spriteImage forKey:name];
            //calculate the count of each image
            NSString *fName = [name lastPathComponent];
            fName = [fName stringByDeletingPathExtension];
            NSArray *split = [fName componentsSeparatedByString:@"_"];
            if (split.count == 2 || split.count ==3){
//                for (NSString *i in split) {
//                    NSLog(@"%@",i);
//                }
//                NSLog(@"%@",split);
                //must be composed with 3 parts
                NSInteger i2 = [[split objectAtIndex:1] integerValue];
                NSInteger i3;
                if(split.count ==3) i3 = [[split objectAtIndex:2] intValue];
                /*if ([[split objectAtIndex:0] isEqualToString:@"qc"] || [[split objectAtIndex:0] isEqualToString:@"qd"] || [[split objectAtIndex:0] isEqualToString:@"qg"]) {
                    NSNumber* c;
                    if([[split objectAtIndex:0] isEqualToString:@"qg"] && split.count == 2){
                        c = [qinhuaTextureCount objectAtIndex:0];
                        [qinhuaTextureCount setObject:[NSNumber numberWithInt:(c.intValue+1)] atIndexedSubscript:0];
                    }
                    if([[split objectAtIndex:0] isEqualToString:@"qd"] && split.count == 2){
                        c = [qinhuaTextureCount objectAtIndex:1];
                        [qinhuaTextureCount setObject:[NSNumber numberWithInt:(c.intValue+1)] atIndexedSubscript:1];
                    }
                    if([[split objectAtIndex:0] isEqualToString:@"qc"] && split.count == 2){
                        c = [qinhuaTextureCount objectAtIndex:2];
                        [qinhuaTextureCount setObject:[NSNumber numberWithInt:(c.intValue+1)] atIndexedSubscript:2];
                    }
                    /*if (i2 >= 0 && i2 < WT_QINHUA_CAPACITY && i3 >= 0){
                        //fixme should be more precise 
                        NSNumber* c = [qinhuaTextureCount objectAtIndex:i2];
                        [qinhuaTextureCount setObject:[NSNumber numberWithInt:(c.intValue+1)] atIndexedSubscript:i2];
                    }*/
                //}else
    
                    if ([[split objectAtIndex:0] isEqualToString:@"c"] || [[split objectAtIndex:0] isEqualToString:@"d"] || [[split objectAtIndex:0] isEqualToString:@"g"]) {
                    NSNumber* c;
                    if([[split objectAtIndex:0] isEqualToString:@"c"]){
                        c = [yanseTextureCount objectAtIndex:0];
                        [yanseTextureCount setObject:[NSNumber numberWithInt:(c.intValue+1)] atIndexedSubscript:0];
                    }
                    if([[split objectAtIndex:0] isEqualToString:@"d"]){
                        c = [yanseTextureCount objectAtIndex:1];
                        [yanseTextureCount setObject:[NSNumber numberWithInt:(c.intValue+1)] atIndexedSubscript:1];
                    }
                    if([[split objectAtIndex:0] isEqualToString:@"g"]){
                        c = [yanseTextureCount objectAtIndex:2];
                        [yanseTextureCount setObject:[NSNumber numberWithInt:(c.intValue+1)] atIndexedSubscript:2];
                    }
                    /*if (i2 >= 0 && i2 < WT_YANSE_CAPACITY && i3 >= 0){
                        //fixme should be more precise
                        NSNumber* c = [yanseTextureCount objectAtIndex:i2];
                        [yanseTextureCount setObject:[NSNumber numberWithInt:(c.intValue+1)] atIndexedSubscript:i2];
                    }*/
                }
            }
        }
    }
    for (int i = 0; i < 3; i++)
    {
    NSNumber* c = [qinhuaTextureCount objectAtIndex:i];
    [qinhuaTextureCount setObject:[NSNumber numberWithInt:(c.intValue-1)] atIndexedSubscript:i];
    }
    NSLog(@"qinhua %@", qinhuaTextureCount);
    NSLog(@"yanse %@", yanseTextureCount);
}

-(int)getQinhuaTypeCount{
    return WT_QINHUA_CAPACITY;
}

-(int)getYanseTypeCount{
    return WT_YANSE_CAPACITY;
}

-(UIImage *)getUIimg:(NSString *)name{
    /*
    NSString *path = [[[NSBundle mainBundle] resourcePath]
            stringByAppendingPathComponent:@""];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error = nil;
    NSArray *fileList = [[NSArray alloc] init];
    //fileList便是包含有该文件夹下所有文件的文件名及文件夹名的数组
    fileList = [fileManager contentsOfDirectoryAtPath:path error:&error];
    //NSLog(@"路径==%@,fileList%@",path,fileList);
    UIImage *spriteImage;
    NSLog(@"path:%@ name:%@", path, name);
    NSString *test = [[NSBundle mainBundle] pathForResource:@"clay" ofType:@"png"];
    //if ([fileList indexOfObject:name] != NSNotFound){
        NSString *exter = [name pathExtension];
        if ([exter isEqualToString:@"png"] || [exter isEqualToString:@"jpg"]) {
            //indcate that it is a picture
            spriteImage = [UIImage imageNamed:name];
    
        }
    return spriteImage;*/
    //if ([imgTable objectForKey:name] != nil)
    {
        NSString *path = @"";
        path = [[[NSBundle mainBundle] resourcePath]
             stringByAppendingPathComponent:name];
        NSFileManager *fileManager = [NSFileManager defaultManager];
        NSError *error = nil;
        NSArray *fileList = [[NSArray alloc] init];
        //fileList便是包含有该文件夹下所有文件的文件名及文件夹名的数组
        fileList = [fileManager contentsOfDirectoryAtPath:path error:&error];
        //NSLog(@"路径==%@,fileList%@ name:%@",path,fileList, name);
        UIImage *spriteImage = [UIImage imageWithContentsOfFile:path];
                return spriteImage;
        }
       //return  [imgTable objectForKey:name];
}

- (UIImage *)resizeImage:(UIImage *)image toSize:(CGSize)reSize
{
    UIGraphicsBeginImageContext(CGSizeMake(reSize.width, reSize.height));
    [image drawInRect:CGRectMake(0, 0, reSize.width, reSize.height)];
    UIImage *resizeImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return resizeImage;
}

@end
