//
//  WTTexutureManager.m
//  Watao
//
//  Created by 连 承亮 on 14-4-18.
//  Copyright (c) 2014年 连 承亮. All rights reserved.
//

#import "WTTexutureManager.h"
#import "WTAppDelegate.h"
#import "WTTextureAttached.h"

@implementation WTTexutureManager

//@synthesize textureID;
@synthesize imgData;
@synthesize imgDataBackUp;
@synthesize imgDataBackUp2;
@synthesize imgDataBackUp3;
@synthesize tHeight;
@synthesize tWidth;
@synthesize texList;
@synthesize pflag;
@synthesize whitetext2;
@synthesize bottomz;
@synthesize zipai;
@synthesize whitetext;
@synthesize testImage;

-(id) init:(NSString *)basicImage{
    if ((self = [super init])!=nil) {
        //setup basic img
        [self setupBasicImg:basicImage];

        
//        UIImage *tmp = [self glToUIImage];
//        UIImageWriteToSavedPhotosAlbum( tmp, self, nil , nil );
//        tmp = nil;
//        NSString *imagePath = NSHomeDirectory();
//        imagePath = [imagePath stringByAppendingPathComponent:@"/Library/testResult.png"];
//        BOOL bSave = [self saveToDocument:tmp withFilePath:imagePath];
        texList = [[WTTextureList alloc] init:_height];
//        free(imgData);
        return self;
    }
    return nil;
}

-(void) setflag:(bool)flag{
    pflag = flag;
}

-(bool) getflag:(bool)flag{
    return pflag;
}


-(id)initFromFile: (NSString *)imageName{
    if ((self = [super init])!=nil) {
        //setup basic img
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        NSString *imgPath = [documentsDirectory stringByAppendingPathComponent:imageName];
        UIImage* tmp = [UIImage imageWithContentsOfFile:imgPath];
        [self setupBasicImgByImage:tmp];
        texList = [[WTTextureList alloc] init:_height];
        return self;
    }
    return nil;
}

//use this to save texture
-(void)saveTextureToFile:(NSString *)imageName{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *txtPath = [documentsDirectory stringByAppendingPathComponent:imageName];
    UIImage *tmp = [self glToUIImage];
    BOOL bsave = [self saveToDocument:tmp withFilePath:txtPath];
    if (!bsave) {
        NSLog(@"fail to save texture to file");
    }
//    UIImageWriteToSavedPhotosAlbum( tmp, self, nil , nil );
}

-(void)savescreenshoot:(UIImage *)image{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *txtPath = [documentsDirectory stringByAppendingPathComponent:@"collect1.png"];
    BOOL bsave = [self saveToDocument:image withFilePath:txtPath];
    if (!bsave) {
        NSLog(@"fail to save texture to file");
    }
    else{
        NSLog(@"sec to save texture to file: %@", txtPath);
    }
    //    UIImageWriteToSavedPhotosAlbum( tmp, self, nil , nil );
}

//set the height of back image texture
-(void)setImgParameterI: (UIImage *)image{
    WTAppDelegate *delegate = [[UIApplication sharedApplication] delegate];
    tHeight = 3.0f/8.0/[delegate.pottery getHeight]*WT_TEXTURE_HEIGHT;
    tWidth =tHeight * CGImageGetWidth(image.CGImage) / CGImageGetHeight(image.CGImage);
    NSLog(@"h:%d w:%d", tHeight, tWidth);
}

-(void)setImgParameter: (NSString *)image{
//    UIImage *spriteImage = [UIImage imageNamed:image];
    WTAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    UIImage *spriteImage = [appDelegate.imageManager getUIimg:image];
    if (!spriteImage) {
        NSLog(@"Failed to load image %@", image);
        exit(1);
    }
    WTAppDelegate *delegate = [[UIApplication sharedApplication] delegate];
    tHeight = CGImageGetHeight(spriteImage.CGImage)/400.0/[delegate.pottery getHeight]*WT_TEXTURE_HEIGHT;///CGImageGetHeight(spriteImage.CGImage);没用了！
    tWidth = CGImageGetWidth(spriteImage.CGImage)/CGImageGetHeight(spriteImage.CGImage)*tHeight;

     //NSLog(@"pheight:%f heigth:%f", [delegate.pottery getHeight], h);
//    tHeight = WT_TEXTURE_REAL_HEIGHT;
}

-(void)setupBasicImgByImage:(UIImage *)spriteImage{ // not lea!k
    if (!spriteImage) {
        NSLog(@"Failed to load image %@", spriteImage);
        exit(1);
    }
    
    
    
    _width = (size_t)WT_TEXTURE_WIDTH;
    _height = (size_t)WT_TEXTURE_HEIGHT;
    //scale image
    spriteImage = [self resizeImage:spriteImage toSize:CGSizeMake((CGFloat)_width, (CGFloat)_height)];
    //change the color space of  the img to RGB
    CGImageRef imgRef;
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    imgRef = CGImageCreateCopyWithColorSpace(spriteImage.CGImage, colorSpace);
    spriteImage = nil;
    //create the basic image of the texture
    
    imgData = (GLubyte *) calloc(_width*_height*4, sizeof(GLubyte));
    imgDataBackUp = (GLubyte *) calloc(_width*_height*4, sizeof(GLubyte));
    NSLog(@"!!!!!!!!!!!!calloc!!!!!!!!!!!");
    imgDataBackUp2 = (GLubyte *) calloc(_width*_height*4, sizeof(GLubyte));
    imgDataBackUp3 = (GLubyte *) calloc(_width*_height*4, sizeof(GLubyte));
    CGContextRef spriteContext = CGBitmapContextCreate(imgData, _width, _height, 8, _width*4,colorSpace, kCGImageAlphaPremultipliedLast);
    CGContextDrawImage(spriteContext, CGRectMake(0, 0, _width, _height), imgRef);
    CGContextRelease(spriteContext);
    CGColorSpaceRelease(colorSpace);//**//
    CGImageRelease(imgRef);
}


-(UIImage*) test{
    return testImage;
}


-(void)setupBasicImg:(NSString *)basicImage{
//    UIImage *spriteImage = [UIImage imageNamed:basicImage];
    WTAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    UIImage *spriteImage = [appDelegate.imageManager getUIimg:basicImage];
    [self setupBasicImgByImage:spriteImage];
}

-(void)addTextureAndRecord:(float)bottom :(NSString *)imgName :(float)scale{
        //NSLog(@"bott: %f", bottom);
    //save the record of attatching texture operation
    bottom = bottom * _height;
    float height = tHeight;//*scale;
    //NSLog(@"height : %f, scale:%f", height, scale);
    WTTextureAttached *t = [[WTTextureAttached alloc] init: bottom :height: imgName];
    [texList newaddTexture:t];
    [self addTexture:bottom :imgName :scale];
}

