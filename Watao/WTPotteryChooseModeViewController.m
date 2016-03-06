//
//  WTPotteryChooseModeViewController.m
//  Watao
//
//  Created by 连 承亮 on 14-5-9.
//  Copyright (c) 2014年 连 承亮. All rights reserved.
//
/*
#import "WTPotteryChooseModeViewController.h"
#import "WTTexutureManager.h"
//#import "UMSocial.h"
#import "WTAppDelegate.h"

@interface WTPotteryChooseModeViewController ()

@end

@implementation WTPotteryChooseModeViewController

@synthesize tIDQinhua;
@synthesize tIDYanse;
@synthesize matrixQ;
@synthesize matrixY;
@synthesize translationQ;
@synthesize translationY;
@synthesize backgroundY;
@synthesize bgYang;
@synthesize bgYin;
@synthesize initY;
@synthesize bBlackBackcolor;
@synthesize bWhiteBackcolor;
@synthesize bTransparentBackcolor;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    super.isGravityTurnedOn = false;
    [super viewDidLoad];
    float x = -10.0f;
    float y = -15.0f;
    float width = 10.0f;
    float height = 30.0f;
    backgroundY = 20.0f;
    initY = backgroundY;
    //set Yin Yang background
    bgYin = [[WTBackground alloc] initWithSize:x :y+backgroundY :width :height];
    bgYang = [[WTBackground alloc] initWithSize:x+width :y-backgroundY :width :height];
    //setup gl for two additional background, occupy the position of shadow and pad
    [self setupGLfor:VERTEX_ARRAY_PAD :VERTEX_BUFFER_PAD :INDEX_BUFFER_PAD :bgYang];
    [self setupGLfor:VERTEX_ARRAY_SHADOW :VERTEX_BUFFER_SHADOW :INDEX_BUFFER_SHADOW :bgYin];
    //set up the texture
//    WTTexutureManager *manager = [[WTTexutureManager alloc]init];
    WTAppDelegate *delegate = [[UIApplication sharedApplication] delegate];
    WTTexutureManager *manager = delegate.textureManager;
    [_background setupTexture:@"background_1.jpg"];
    tIDQinhua = [manager setupTexture:@"qinhuaSample.jpg"];
    tIDYanse = [manager setupTexture:@"yanseSample.jpg"];
    [bgYin setupTexture:@"bgYin.png"];
    [bgYang setupTexture:@"bgYang.png"];
    //
    float delta = 0.8f;
    _transition = GLKVector3Make(0.0f, -1.0f, -4.0f);
    translationQ = GLKVector3Make(delta, 0.0, 0.0);
    translationY = GLKVector3Make(-delta,0.0, 0.0);
    _scale = GLKVector3Make(0.5f, 0.5f, 0.5f);
    _rotationRate = 0.5f;
    //setup parameter of button
    bWhiteBackcolor.alpha = 0.0f;
    bBlackBackcolor.alpha = 0.0f;
    bTransparentBackcolor.alpha = 0.0f;
    bWhiteBackcolor.enabled = NO;
    bBlackBackcolor.enabled = NO;
    bTransparentBackcolor.enabled = NO;
}

- (void)update
{
    [super update];
    float aspect = fabsf(self.view.bounds.size.width / self.view.bounds.size.height);
    GLKMatrix4 projectionMatrix = GLKMatrix4MakePerspective(GLKMathDegreesToRadians(_perspective), aspect, 0.1f, 100.0f);
    GLKMatrix4 baseModelViewMatrix = GLKMatrix4MakeTranslation(_transition.x, _transition.y, _transition.z);
    //make model view matrix of Qinhua Pottery
    GLKVector3 translate = translationQ;
    GLKMatrix4 modelViewMatrix = GLKMatrix4MakeTranslation(translate.x, translate.y, translate.z);
    //at last tranlsate
    modelViewMatrix = GLKMatrix4RotateY(modelViewMatrix, _rotation);
    //then rotate
    modelViewMatrix = GLKMatrix4ScaleWithVector3(modelViewMatrix, _scale);
    //first scale
    modelViewMatrix = GLKMatrix4Multiply(baseModelViewMatrix, modelViewMatrix);
    //set to position in the scene
    matrixQ = GLKMatrix4Multiply(projectionMatrix, modelViewMatrix);
    
    //make model view matrix of Yanse Pottery
    translate = translationY;
    modelViewMatrix = GLKMatrix4MakeTranslation(translate.x, translate.y, translate.z);
    //at last tranlsate
    modelViewMatrix = GLKMatrix4RotateY(modelViewMatrix, _rotation);
    //then rotate
    modelViewMatrix = GLKMatrix4ScaleWithVector3(modelViewMatrix, _scale);
    //first scale
    modelViewMatrix = GLKMatrix4Multiply(baseModelViewMatrix, modelViewMatrix);
    //set to position in the scene
    matrixY = GLKMatrix4Multiply(projectionMatrix, modelViewMatrix);
    //update the background of Yin and Yang
    float deltaY = (initY - backgroundY)/1.67;
    translate = GLKVector3Make(0.0f, 1.0f - deltaY, 0.0f);
    [bgYin moveRotate:GLKMathDegreesToRadians(0.0f) scale:GLKVector3Make(0.6f, 0.6f, 0.5f) translate:translate base:baseModelViewMatrix project:projectionMatrix];
    translate = GLKVector3Make(0.0f, 1.0f + deltaY, 0.0f);
    [bgYang moveRotate:GLKMathDegreesToRadians(0.0f) scale:GLKVector3Make(0.6f, 0.6f, 0.5f) translate:translate base:baseModelViewMatrix project:projectionMatrix];
    _rotation += self.timeSinceLastUpdate * _rotationRate;
    //backGourndY;
    if (backgroundY > 0.0f) {
        backgroundY = backgroundY - 0.2;
        float delta = 0.02;
        bWhiteBackcolor.alpha += delta;
        bBlackBackcolor.alpha += delta;
        bTransparentBackcolor.alpha += delta;
    }else if(bWhiteBackcolor.enabled == NO){
        bWhiteBackcolor.enabled = YES;
        bBlackBackcolor.enabled = YES;
        bTransparentBackcolor.enabled = YES;
    }
    
}


- (void)glkView:(GLKView *)view drawInRect:(CGRect)rect
{
    glEnable(GL_BLEND);
    glBlendFunc(GL_ONE, GL_ONE_MINUS_SRC_ALPHA);
    //    glBlendFunc(GL_ONE, GL_ZERO);
    //    glBlendFunc(GL_ONE, GL_SRC_COLOR);
    glClearColor(1.0f, 1.0f, 1.0f, 1.0f);
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
    glUseProgram(_program);
//    [super glkView:view drawInRect:rect];
    //    ////////////////////////////////////////
    _pottery.textureID = tIDYanse;
//    ((WTMeshObject *)_pottery).setModelProjectionViewMatrix:matrixY;
    [_pottery setModelMatrix:matrixY];
    [self drawObeject:_pottery :VERTEX_ARRAY_POTTERY];
    //draw pYanse
    ////////////////////////////////////////
    _pottery.textureID = tIDQinhua;
    [_pottery setModelMatrix:matrixQ];
    [self drawObeject:_pottery :VERTEX_ARRAY_POTTERY];
    //draw pQinhua
    /////////////////////////////////////////
    [self drawObeject:_background :VERTEX_ARRAY_BACKGROUND];
    //draw background
    [self drawObeject:bgYang :VERTEX_ARRAY_PAD];
    //draw background yang
    [self drawObeject:bgYin :VERTEX_ARRAY_SHADOW];
    //draw background yin
}


//revise draw function
-(void)drawObeject:(WTMeshObject *)object
                  :(GLint)vertexArrayID{
    glBindVertexArrayOES(vertexArraies[vertexArrayID]);
    if (vertexArrayID == VERTEX_ARRAY_POTTERY){
        [self setupPottery];
    }
    glBindTexture(GL_TEXTURE_2D, [object textureID]);
    GLKMatrix4 modelm = object.getModelProjectionViewMatrix;
    GLKMatrix3 normalm = object.getNormalMatrix;
    
    glUniformMatrix4fv(uniforms[UNIFORM_MODELVIEWPROJECTION_MATRIX], 1, 0, modelm.m);//object.getModelProjectionViewMatrix.m);
    glUniformMatrix3fv(uniforms[UNIFORM_NORMAL_MATRIX], 1, 0, normalm.m);//object.getNormalMatrix.m)
 
    

    glUniform3fv(uniforms[UNIFORM_EYEPOINT], 1, _cameraPoint.v);
    if (vertexArrayID == VERTEX_ARRAY_BACKGROUND || vertexArrayID == VERTEX_ARRAY_SHADOW || vertexArrayID == VERTEX_BUFFER_PAD) {
        glUniform4fv(uniforms[UNIFORM_SPECULAR_COLOR], 1, zero.v);
        glUniform4fv(uniforms[UNIFORM_AMBIENT_COLOR], 1, one.v);
        glUniform4fv(uniforms[UNIFORM_DIFFUSE_COLOR], 1, zero.v);
        glDrawElements(GL_TRIANGLE_STRIP, object.getIndexCount, GL_UNSIGNED_SHORT, 0);
    }else{
        glUniform4fv(uniforms[UNIFORM_SPECULAR_COLOR], 1, _specularColor.v);
        glUniform4fv(uniforms[UNIFORM_AMBIENT_COLOR], 1, _ambientColor.v);
        glUniform4fv(uniforms[UNIFORM_DIFFUSE_COLOR], 1, _diffuseColor.v);
        glDrawElements(GL_TRIANGLES, object.getIndexCount, GL_UNSIGNED_SHORT, 0);
    }
}

-(void)dealloc{
    bgYin = nil;
    bgYang = nil;
}

- (void)viewDidUnload {
//    [self setBShare:nil];
    [self setBWhiteBackcolor:nil];
    [self setBBlackBackcolor:nil];
    [self setBTransparentBackcolor:nil];
    [super viewDidUnload];
}

////share
//- (IBAction)share:(id)sender {
//    [UMSocialSnsService presentSnsIconSheetView:self
//                                         appKey:@"507fcab25270157b37000010"
//                                      shareText:@"你要分享的文字"
//                                     shareImage:[UIImage imageNamed:@"icon-72.png"]
//                                shareToSnsNames:[NSArray arrayWithObjects:UMShareToSina,UMShareToTencent,UMShareToRenren,nil]
//                                       delegate:nil];
//    
//


///更新纹理
- (IBAction)bWhiteTouchUp:(id)sender {
    WTAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    appDelegate.attatchTexMode = WT_MODE_YANSE;
    appDelegate.backTexName = @"whiteBackTexture.jpg";
    [appDelegate.textureManager clearTexture:appDelegate.backTexName];
}

- (IBAction)bBlackTouchUp:(id)sender {
    WTAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    appDelegate.attatchTexMode = WT_MODE_YANSE;
    appDelegate.backTexName = @"blackBackTexture.jpg";
    [appDelegate.textureManager clearTexture:appDelegate.backTexName];
}

- (IBAction)bTransparentTouchUp:(id)sender {
    WTAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    appDelegate.attatchTexMode = WT_MODE_QINHUA;
    appDelegate.backTexName = @"whiteBackTexture.jpg";
    [appDelegate.textureManager clearTexture:appDelegate.backTexName];
}

@end*/
