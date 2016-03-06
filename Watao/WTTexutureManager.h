//
//  WTTexutureManager.h
//  Watao
//
//  Created by 连 承亮 on 14-4-18.
//  Copyright (c) 2014年 连 承亮. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GLKit/GLKit.h>
#import "WTTextureList.h"

#define WT_TEXTURE_HEIGHT 600
#define WT_TEXTURE_WIDTH 800//6*8
#define WT_TEXTURE_REAL_HEIGHT 128


@interface WTTexutureManager : NSObject{
    size_t _width;
    size_t _height;
}

//@property (nonatomic) GLuint textureID;
@property (nonatomic) GLubyte *imgData;
@property (nonatomic) GLubyte *imgDataBackUp;
@property (nonatomic) GLubyte *imgDataBackUp2;
@property (nonatomic) GLubyte *imgDataBackUp3;
@property (nonatomic) GLuint tHeight;
@property (nonatomic) GLuint tWidth;
@property (nonatomic) bool pflag;
@property (nonatomic, strong) WTTextureList *texList;
@property (nonatomic) UIImage *whitetext2;
@property (nonatomic) UIImage *zipai;
@property (nonatomic) UIImage *whitetext;
@property (nonatomic) UIImage *testImage;
@property (nonatomic) float bottomz;

-(id) init:(NSString *)basicImage;
-(id)initFromFile: (NSString *)imageName;
-(void) addTexture:(float) bottom
                  :(NSString *)imgName
                  :(float)scale;
-(void) addWhiteTexture:(float)bottom
                       :(NSString *)imgName
                       :(float)scale;
-(void) addTexturewhite:(float)bottom
                       :(NSString *)imgName
                       :(float)scale;
-(void) addTexturewhitenew:(float)bottom
                       :(NSString *)imgName
                       :(float)scale
                       :(int) num;
-(void)addTextureAndRecord:(float)bottom
                          :(NSString *)imgName
                          :(float)scale;
-(void)addTextureNo:(float)bottom :(NSString *)imgName :(float)scale;
-(void) addTexturePhoto:(float)bottom :(UIImage*)img :(float)scale;
-(BOOL)couldAddTexture:(float)bottom :(float)scale;
-(void)deleteTexture:(float)bottom
                          :(NSString *)imgName
                          :(float)scale;
-(void)backupImgData;
-(void)backupImgData2;
-(void)backupImgData3;
-(void)restoreImgData;
-(void)restoreImgData2;
-(void)freeBackupData;
-(UIImage *)test1;
-(void)setflag:(bool)flag;
-(bool)getflag:(bool)flag;
-(void)genTexture :(GLuint *)textureID;
-(UIImage *) glToUIImage;
-(UIImage *) glToUIImage2;
-(UIImage *) glToUIImage3;
- (UIImage *)addImage:(UIImage *)image1 toImage:(UIImage *)image2;
/**
 * set up the image with proper height and width
 */
-(void) setupBasicImg: (NSString *)basicImage;
-(GLuint)setupTexture:(NSString *)fileName;
-(void) dealloc;
- (GLuint)convertToTexture :(GLuint)textureID;
- (GLuint)convertToTexturenew:(GLuint)textureID;
- (GLuint)convertToTextureold:(GLuint)textureID;
//set tHeight
-(void)setImgParameter: (NSString *)image;
-(void)setImgParameterI: (UIImage *)image;
-(void)clearTexture:(NSString *)imgName;
//save the texture to file
-(void)saveTextureToFile:(NSString *)imageName;
-(void)savescreenshoot:(UIImage *)image;
-(UIImage*) test;
-(int)texturenumber;
-(void)newWhiteImg:(NSString *)imgName :(NSString *)imgName2:(float)scale;
-(void)loadtexture;
@end