-(void)deleteTexture:(float)bottom
                    :(NSString *)imgName
                    :(float)scale
{
    
    bottom = bottom * _height;
    float height = tHeight;//*scale;
    //NSLog(@"height : %f, scale:%f", height, scale);
    WTTextureAttached *t = [[WTTextureAttached alloc] init: bottom :height: imgName];
    [texList deleteTexture:t];
    [self addTexture:bottom :imgName :scale];
}

-(void)addTextureNo:(float)bottom :(NSString *)imgName :(float)scale{
    //NSLog(@"bott: %f", bottom);
    //save the record of attatching texture operation
    [self addTexture:bottom :imgName :scale];
}

-(int)texturenumber{
    return [texList texturenumber];
}

//could not be called outside selector
-(void) addTexturePhoto:(float)bottom :(UIImage*)img :(float)scale
{
    //[self addTexture:bottom :imgName :scale];
    //if (pflag == false){
    bottomz = bottom;
    zipai = img;
    [self restoreImgData];
    //save the record of attatching texture operation
    WTAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    for (int i = 0; i < texList.list.count ;i++) {
        WTTextureAttached *t = [texList.list objectAtIndex:i];
        NSString *imgName=t.name;
        bottom = t.bottom;
        float height = t.height;
        UIImage *spriteImage = [appDelegate.imageManager getUIimg:imgName];
        if (!spriteImage) {
            NSLog(@"Failed to load image %@", imgName);
            exit(1);
        }
        //restrore data from
        if(imgDataBackUp == nil){
            return;
        }
        //flip image because of inverse coordination
        UIImage* flippedImage = [UIImage imageWithCGImage:spriteImage.CGImage
                                                    scale:spriteImage.scale orientation: UIImageOrientationDownMirrored];
        //scale image
        WTAppDelegate *delegate = [[UIApplication sharedApplication] delegate];
        //float height = tHeight;//flippedImage.size.height/50.0/8.0/[delegate.pottery getHeight]*WT_TEXTURE_HEIGHT;//tHeight;//*scale;
        //NSLog(@"!!!!%f %f", flippedImage.size.height/50.0, height);
        //float width = tWidth*scale;
        //NSLog(@"fl:width:%f heigth:%f scale:%f", flippedImage.size.width, flippedImage.size.height, scale);
        //WTAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
        float heightp = [delegate.pottery getHeight] * 8;
        float radiusp = radiusp = [delegate.pottery getRadius:(int)((bottom*2.0+(float)height)/WT_TEXTURE_HEIGHT*25.0)] * 8*M_PI*2;
        
        flippedImage = [flippedImage resizableImageWithCapInsets:UIEdgeInsetsMake(0.0, 0.0, 0.0, 0.0) resizingMode:UIImageResizingModeStretch];
        CGSize size;
        /*if (WT_TEXTURE_WIDTH/((CGFloat)flippedImage.size.width/flippedImage.size.height*height*heightp/radiusp) < 2) size =CGSizeMake((GLfloat)(WT_TEXTURE_WIDTH), (CGFloat)height);
         else size =CGSizeMake((GLfloat)(WT_TEXTURE_WIDTH/((int)(WT_TEXTURE_WIDTH/((CGFloat)flippedImage.size.width/flippedImage.size.height*height*radiusp/heightp)))), (CGFloat)height);
         */
        size = CGSizeMake(((CGFloat)WT_TEXTURE_WIDTH/(int)(radiusp/(heightp/(WT_TEXTURE_HEIGHT / height)*flippedImage.size.width / flippedImage.size.height))), (CGFloat) height);
        flippedImage = [self resizeImage:flippedImage toSize:size];//*//_width instead
        //NSLog(@"asd: %d, sad %f",(int)(WT_TEXTURE_WIDTH/((CGFloat)flippedImage.size.width/flippedImage.size.height*height*heightp/radiusp)), (GLfloat)(WT_TEXTURE_WIDTH/((int)WT_TEXTURE_WIDTH/((CGFloat)flippedImage.size.width/flippedImage.size.height*height*heightp/radiusp))));
        //(CGFloat)flippedImage.size.width/flippedImage.size.height*height*heightp/radiusp ==> width
        //NSLog(@"fl1:width:%f heigth:%f", flippedImage.size.width, flippedImage.size.height);
        //[flippedImage drawAsPatternInRect:CGRectMake(0, 0, (CGFloat)_width, (CGFloat)height)];
        //CGSize cgsize1 = CGSizeMake((CGFloat)_width, (CGFloat)height);
        //flippedImage = [self OriginImage:flippedImage scaleToSize:cgsize1];
        flippedImage = [flippedImage resizableImageWithCapInsets:UIEdgeInsetsMake(0.0, 0.0, 0.0, 0.0) resizingMode:UIImageResizingModeTile];
        
        spriteImage = [self resizeImage:flippedImage toSize:CGSizeMake((CGFloat)_width, (CGFloat)height)];//*//_width instead
        //NSLog(@"sp:width:%f heigth:%f", spriteImage.size.width, spriteImage.size.height);
        
        testImage = flippedImage;
        //change the color space of  the img to RGB
        CGImageRef imgRef;
        CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
        imgRef = CGImageCreateCopyWithColorSpace(spriteImage.CGImage, colorSpace);
        spriteImage = nil;
        flippedImage = nil;
        CGContextRef spriteContext = CGBitmapContextCreate(imgData, _width, _height, 8, _width*4, colorSpace, kCGImageAlphaPremultipliedLast);
        CGContextDrawImage(spriteContext, CGRectMake(0, _height - height - bottom, _width, height), imgRef);//_width instead
        CGContextRelease(spriteContext);
        CGColorSpaceRelease(colorSpace);//**//
        CGImageRelease(imgRef);
    }

    bottom = bottomz * _height;
    //    UIImage *spriteImage = [UIImage imageNamed:imgName];
    //WTAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    UIImage *spriteImage = img;
    //restrore data from
    if(imgDataBackUp == nil){
        return;
    }

    //flip image because of inverse coordination
    UIImage* flippedImage = [UIImage imageWithCGImage:spriteImage.CGImage
                                                scale:spriteImage.scale orientation: UIImageOrientationDownMirrored];//up?
    //scale image
    //float height = tHeight*scale;
    //float width = tWidth*scale;
    float height;
    float width;
    height = 3.0f/8.0f/[appDelegate.pottery getHeight]*WT_TEXTURE_HEIGHT;
    width = height / tHeight * tWidth/2;
    //NSLog(@"width:%f heigth:%f scale:%f", width, height, scale);
    spriteImage = [self resizeImage:flippedImage toSize:CGSizeMake((CGFloat)width, (CGFloat)height)];//*//_width instead
    //change the color space of  the img to RGB
    CGImageRef imgRef;
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    imgRef = CGImageCreateCopyWithColorSpace(spriteImage.CGImage, colorSpace);
    spriteImage = nil;
    flippedImage = nil;
    CGContextRef spriteContext = CGBitmapContextCreate(imgData, _width, _height, 8, _width*4, colorSpace, kCGImageAlphaPremultipliedLast);
    CGContextDrawImage(spriteContext, CGRectMake(0, _height - height - bottom, width, height), imgRef);//_width instead
    CGContextRelease(spriteContext);
    CGColorSpaceRelease(colorSpace);//**//
    CGImageRelease(imgRef);
    //WTTextureAttached *t = [[WTTextureAttached alloc] init: bottom :height];
    //[texList addTexture:t];
    [self setflag:true];
    //}
}


