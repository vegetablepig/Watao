//
//  WTViewController.h
//  Watao
//
//  Created by 连 承亮 on 14-2-27.
//  Copyright (c) 2014年 连 承亮. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GLKit/GLKit.h>
#import "WTPottery.h"
#import "WTPad.h"
#import "WTBackground.h"
#import "WTShadow.h"
#import "WTUtility.h"
#import <CoreMotion/CoreMotion.h>
#import "WTAppDelegate.h"
#import <OpenGLES/ES2/glext.h>
#import <OpenGLES/ES2/gl.h>

/**
 * this class is the root class which contains the pottery 
 */
@interface WTPotteryViewController : GLKViewController {
    GLuint _program;
    GLuint _program1;
    float _rotation;
    float _rotationx;
    //WTAppDelegate *delegate;
    WTBottom *_bottom;
    WTPottery *_pottery;
    WTPad *_pad;
    WTBackground *_background;
    WTShadow *_shadow;
    GLKVector3 _scale;
    GLKVector3 _transition;
    GLKVector3 _gravity;
    GLKVector3 _viewPointNow;
    GLKVector3 _cameraDir;
    GLKVector3 _cameraPoint;
    //use the combination of gravity and changeNow to make animation
    GLKMatrix4 _modelViewMatrix;
    GLKMatrix4 _viewTransformMatrix;
    //transform the model world according to gravity
    GLKVector4 _ambientColor;
    GLKVector4 _specularColor;
    GLKVector4 _diffuseColor;
    GLKVector4 _ambientColor1;
    GLKVector4 _specularColor1;
    GLKVector4 _diffuseColor1;
    GLKVector4 _ambientColorm;
    GLKVector4 _specularColorm;
    GLKVector4 _diffuseColorm;
    GLKVector4 one;
    GLKVector4 zero;
    //backgroundcolor;
    GLKVector4 _bambientColor;
    GLKVector4 _bspecularColor;
    GLKVector4 _bdiffuseColor;
    GLKVector4 _bambientColorm;
    GLKVector4 _bspecularColorm;
    GLKVector4 _bdiffuseColorm;
    //color of light
    float _perspective;
    float _rotationRate;
    GLuint _textureSlot;
    
    GLuint t1,t2,t3, t4;
    
}
@property (strong, nonatomic) EAGLContext *context;//strong before
@property (strong, nonatomic) GLKBaseEffect *effect;//strong before
@property (strong, nonatomic) CMMotionManager *motionManager;//strong before
@property (nonatomic) bool isGravityTurnedOn;
@property (nonatomic) GLuint texcube;
@property (nonatomic) bool flashflag;
//handle the accelerator
//@property (strong, nonatomic) IBOutlet UILabel *accX;
//@property (strong, nonatomic) IBOutlet UILabel *accY;
//label to test the accelorator

- (void)glkView:(GLKView *)view drawInRect:(CGRect)rect;
-(void)drawObeject:(WTMeshObject *)object
                  :(GLint)vertexArrayID;
//draw in rect
-(void)update;
- (void)setupGL;
-(void)setupGLfor: (GLint)vertexArrayID
                 :(GLint)vertexBufferID
                 :(GLint)indexBufferID
                 :(WTMeshObject *)object;
-(void) setupPottery;
- (void)tearDownGL;

- (UIImage *)resizeImage:(UIImage *)image toSize:(CGSize)reSize;
- (GLuint) CreateSimpleTextureCubemap;
- (BOOL)loadShaders;
- (BOOL)compileShader:(GLuint *)shader type:(GLenum)type file:(NSString *)file;
- (BOOL)linkProgram:(GLuint)prog;
- (BOOL)validateProgram:(GLuint)prog;

//important getter
-(GLKVector3) getTransition;
//return the transition of basic model view matrix
//-(GLKVector3)convertScreenToWorld:(CGPoint)pScreen
//                      Perspective: (float)perspective
//                          Pottery: (WTPottery *)pottery
//                          Positon: (GLKVector3)potteryPositon
//                           Camera:(GLKVector3) cameraPoint
//                        CameraDir:(GLKVector3) cameraDir
//                         distance:(float *)distance;
//an improved method, decide whether the point is in the body at the same time
//return whether the point is within the bounding box
-(bool)findLevelSelected:(CGPoint)pScreen
             Perspective: (float)perspective
                 Pottery: (WTPottery *)pottery
                  Camera:(GLKVector3) cameraPoint
            TouchedLevel:(int *)level;
-(void)viewWillDisappear:(BOOL)animated;
//close accelerometer when view disappear
-(void)calViewpointChange;
//change viewPort
@end


/**
 * a protocol declares a method to handle "shape" gesture
 */
@protocol ShapePotteryDelegate <NSObject>

@required
-(IBAction)shape:(UIPanGestureRecognizer*)paramSender;

@end

/**
 * a protocol declares some method to add textue
 */
@protocol TexturePotteryDelegate <NSObject>

@required
-(IBAction)attachTex:(UIPanGestureRecognizer*)paramSender;

@end

/**
 *
 * a protocol declares some method that check view must implement
 */
@protocol CheckPotteryDelegate <NSObject>

@required
-(IBAction)changeViewPoint:(UIPanGestureRecognizer*)paramSender;

@end

#define BUFFER_OFFSET(i) ((char *)NULL + (i))

// Uniform index.
enum
{
    UNIFORM_MODELVIEWPROJECTION_MATRIX,
    UNIFORM_NORMAL_MATRIX,
    UNIFORM_HEIGHT,
    UNIFORM_RADIUS,
    UNIFORM_TEXTURE,
    UNIFORM_EYEPOINT,
    UNIFORM_AMBIENT_COLOR,
    UNIFORM_SPECULAR_COLOR,
    UNIFORM_DIFFUSE_COLOR,
    UNIFORM_AMBIENT_COLOR1,
    UNIFORM_SPECULAR_COLOR1,
    UNIFORM_DIFFUSE_COLOR1,
    UNIFORM_AMBIENT_COLORM,
    UNIFORM_SPECULAR_COLORM,
    UNIFORM_DIFFUSE_COLORM,
    UNIFORM_CUBE,
    UNIFORM_FLAG,
    UNIFORM_FCUBE,
    UNIFORM_TEXTURE_IN,
    NUM_UNIFORMS,
};
GLint uniforms[NUM_UNIFORMS];

// Attribute index.
enum
{
    ATTRIB_VERTEX,
    ATTRIB_NORMAL,
    ATTRIB_TEXTURE,
    NUM_ATTRIBUTES
};

enum{
    VERTEX_ARRAY_POTTERY,
    VERTEX_ARRAY_PAD,
    VERTEX_ARRAY_BACKGROUND,
    VERTEX_ARRAY_SHADOW,
    NUM_VERTEX_ARRAY
};
GLuint vertexArraies[NUM_VERTEX_ARRAY];
//define the vertex array

enum{
    VERTEX_BUFFER_POTTERY,
    VERTEX_BUFFER_PAD,
    VERTEX_BUFFER_BACKGROUND,
    VERTEX_BUFFER_SHADOW,
    NUM_VERTEX_BUFFER
};
GLuint vertexBuffers[NUM_VERTEX_BUFFER];
//define the vertex buffer

enum{
    INDEX_BUFFER_POTTERY,
    INDEX_BUFFER_PAD,
    INDEX_BUFFER_BACKGROUND,
    INDEX_BUFFER_SHADOW,
    NUM_INDEX_BUFFER
};
GLuint indexBuffers[NUM_INDEX_BUFFER];
//define the index buffer


