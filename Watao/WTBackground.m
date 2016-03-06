//
//  WTBackground.m
//  Watao
//
//  Created by 连 承亮 on 14-4-9.
//  Copyright (c) 2014年 连 承亮. All rights reserved.
//

#import "WTBackground.h"
#import "WTAppDelegate.h"

@implementation WTBackground
//@synthesize textureID;
-(id)init{
    if (self = [super init]) {
        _BCx = -5.0f;//-10
        _BCy = -15.0f;
        _BCheight = 30.0f;
        _BCwidth = 10.0f;
        [self initVertex];
    }
    return self;
}

-(id)initWithSize:(float)x
                 :(float)y
                 :(float)w
                 :(float)h{
    if (self = [super init]) {
        _BCx = x;
        _BCy = y;
        _BCheight = h;
        _BCwidth = w;
        [self initVertex];
    }
    return self;
}

-(void)initVertex{
    _vertexCount = 4;
    _indexCount = 4;
    _vertices = (Vertex *)malloc(sizeof(Vertex)*_vertexCount);
    _indices = (GLushort *)malloc(sizeof(GLushort)*_indexCount);
    //init background with constant
    _vertices[0].coord = GLKVector4Make(_BCx+_BCwidth,_BCy,-20.0f,1.0);
    _vertices[0].normal = GLKVector4Make(0.0,0.0,0.0,1.0);
//    _vertices[0].textureCoords = GLKVector4Make(0,0,1,1);
    _vertices[0].textureCoords = GLKVector2Make(1,1);
    
    _vertices[1].coord = GLKVector4Make(_BCx+_BCwidth,_BCy+_BCheight,-20.0f,1.0);
    _vertices[1].normal = GLKVector4Make(0.0,0.0,0.0,1.0);
//    _vertices[1].textureCoords = GLKVector4Make(1,0,1,1);
    _vertices[1].textureCoords = GLKVector2Make(1,0);
    
    _vertices[2].coord = GLKVector4Make(_BCx,_BCy+_BCheight,-20.0f,1.0);
    _vertices[2].normal = GLKVector4Make(0.0,0.0,0.0,1.0);
//    _vertices[2].textureCoords = GLKVector4Make(1,1,1,1);
    _vertices[2].textureCoords = GLKVector2Make(0,0);
    
    _vertices[3].coord = GLKVector4Make(_BCx,_BCy,-20.0f,1.0);
    _vertices[3].normal = GLKVector4Make(0.0,0.0,0.0,1.0);
//    _vertices[3].textureCoords = GLKVector4Make(0,1,1,1);
    _vertices[3].textureCoords = GLKVector2Make(0,1);
    


    _indices[0] = (GLushort)1;
    _indices[1] = (GLushort)0;
    _indices[2] = (GLushort)2;
    _indices[3] = (GLushort)3;
    
}
/*
- (GLuint)setupTexture:(NSString *)fileName {
    // 1
    //    CGImageRef spriteImage = [UIImage imageNamed:fileName].CGImage;
    WTAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    //UIImage *image = [appDelegate.imageManager getUIimg:fileName];
    CGImageRef spriteImage = [self resizeImage:[appDelegate.imageManager getUIimg:fileName] toSize:CGSizeMake((GLfloat)2048, (GLfloat)2048)].CGImage;
    if (!spriteImage) {
        NSLog(@"Failed to load image %@", fileName);
        exit(1);
    }     // 2
    size_t width = CGImageGetWidth(spriteImage);
    size_t height = CGImageGetHeight(spriteImage);
    NSLog(@"w: %zu, h: %zu", width, height);
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
    glTexParameteri(GL_TEXTURE_2D, GL_GENERATE_MIPMAP, GL_TRUE);
    glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA, width, height, 0, GL_RGBA, GL_UNSIGNED_BYTE, spriteData);
    
    free(spriteData);
    textureID = texName;
    return texName;
    
}
*/
- (UIImage *)resizeImage:(UIImage *)image toSize:(CGSize)reSize

{
    
    UIGraphicsBeginImageContext(CGSizeMake(reSize.width, reSize.height));
    
    [image drawInRect:CGRectMake(0, 0, reSize.width, reSize.height)];
    
    UIImage *resizeImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return resizeImage;
    
}
@end