-(void)addTexture:(float)bottom :(NSString *)img :(float)scale{
    bottom = bottom * _height;
    [self restoreImgData];
//    UIImage *spriteImage = [UIImage imageNamed:imgName];

    WTAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    /*NSLog(@"=========");
    for (int i = 0; i < texList.list.count ;i++) {
        WTTextureAttached *t = [texList.list objectAtIndex:i];
        NSLog(@"index:%d, %d, %f, %f, %@",i, t.order,t.bottom,t.height, t.name);
    }
    NSLog(@"=========");*/
    for (int i = 0; i < texList.list.count ;i++) {
        WTTextureAttached *t = [texList.list objectAtIndex:i];
        NSString *imgName=t.name;
        bottom = t.bottom;
        float height = t.height;
    UIImage *spriteImage = [appDelegate.imageManager getUIimg:imgName];
    if (!spriteImage) {
        NSLog(@"Failed to load image %@", imgName);
        exit(1);
    }
    //restrore data from
    if(imgDataBackUp == nil){
        return;
    }
    //flip image because of inverse coordination
    UIImage* flippedImage = [UIImage imageWithCGImage:spriteImage.CGImage
                                                scale:spriteImage.scale orientation: UIImageOrientationDownMirrored];
    //scale image
    WTAppDelegate *delegate = [[UIApplication sharedApplication] delegate];
    //float height = tHeight;//flippedImage.size.height/50.0/8.0/[delegate.pottery getHeight]*WT_TEXTURE_HEIGHT;//tHeight;//*scale;
    //NSLog(@"!!!!%f %f", flippedImage.size.height/50.0, height);
    //float width = tWidth*scale;
    //NSLog(@"fl:width:%f heigth:%f scale:%f", flippedImage.size.width, flippedImage.size.height, scale);
    //WTAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    float heightp = [delegate.pottery getHeight] * 8;
    float radiusp = [delegate.pottery getRadius:(int)((bottom*2.0+(float)height)/WT_TEXTURE_HEIGHT*25.0)] * 8*M_PI*2;
    
    flippedImage = [flippedImage resizableImageWithCapInsets:UIEdgeInsetsMake(0.0, 0.0, 0.0, 0.0) resizingMode:UIImageResizingModeStretch];
    CGSize size;
    /*if (WT_TEXTURE_WIDTH/((CGFloat)flippedImage.size.width/flippedImage.size.height*height*heightp/radiusp) < 2) size =CGSizeMake((GLfloat)(WT_TEXTURE_WIDTH), (CGFloat)height);
        else size =CGSizeMake((GLfloat)(WT_TEXTURE_WIDTH/((int)(WT_TEXTURE_WIDTH/((CGFloat)flippedImage.size.width/flippedImage.size.height*height*radiusp/heightp)))), (CGFloat)height);
     */
    size = CGSizeMake(((CGFloat)WT_TEXTURE_WIDTH/(int)(radiusp/(heightp/(WT_TEXTURE_HEIGHT / height)*flippedImage.size.width / flippedImage.size.height))), (CGFloat) height);
    flippedImage = [self resizeImage:flippedImage toSize:size];//*//_width instead
    //NSLog(@"asd: %d, sad %f",(int)(WT_TEXTURE_WIDTH/((CGFloat)flippedImage.size.width/flippedImage.size.height*height*heightp/radiusp)), (GLfloat)(WT_TEXTURE_WIDTH/((int)WT_TEXTURE_WIDTH/((CGFloat)flippedImage.size.width/flippedImage.size.height*height*heightp/radiusp))));
    //(CGFloat)flippedImage.size.width/flippedImage.size.height*height*heightp/radiusp ==> width
    //NSLog(@"fl1:width:%f heigth:%f", flippedImage.size.width, flippedImage.size.height);
    //[flippedImage drawAsPatternInRect:CGRectMake(0, 0, (CGFloat)_width, (CGFloat)height)];
    //CGSize cgsize1 = CGSizeMake((CGFloat)_width, (CGFloat)height);
    //flippedImage = [self OriginImage:flippedImage scaleToSize:cgsize1];
    flippedImage = [flippedImage resizableImageWithCapInsets:UIEdgeInsetsMake(0.0, 0.0, 0.0, 0.0) resizingMode:UIImageResizingModeTile];
    
    spriteImage = [self resizeImage:flippedImage toSize:CGSizeMake((CGFloat)_width, (CGFloat)height)];//*//_width instead
    //NSLog(@"sp:width:%f heigth:%f", spriteImage.size.width, spriteImage.size.height);
    
    testImage = flippedImage;
    //change the color space of  the img to RGB
    CGImageRef imgRef;
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    imgRef = CGImageCreateCopyWithColorSpace(spriteImage.CGImage, colorSpace);
    spriteImage = nil;
    flippedImage = nil;
    CGContextRef spriteContext = CGBitmapContextCreate(imgData, _width, _height, 8, _width*4, colorSpace, kCGImageAlphaPremultipliedLast);
    CGContextDrawImage(spriteContext, CGRectMake(0, _height - height - bottom, _width, height), imgRef);//_width instead
    CGContextRelease(spriteContext);
    CGColorSpaceRelease(colorSpace);//**//
    CGImageRelease(imgRef);
    }
    
    if (pflag == true)
    {
        //save the record of attatching texture operation
        WTAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
               
        bottom = bottomz * _height;
        //    UIImage *spriteImage = [UIImage imageNamed:imgName];
        //WTAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
        UIImage *spriteImage = zipai;
        //restrore data from
        if(imgDataBackUp == nil){
            return;
        }
        
        //flip image because of inverse coordination
        UIImage* flippedImage = [UIImage imageWithCGImage:spriteImage.CGImage
                                                    scale:spriteImage.scale orientation: UIImageOrientationDownMirrored];//up?
        //scale image
        //float height = tHeight*scale;
        //float width = tWidth*scale;
        float height;
        float width;
        height = 3.0f/8.0f/[appDelegate.pottery getHeight]*WT_TEXTURE_HEIGHT;
        width = height * CGImageGetWidth(zipai.CGImage) / CGImageGetHeight(zipai.CGImage)/2;
        //NSLog(@"width:%f heigth:%f scale:%f", width, height, scale);
        spriteImage = [self resizeImage:flippedImage toSize:CGSizeMake((CGFloat)width, (CGFloat)height)];//*//_width instead
        //change the color space of  the img to RGB
        CGImageRef imgRef;
        CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
        imgRef = CGImageCreateCopyWithColorSpace(spriteImage.CGImage, colorSpace);
        spriteImage = nil;
        flippedImage = nil;
        CGContextRef spriteContext = CGBitmapContextCreate(imgData, _width, _height, 8, _width*4, colorSpace, kCGImageAlphaPremultipliedLast);
        CGContextDrawImage(spriteContext, CGRectMake(0, _height - height - bottom, width, height), imgRef);//_width instead
        CGContextRelease(spriteContext);
        CGColorSpaceRelease(colorSpace);//**//
        CGImageRelease(imgRef);
    }
    
}

-(void)newWhiteImg:(NSString *)imgName :(NSString *)imgName2:(float)scale{
    WTAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    float heightp = [appDelegate.pottery getHeight] * 8;
    float radiusp = [appDelegate.pottery getMaxRadius] * 8*M_PI*2;
    float height = tHeight;
        UIImage *spriteImage = [appDelegate.imageManager getUIimg:imgName];
        if (!spriteImage) {
            NSLog(@"Failed to load image %@", imgName);
            exit(1);
        }
        UIImage* flippedImage = [UIImage imageWithCGImage:spriteImage.CGImage
                                                    scale:spriteImage.scale orientation: UIImageOrientationDownMirrored];
        flippedImage = [flippedImage resizableImageWithCapInsets:UIEdgeInsetsMake(0.0, 0.0, 0.0, 0.0) resizingMode:UIImageResizingModeStretch];
        CGSize size;
        /*if (WT_TEXTURE_WIDTH/((CGFloat)flippedImage.size.width/flippedImage.size.height*height*heightp/radiusp) < 2) size =CGSizeMake((GLfloat)(WT_TEXTURE_WIDTH), (CGFloat)height);
         else size =CGSizeMake((GLfloat)(WT_TEXTURE_WIDTH/((int)(WT_TEXTURE_WIDTH/((CGFloat)flippedImage.size.width/flippedImage.size.height*height*radiusp/heightp)))), (CGFloat)height);
         */
        size = CGSizeMake(((CGFloat)WT_TEXTURE_WIDTH/(int)(radiusp/(heightp/(WT_TEXTURE_HEIGHT / height)*flippedImage.size.width / flippedImage.size.height))), (CGFloat) height);
        flippedImage = [self resizeImage:flippedImage toSize:size];//*//_width instead
        //NSLog(@"asd: %d, sad %f",(int)(WT_TEXTURE_WIDTH/((CGFloat)flippedImage.size.width/flippedImage.size.height*height*heightp/radiusp)), (GLfloat)(WT_TEXTURE_WIDTH/((int)WT_TEXTURE_WIDTH/((CGFloat)flippedImage.size.width/flippedImage.size.height*height*heightp/radiusp))));
        //(CGFloat)flippedImage.size.width/flippedImage.size.height*height*heightp/radiusp ==> width
        //NSLog(@"fl1:width:%f heigth:%f", flippedImage.size.width, flippedImage.size.height);
        //[flippedImage drawAsPatternInRect:CGRectMake(0, 0, (CGFloat)_width, (CGFloat)height)];
        //CGSize cgsize1 = CGSizeMake((CGFloat)_width, (CGFloat)height);
        //flippedImage = [self OriginImage:flippedImage scaleToSize:cgsize1];
        flippedImage = [flippedImage resizableImageWithCapInsets:UIEdgeInsetsMake(0.0, 0.0, 0.0, 0.0) resizingMode:UIImageResizingModeTile];
        
        spriteImage = [self resizeImage:flippedImage toSize:CGSizeMake((CGFloat)_width, (CGFloat)height)];//*//_width instead
        //NSLog(@"sp:width:%f heigth:%f", spriteImage.size.width, spriteImage.size.height);
        
        whitetext = spriteImage;
    spriteImage = [appDelegate.imageManager getUIimg:imgName2];
    if (!spriteImage) {
        NSLog(@"Failed to load image %@", imgName);
        exit(1);
    }
     flippedImage = [UIImage imageWithCGImage:spriteImage.CGImage
                                                scale:spriteImage.scale orientation: UIImageOrientationDownMirrored];
    flippedImage = [flippedImage resizableImageWithCapInsets:UIEdgeInsetsMake(0.0, 0.0, 0.0, 0.0) resizingMode:UIImageResizingModeStretch];
    /*if (WT_TEXTURE_WIDTH/((CGFloat)flippedImage.size.width/flippedImage.size.height*height*heightp/radiusp) < 2) size =CGSizeMake((GLfloat)(WT_TEXTURE_WIDTH), (CGFloat)height);
     else size =CGSizeMake((GLfloat)(WT_TEXTURE_WIDTH/((int)(WT_TEXTURE_WIDTH/((CGFloat)flippedImage.size.width/flippedImage.size.height*height*radiusp/heightp)))), (CGFloat)height);
     */
    size = CGSizeMake(((CGFloat)WT_TEXTURE_WIDTH/(int)(radiusp/(heightp/(WT_TEXTURE_HEIGHT / height)*flippedImage.size.width / flippedImage.size.height))), (CGFloat) height);
    flippedImage = [self resizeImage:flippedImage toSize:size];//*//_width instead
    //NSLog(@"asd: %d, sad %f",(int)(WT_TEXTURE_WIDTH/((CGFloat)flippedImage.size.width/flippedImage.size.height*height*heightp/radiusp)), (GLfloat)(WT_TEXTURE_WIDTH/((int)WT_TEXTURE_WIDTH/((CGFloat)flippedImage.size.width/flippedImage.size.height*height*heightp/radiusp))));
    //(CGFloat)flippedImage.size.width/flippedImage.size.height*height*heightp/radiusp ==> width
    //NSLog(@"fl1:width:%f heigth:%f", flippedImage.size.width, flippedImage.size.height);
    //[flippedImage drawAsPatternInRect:CGRectMake(0, 0, (CGFloat)_width, (CGFloat)height)];
    //CGSize cgsize1 = CGSizeMake((CGFloat)_width, (CGFloat)height);
    //flippedImage = [self OriginImage:flippedImage scaleToSize:cgsize1];
    flippedImage = [flippedImage resizableImageWithCapInsets:UIEdgeInsetsMake(0.0, 0.0, 0.0, 0.0) resizingMode:UIImageResizingModeTile];
    
    spriteImage = [self resizeImage:flippedImage toSize:CGSizeMake((CGFloat)_width, (CGFloat)height)];//*//_width instead
    //NSLog(@"sp:width:%f heigth:%f", spriteImage.size.width, spriteImage.size.height);
    
    whitetext2 = spriteImage;
    
        flippedImage = nil;
    spriteImage = nil;

}


-(void)addTexturewhite:(float)bottom :(NSString *)imgName :(float)scale{
    bottom = bottom * _height;
    //    UIImage *spriteImage = [UIImage imageNamed:imgName];
    WTAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    
    //restrore data from
    if(imgDataBackUp2 == nil){
        return;
    }
    [self restoreImgData2];
    //scale image
    WTAppDelegate *delegate = [[UIApplication sharedApplication] delegate];
    float height = tHeight;//flippedImage.size.height/50.0/8.0/[delegate.pottery getHeight]*WT_TEXTURE_HEIGHT;//tHeight;//*scale;
    //NSLog(@"!!!!%f %f", flippedImage.size.height/50.0, height);
    //float width = tWidth*scale;
    //NSLog(@"fl:width:%f heigth:%f scale:%f", flippedImage.size.width, flippedImage.size.height, scale);
    //WTAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    float heightp = [appDelegate.pottery getHeight] * 8;
    float radiusp = [appDelegate.pottery getMaxRadius] * 8*M_PI*2;
    //flip image because of inverse coordination
    UIImage *spriteImage;
    /*if (testImage == nil)
    {
    UIImage *spriteImage = [appDelegate.imageManager getUIimg:imgName];
    if (!spriteImage) {
        NSLog(@"Failed to load image %@", imgName);
        exit(1);
    }
    UIImage* flippedImage = [UIImage imageWithCGImage:spriteImage.CGImage
                                                scale:spriteImage.scale orientation: UIImageOrientationDownMirrored];
    flippedImage = [flippedImage resizableImageWithCapInsets:UIEdgeInsetsMake(0.0, 0.0, 0.0, 0.0) resizingMode:UIImageResizingModeStretch];
    CGSize size;

    size = CGSizeMake(((CGFloat)WT_TEXTURE_WIDTH/(int)(radiusp/(heightp/(WT_TEXTURE_HEIGHT / height)*flippedImage.size.width / flippedImage.size.height))), (CGFloat) height);
    flippedImage = [self resizeImage:flippedImage toSize:size];//_width instead
    //NSLog(@"asd: %d, sad %f",(int)(WT_TEXTURE_WIDTH/((CGFloat)flippedImage.size.width/flippedImage.size.height*height*heightp/radiusp)), (GLfloat)(WT_TEXTURE_WIDTH/((int)WT_TEXTURE_WIDTH/((CGFloat)flippedImage.size.width/flippedImage.size.height*height*heightp/radiusp))));
    //(CGFloat)flippedImage.size.width/flippedImage.size.height*height*heightp/radiusp ==> width
    //NSLog(@"fl1:width:%f heigth:%f", flippedImage.size.width, flippedImage.size.height);
    //[flippedImage drawAsPatternInRect:CGRectMake(0, 0, (CGFloat)_width, (CGFloat)height)];
    //CGSize cgsize1 = CGSizeMake((CGFloat)_width, (CGFloat)height);
    //flippedImage = [self OriginImage:flippedImage scaleToSize:cgsize1];
    flippedImage = [flippedImage resizableImageWithCapInsets:UIEdgeInsetsMake(0.0, 0.0, 0.0, 0.0) resizingMode:UIImageResizingModeTile];
    
    spriteImage = [self resizeImage:flippedImage toSize:CGSizeMake((CGFloat)_width, (CGFloat)height)];//_width instead
    //NSLog(@"sp:width:%f heigth:%f", spriteImage.size.width, spriteImage.size.height);
    
    testImage = spriteImage;
        flippedImage = nil;
    }
    else {
        spriteImage = testImage;
    }*/
    spriteImage = whitetext;
    //change the color space of  the img to RGB
    CGImageRef imgRef;
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    imgRef = CGImageCreateCopyWithColorSpace(spriteImage.CGImage, colorSpace);
    spriteImage = nil;
    //
    NSLog(@"_height: %zu  height: %f   bottom: %f", _height,height,bottom);
    CGContextRef spriteContext = CGBitmapContextCreate(imgData, _width, _height, 8, _width*4, colorSpace, kCGImageAlphaPremultipliedLast);
    CGContextDrawImage(spriteContext, CGRectMake(0, _height - height - bottom, _width, height), imgRef);//_width instead
    CGContextRelease(spriteContext);
    CGColorSpaceRelease(colorSpace);//**//
    CGImageRelease(imgRef);
    
}

-(void)addTexturewhitenew:(float)bottom :(NSString *)imgName :(float)scale:(int) num{
    bottom = bottom * _height;
    //    UIImage *spriteImage = [UIImage imageNamed:imgName];
    WTAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    
    //restrore data from
    if(imgDataBackUp2 == nil){
        return;
    }
    [self restoreImgData2];
    //scale image
    WTAppDelegate *delegate = [[UIApplication sharedApplication] delegate];
    float height = tHeight;//flippedImage.size.height/50.0/8.0/[delegate.pottery getHeight]*WT_TEXTURE_HEIGHT;//tHeight;//*scale;
    //NSLog(@"!!!!%f %f", flippedImage.size.height/50.0, height);
    //float width = tWidth*scale;
    //NSLog(@"fl:width:%f heigth:%f scale:%f", flippedImage.size.width, flippedImage.size.height, scale);
    //WTAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    float heightp = [appDelegate.pottery getHeight] * 8;
    float radiusp = [appDelegate.pottery getMaxRadius] * 8*M_PI*2;
    //flip image because of inverse coordination
    UIImage *spriteImage;
    /*if (testImage == nil)
     {
     UIImage *spriteImage = [appDelegate.imageManager getUIimg:imgName];
     if (!spriteImage) {
     NSLog(@"Failed to load image %@", imgName);
     exit(1);
     }
     UIImage* flippedImage = [UIImage imageWithCGImage:spriteImage.CGImage
     scale:spriteImage.scale orientation: UIImageOrientationDownMirrored];
     flippedImage = [flippedImage resizableImageWithCapInsets:UIEdgeInsetsMake(0.0, 0.0, 0.0, 0.0) resizingMode:UIImageResizingModeStretch];
     CGSize size;
     
     size = CGSizeMake(((CGFloat)WT_TEXTURE_WIDTH/(int)(radiusp/(heightp/(WT_TEXTURE_HEIGHT / height)*flippedImage.size.width / flippedImage.size.height))), (CGFloat) height);
     flippedImage = [self resizeImage:flippedImage toSize:size];//_width instead
     //NSLog(@"asd: %d, sad %f",(int)(WT_TEXTURE_WIDTH/((CGFloat)flippedImage.size.width/flippedImage.size.height*height*heightp/radiusp)), (GLfloat)(WT_TEXTURE_WIDTH/((int)WT_TEXTURE_WIDTH/((CGFloat)flippedImage.size.width/flippedImage.size.height*height*heightp/radiusp))));
     //(CGFloat)flippedImage.size.width/flippedImage.size.height*height*heightp/radiusp ==> width
     //NSLog(@"fl1:width:%f heigth:%f", flippedImage.size.width, flippedImage.size.height);
     //[flippedImage drawAsPatternInRect:CGRectMake(0, 0, (CGFloat)_width, (CGFloat)height)];
     //CGSize cgsize1 = CGSizeMake((CGFloat)_width, (CGFloat)height);
     //flippedImage = [self OriginImage:flippedImage scaleToSize:cgsize1];
     flippedImage = [flippedImage resizableImageWithCapInsets:UIEdgeInsetsMake(0.0, 0.0, 0.0, 0.0) resizingMode:UIImageResizingModeTile];
     
     spriteImage = [self resizeImage:flippedImage toSize:CGSizeMake((CGFloat)_width, (CGFloat)height)];//_width instead
     //NSLog(@"sp:width:%f heigth:%f", spriteImage.size.width, spriteImage.size.height);
     
     testImage = spriteImage;
     flippedImage = nil;
     }
     else {
     spriteImage = testImage;
     }*/
    if(num == 0)spriteImage = whitetext; else spriteImage = whitetext2;
    //change the color space of  the img to RGB
    CGImageRef imgRef;
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    imgRef = CGImageCreateCopyWithColorSpace(spriteImage.CGImage, colorSpace);
    spriteImage = nil;
    //
    CGContextRef spriteContext = CGBitmapContextCreate(imgData, _width, _height, 8, _width*4, colorSpace, kCGImageAlphaPremultipliedLast);
    CGContextDrawImage(spriteContext, CGRectMake(0, _height - height - bottom, _width, height), imgRef);//_width instead
    CGContextRelease(spriteContext);
    CGColorSpaceRelease(colorSpace);//**//
    CGImageRelease(imgRef);
    
}



-(UIImage*) OriginImage:(UIImage *)image scaleToSize:(CGSize)size
{
    UIGraphicsBeginImageContext(size);  //size 为CGSize类型，即你所需要的图片尺寸
    
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return scaledImage;   //返回的就是已经改变的图片
}

-(BOOL)couldAddTexture:(float)bottom :(float)scale{
    bottom = bottom * _height;
    float height = tHeight;//*scale;
    //NSLog(@"height: %f",height);
    if (pflag == true) height = 180;
    WTTextureAttached *t = [[WTTextureAttached alloc] init: bottom :height: @"white"];
    return [texList couldAddTexture:t];
}


//add a white texture
-(void)addWhiteTexture:(float)bottom :(NSString *)imgName :(float)scale{
    [self addTexturewhite:bottom :imgName :scale];
}


//clear texture
-(void)clearTexture:(NSString *)imgName{
    //    UIImage *spriteImage = [UIImage imageNamed:imgName];
    WTAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    UIImage *spriteImage = [self addImage:[appDelegate.imageManager getUIimg:imgName]toImage:[appDelegate.imageManager getUIimg:imgName]];
    if (!spriteImage) {
        NSLog(@"Failed to load image %@", imgName);
        exit(1);
    }
    //flip image because of inverse coordination
    UIImage* flippedImage = [UIImage imageWithCGImage:spriteImage.CGImage
                                                scale:spriteImage.scale orientation: UIImageOrientationUpMirrored];
    //scale image
    float height = _height;
    spriteImage = [self resizeImage:flippedImage toSize:CGSizeMake((CGFloat)_width, (CGFloat)height)];
    //change the color space of  the img to RGB
    CGImageRef imgRef;
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    imgRef = CGImageCreateCopyWithColorSpace(spriteImage.CGImage, colorSpace);
    spriteImage = nil;
    flippedImage = nil;
    CGContextRef spriteContext = CGBitmapContextCreate(imgData, _width, _height, 8, _width*4, colorSpace, kCGImageAlphaPremultipliedLast);
    CGContextDrawImage(spriteContext, CGRectMake(0, 0, _width, height), imgRef);
    CGContextRelease(spriteContext);
    CGColorSpaceRelease(colorSpace);//**//
    CGImageRelease(imgRef);
    //clear the list of texture
    //[texList.list removeAllObjects];
}



-(void)restoreImgData{
    long size = _width*_height*4;
    memcpy(imgData, imgDataBackUp, size);
}

-(void)restoreImgData2{
    long size = _width*_height*4;
    memcpy(imgData, imgDataBackUp2, size);
}


-(void)backupImgData{
    long size = _width*_height*4;
    //imgDataBackUp = (GLubyte *) calloc(_width*_height*4, sizeof(GLubyte));
    memcpy(imgDataBackUp, imgData, size);
}

-(void)backupImgData2{
    long size = _width*_height*4;
    //imgDataBackUp = (GLubyte *) calloc(_width*_height*4, sizeof(GLubyte));
    memcpy(imgDataBackUp2, imgData, size);
}

-(void)backupImgData3{
    long size = _width*_height*4;
    //imgDataBackUp = (GLubyte *) calloc(_width*_height*4, sizeof(GLubyte));
    memcpy(imgDataBackUp3, imgData, size);
}

-(void)freeBackupData{
    //free(imgDataBackUp);
}

/**
 * 
 */
- (GLuint)setupTexture:(NSString *)fileName {
    // 1
//    CGImageRef spriteImage = [UIImage imageNamed:fileName].CGImage;
    WTAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    UIImage *image = [appDelegate.imageManager getUIimg: fileName];//**
    image = [image resizableImageWithCapInsets:UIEdgeInsetsZero resizingMode:UIImageResizingModeTile];
    CGImageRef spriteImage = image.CGImage;
    if (!spriteImage) {
        NSLog(@"Failed to load image %@", fileName);
        exit(1);
    }     // 2
    size_t width = CGImageGetWidth(spriteImage);
    size_t height = CGImageGetHeight(spriteImage);
    GLubyte * spriteData = (GLubyte *) calloc(width*height*4, sizeof(GLubyte));
    CGContextRef spriteContext = CGBitmapContextCreate(spriteData, width, height, 8, width*4,CGImageGetColorSpace(spriteImage), kCGImageAlphaPremultipliedLast);         // 3
    CGContextDrawImage(spriteContext, CGRectMake(0, 0, width, height), spriteImage);
    CGContextRelease(spriteContext);     // 4
    GLuint texName;
    glGenTextures(1, &texName);
    glBindTexture(GL_TEXTURE_2D, texName);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_NEAREST);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_NEAREST);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_CLAMP_TO_EDGE);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_CLAMP_TO_EDGE);
    //glTexParameteri(GL_TEXTURE_2D, GL_GENERATE_MIPMAP, GL_TRUE);
    glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA, width, height, 0, GL_RGBA, GL_UNSIGNED_BYTE, spriteData);
    
    free(spriteData);
    CGImageRelease(spriteImage);//NEW YEAR
    return texName;
    
}


- (UIImage *)resizeImage:(UIImage *)image toSize:(CGSize)reSize
{
    UIGraphicsBeginImageContext(CGSizeMake(reSize.width, reSize.height));
    [image drawInRect:CGRectMake(0, 0, reSize.width, reSize.height)];
    UIImage *resizeImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return resizeImage;
}

/*- (UIImage *)test1{
    CGDataProviderRef ref = CGDataProviderCreateWithData(NULL, imgData, _width*_height*4, NULL);
    CGColorSpaceRef colorspace = CGColorSpaceCreateDeviceRGB();
    CGImageRef iref = CGImageCreate(_width, _height, 8, 32, _width * 4, colorspace, kCGBitmapByteOrder32Big | kCGImageAlphaPremultipliedLast,
                                    
                                    ref, NULL, true, kCGRenderingIntentDefault);
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    return img;
}*/


-(void)genTexture :(GLuint *)textureID{
    glGenTextures(1, textureID);
}


- (GLuint)convertToTexturenew:(GLuint)textureID{
    NSLog(@"leak?");
    
    if (textureID <= 0) {
        [self genTexture:&textureID];
        NSLog(@"unavailable texture ID");
    }
    /*UIImage *spriteImage1 = [self addImage:[self glToUIImage] toImage: [self glToUIImage3]];
    if (!spriteImage1) {
        NSLog(@"Failed to load image ");
        exit(1);
    }     // 2
    
    UIImage *reimage = [self resizeImage:spriteImage1 toSize:CGSizeMake((CGFloat)80, (CGFloat)60)];
    
    CGImageRef spriteImage = reimage.CGImage;*/
    
    CGImageRef spriteImage =  [self addImage:[self glToUIImage] toImage: [self glToUIImage3]].CGImage;
    
    size_t width = CGImageGetWidth(spriteImage);
    size_t height = CGImageGetHeight(spriteImage);
    
    NSLog(@"width : %lu, height : %lu", width, height);
    
    GLubyte * spriteData = (GLubyte *) calloc(width*height*4, sizeof(GLubyte));
    CGContextRef spriteContext = CGBitmapContextCreate(spriteData, width, height, 8, width*4,CGImageGetColorSpace(spriteImage), kCGImageAlphaPremultipliedLast);         // 3
    CGContextDrawImage(spriteContext, CGRectMake(0, 0, width, height), spriteImage);
    CGContextRelease(spriteContext);     // 4
    
    //GLuint texName;
    //glGenTextures(1, &texName); new year
    glBindTexture(GL_TEXTURE_2D, textureID);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_NEAREST);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_NEAREST);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_CLAMP_TO_EDGE);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_CLAMP_TO_EDGE);
    //**//
    glTexParameteri(GL_TEXTURE_2D, GL_GENERATE_MIPMAP, GL_TRUE);
    glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA, width, height, 0, GL_RGBA, GL_UNSIGNED_BYTE, spriteData);
    
    free(spriteData);
    //CGImageRelease(spriteImage);//NEW YEAR
    return textureID;
}

/*- (GLuint)convertToTexturenew:(GLuint)textureID{
 NSLog(@"leak?");
 
 if (textureID <= 0) {
 [self genTexture:&textureID];
 NSLog(@"unavailable texture ID");
 }
 CGImageRef spriteImage = [self addImage:[self glToUIImage] toImage: [self glToUIImage3]].CGImage;
 if (!spriteImage) {
 NSLog(@"Failed to load image ");
 exit(1);
 }     // 2
 
 UIImage reimage = [self resizeImage:spriteImage toSize:CGSizeMake((CGFloat)_width, (CGFloat)_height)];
 
 size_t width = CGImageGetWidth(spriteImage);
 size_t height = CGImageGetHeight(spriteImage);
 
 NSLog(@"width : %lu, height : %lu", width, height);
 
 GLubyte * spriteData = (GLubyte *) calloc(width*height*4, sizeof(GLubyte));
 CGContextRef spriteContext = CGBitmapContextCreate(spriteData, width, height, 8, width*4,CGImageGetColorSpace(spriteImage), kCGImageAlphaPremultipliedLast);         // 3
 CGContextDrawImage(spriteContext, CGRectMake(0, 0, width, height), spriteImage);
 CGContextRelease(spriteContext);     // 4
 
 //GLuint texName;
 //glGenTextures(1, &texName); new year
 glBindTexture(GL_TEXTURE_2D, textureID);
 glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_NEAREST);
 glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_NEAREST);
 glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_CLAMP_TO_EDGE);
 glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_CLAMP_TO_EDGE);
glTexParameteri(GL_TEXTURE_2D, GL_GENERATE_MIPMAP, GL_TRUE);
glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA, width, height, 0, GL_RGBA, GL_UNSIGNED_BYTE, spriteData);

free(spriteData);
//CGImageRelease(spriteImage);//NEW YEAR
return textureID;
}
*/


- (GLuint)convertToTextureold:(GLuint)textureID{
    if (textureID <= 0) {
        [self genTexture:&textureID];
        NSLog(@"unavailable texture ID");
    }
    CGImageRef spriteImage = [self addImage:[self glToUIImage] toImage: [self glToUIImage3]].CGImage;
    if (!spriteImage) {
        NSLog(@"Failed to load image ");
        exit(1);
    }     // 2
    size_t width = CGImageGetWidth(spriteImage);
    size_t height = CGImageGetHeight(spriteImage);
    GLubyte * spriteData = (GLubyte *) calloc(width*height*4, sizeof(GLubyte));
    CGContextRef spriteContext = CGBitmapContextCreate(spriteData, width, height, 8, width*4,CGImageGetColorSpace(spriteImage), kCGImageAlphaPremultipliedLast);         // 3
    CGContextDrawImage(spriteContext, CGRectMake(0, 0, width, height), spriteImage);
    CGContextRelease(spriteContext);     // 4
    GLuint texName;
    glGenTextures(1, &texName);
    glBindTexture(GL_TEXTURE_2D, textureID);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_NEAREST);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_NEAREST);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_CLAMP_TO_EDGE);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_CLAMP_TO_EDGE);
    //**//glTexParameteri(GL_TEXTURE_2D, GL_GENERATE_MIPMAP, GL_TRUE);
    glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA, width, height, 0, GL_RGBA, GL_UNSIGNED_BYTE, spriteData);
    //CGImageRelease(spriteImage);//NEW YEAR
    free(spriteData);
    CGImageRelease(spriteImage);//NEW YEAR
    return textureID;
}


-(GLuint)convertToTexture :(GLuint)textureID{
 if (textureID <= 0) {
 [self genTexture:&textureID];
 NSLog(@"unavailable texture ID");
 }
 glBindTexture(GL_TEXTURE_2D, textureID);
 glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_NEAREST);
 glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_NEAREST);
 glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_CLAMP_TO_EDGE);
 glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_CLAMP_TO_EDGE);
 //glTexParameteri(GL_TEXTURE_2D, GL_GENERATE_MIPMAP, GL_TRUE);
 glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA, _width, _height, 0, GL_RGBA, GL_UNSIGNED_BYTE, imgData);
 return textureID;
}

- (UIImage *)addImage:(UIImage *)image1 toImage:(UIImage *)image2 {
    UIGraphicsBeginImageContext(CGSizeMake(image1.size.width*2, image1.size.height));
    
    // Draw image1
    [image1 drawInRect:CGRectMake(0, 0, image1.size.width, image1.size.height)];
    
    // Draw image2
    [image2 drawInRect:CGRectMake(image1.size.width, 0, image2.size.width, image2.size.height)];
    
    UIImage *resultingImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return resultingImage;
}

-(void)dealloc{
    texList = nil;
    free(imgData);
    free(imgDataBackUp);
    free(imgDataBackUp3);
    free(imgDataBackUp2);
}

//将选取的图片保存到目录文件夹下
-(BOOL)saveToDocument:(UIImage *) image withFilePath:(NSString *) filePath
{
    if ((image == nil) || (filePath == nil) || [filePath isEqualToString:@""]) {
        return NO;
    }
    
    @try {
        NSData *imageData = nil;
        //获取文件扩展名
        NSString *extention = [filePath pathExtension];
        if ([extention isEqualToString:@"png"]) {
            //返回PNG格式的图片数据
            imageData = UIImagePNGRepresentation(image);
        }else{
            //返回JPG格式的图片数据，第二个参数为压缩质量：0:best 1:lost
            imageData = UIImageJPEGRepresentation(image, 0);
        }
        if (imageData == nil || [imageData length] <= 0) {
            return NO;
        }
        //将图片写入指定路径
        [imageData writeToFile:filePath atomically:YES];
        return  YES;
    }
    @catch (NSException *exception) {
        NSLog(@"保存图片失败");
    }
    
    return NO;
    
}


//convert data from gluByte* to uiImage
-(UIImage *) glToUIImage {
    NSInteger myDataLength = _width * _height * 4;
    // make data provider with data.
    CGDataProviderRef provider = CGDataProviderCreateWithData(NULL, imgData, myDataLength, NULL);
    
    // prep the ingredients
    int bitsPerComponent = 8;
    int bitsPerPixel = 32;
    int bytesPerRow = 4 * _width;
    CGColorSpaceRef colorSpaceRef = CGColorSpaceCreateDeviceRGB();
    CGBitmapInfo bitmapInfo = kCGBitmapByteOrderDefault;
    CGColorRenderingIntent renderingIntent = kCGRenderingIntentDefault;
    
    // make the cgimage
    CGImageRef imageRef = CGImageCreate(_width, _height, bitsPerComponent, bitsPerPixel, bytesPerRow, colorSpaceRef, bitmapInfo, provider, NULL, NO, renderingIntent);
    CGDataProviderRelease(provider);
    // then make the uiimage from that
    UIImage *myImage = [UIImage imageWithCGImage:imageRef];
    CGImageRelease(imageRef);
    CGColorSpaceRelease(colorSpaceRef);//**//
    return myImage;
}

-(UIImage *) glToUIImage2 {
    NSInteger myDataLength = _width * _height * 4;
    // make data provider with data.
    CGDataProviderRef provider = CGDataProviderCreateWithData(NULL, imgDataBackUp2, myDataLength, NULL);
    
    // prep the ingredients
    int bitsPerComponent = 8;
    int bitsPerPixel = 32;
    int bytesPerRow = 4 * _width;
    CGColorSpaceRef colorSpaceRef = CGColorSpaceCreateDeviceRGB();
    CGBitmapInfo bitmapInfo = kCGBitmapByteOrderDefault;
    CGColorRenderingIntent renderingIntent = kCGRenderingIntentDefault;
    
    // make the cgimage
    CGImageRef imageRef = CGImageCreate(_width, _height, bitsPerComponent, bitsPerPixel, bytesPerRow, colorSpaceRef, bitmapInfo, provider, NULL, NO, renderingIntent);
    CGDataProviderRelease(provider);
    // then make the uiimage from that
    UIImage *myImage = [UIImage imageWithCGImage:imageRef];
    CGImageRelease(imageRef);
    CGColorSpaceRelease(colorSpaceRef);//**//
    return myImage;
}

-(UIImage *) glToUIImage3 {
    NSInteger myDataLength = _width * _height * 4;
    // make data provider with data.
    CGDataProviderRef provider = CGDataProviderCreateWithData(NULL, imgDataBackUp3, myDataLength, NULL);
    
    // prep the ingredients
    int bitsPerComponent = 8;
    int bitsPerPixel = 32;
    int bytesPerRow = 4 * _width;
    CGColorSpaceRef colorSpaceRef = CGColorSpaceCreateDeviceRGB();
    CGBitmapInfo bitmapInfo = kCGBitmapByteOrderDefault;
    CGColorRenderingIntent renderingIntent = kCGRenderingIntentDefault;
    
    // make the cgimage
    CGImageRef imageRef = CGImageCreate(_width, _height, bitsPerComponent, bitsPerPixel, bytesPerRow, colorSpaceRef, bitmapInfo, provider, NULL, NO, renderingIntent);
    CGDataProviderRelease(provider);
    // then make the uiimage from that
    UIImage *myImage = [UIImage imageWithCGImage:imageRef];
    CGImageRelease(imageRef);
    CGColorSpaceRelease(colorSpaceRef);//**//
    return myImage;
}

-(void)loadtexture{
    NSString *path = @"";
    
    NSLog(@"loadtexture");
    
    path = [[[NSBundle mainBundle] resourcePath]
            stringByAppendingPathComponent:@"procelainb.png"];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error = nil;
    NSArray *fileList = [[NSArray alloc] init];
    //fileList便是包含有该文件夹下所有文件的文件名及文件夹名的数组
    fileList = [fileManager contentsOfDirectoryAtPath:path error:&error];
    //NSLog(@"路径==%@,fileList%@ name:%@",path,fileList, name);
    UIImage *spriteImage = [UIImage imageWithContentsOfFile:path];
        _width = (size_t)WT_TEXTURE_WIDTH;
        _height = (size_t)WT_TEXTURE_HEIGHT;
        //scale image
        spriteImage = [self resizeImage:spriteImage toSize:CGSizeMake((CGFloat)_width, (CGFloat)_height)];
        //change the color space of  the img to RGB
        CGImageRef imgRef;
        CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
        imgRef = CGImageCreateCopyWithColorSpace(spriteImage.CGImage, colorSpace);
        spriteImage = nil;
        //create the basic image of the texture
        CGContextRef spriteContext = CGBitmapContextCreate(imgDataBackUp3, _width, _height, 8, _width*4,colorSpace, kCGImageAlphaPremultipliedLast);
        CGContextDrawImage(spriteContext, CGRectMake(0, 0, _width, _height), imgRef);
        CGContextRelease(spriteContext);
        CGColorSpaceRelease(colorSpace);//**//
        CGImageRelease(imgRef);
    }

@end
