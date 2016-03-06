//
//  WTPotteryFinViewController.m
//  Watao
//
//  Created by vegetablepig on 15-3-30.
//  Copyright (c) 2015年 连 承亮. All rights reserved.
//

#import "WTPotteryFinViewController.h"
#import "WTAppDelegate.h"
//#import "UMSocial.h"

@interface WTPotteryFinViewController ()

@end

@implementation WTPotteryFinViewController
@synthesize frameBuffer;
@synthesize renderBuffer;
@synthesize depthBuffer;
@synthesize go;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


//convert transition imprecisely to degree
-(IBAction)changeViewPoint:(UIPanGestureRecognizer*)paramSender{
    if (paramSender.state == UIGestureRecognizerStateBegan || paramSender.state == UIGestureRecognizerStateChanged) {
        CGPoint translation = [paramSender translationInView:self.view];
        CGPoint location = [paramSender locationInView:self.view];
        int touchedLevel = -2;
        bool isOnPottery = [self findLevelSelected:location Perspective:_perspective Pottery:_pottery Camera:_cameraPoint TouchedLevel:&touchedLevel];
        if (isOnPottery) {
            _rotationRate = 0.0f;
            _rotation += translation.x/100.0f;
        }else{
            _rotationRate = 0.2f;
        }
    }else{
        _rotationRate = 0.2f;
    }
    [paramSender setTranslation:CGPointMake(0, 0) inView:self.view];
}

- (void)viewDidLoad
{
    _ambientColor = GLKVector4Make(0.8f, 0.8f, 0.8f, 1.0f);//(0.4f, 0.4f, 0.4f, 1.0f);
    _specularColor = GLKVector4Make(0.7f, 0.7f, 0.7f, 1.0f);//(0.3f, 0.3f, 0.3f, 1.0f);
    _diffuseColor = GLKVector4Make(0.6f, 0.6f, 0.6f, 1.0f);//(0.6f, 0.6f, 0.6f, 1.0f);
    _ambientColor1 = GLKVector4Make(0.3f, 0.3f, 0.3f, 1.0f);//(0.4f, 0.4f, 0.4f, 1.0f);
    _specularColor1 = GLKVector4Make(0.0f, 0.0f, 0.0f, 1.0f);//(0.3f, 0.3f, 0.3f, 1.0f);
    _diffuseColor1 = GLKVector4Make(0.75f, 0.9f, 0.75f, 1.0f);//(0.6f, 0.6f, 0.6f, 1.0f);
    _ambientColorm = GLKVector4Make(0.5f, 0.6f, 0.6f, 1.0f);//(0.4f, 0.4f, 0.4f, 1.0f);
    _specularColorm = GLKVector4Make(0.7f, 0.7f, 0.7f, 1.0f);//(0.3f, 0.3f, 0.3f, 1.0f);
    _diffuseColorm = GLKVector4Make(0.5f, 0.5f, 0.5f, 1.0f);//(0.6f, 0.6f, 0.6f, 1.0f);
    super.isGravityTurnedOn = true;
    WTAppDelegate *delegate = [[UIApplication sharedApplication] delegate];
    [super viewDidLoad];
    [_background setupTexture:@"pottery_finished_activity_background.png"];
    [_pad setupTexture:@"finish_table.png"];
    //    [_pottery setupTexture:@"t4.jpg"];
    //WTAppDelegate *delegate = [[UIApplication sharedApplication] delegate];
    _pottery.textureID = [delegate.textureManager convertToTexturenew:_pottery.textureID];
    [_shadow setupTexture:@"shadow.png"];
    _transition = GLKVector3Make(0.0f, -1.5f, -3.5f);//_transition = GLKVector3Make(0.0f, -1.0f, -4.0f);
    _rotationRate = 0.2;
    _changeFlag = false;
    //    [self setUpNewRenderBuffer];
    
    //[self screenshot];
}

//TODO seperate pottery from render buffer
-(void)setUpNewRenderBuffer{
    GLint backingWidth, backingHeight;
    GLint defaultFBO, defaultRBO;
    /*glGetIntegerv(GL_FRAMEBUFFER_BINDING_OES, &defaultFBO);
    glGetIntegerv(GL_RENDERBUFFER_BINDING_OES, &defaultRBO);
    glBindFramebufferOES(GL_FRAMEBUFFER_OES, defaultFBO);
    glBindRenderbufferOES(GL_RENDERBUFFER_OES, defaultRBO);
    glGetRenderbufferParameterivOES(GL_RENDERBUFFER_OES, GL_RENDERBUFFER_WIDTH_OES, &backingWidth);
    glGetRenderbufferParameterivOES(GL_RENDERBUFFER_OES, GL_RENDERBUFFER_HEIGHT_OES, &backingHeight);
    //get height
    glGenFramebuffersOES(1, &frameBuffer);
	glBindFramebufferOES(GL_FRAMEBUFFER_OES, frameBuffer);
    
    //init render buffer
	glGenRenderbuffersOES(1, &renderBuffer);
	glBindRenderbufferOES(GL_RENDERBUFFER_OES, renderBuffer);
	glRenderbufferStorageOES(GL_RENDERBUFFER_OES, GL_RGB8_OES, 640, 960);
    
    //depth buffer
    //    glGenRenderbuffersOES(1, &depthBuffer);
    //    glBindRenderbufferOES(GL_RENDERBUFFER_OES, renderBuffer);
    //    glRenderbufferStorage(GL_RENDERBUFFER, GL_DEPTH_COMPONENT16_OES, 640, 960);
    
    //render buffer
    glFramebufferRenderbufferOES(GL_FRAMEBUFFER_OES, GL_COLOR_ATTACHMENT0_OES, GL_RENDERBUFFER_OES, renderBuffer);*/
    //    glFramebufferRenderbuffer(GL_FRAMEBUFFER_OES, GL_DEPTH_ATTACHMENT_OES, GL_RENDERBUFFER_OES, depthBuffer);
    //check status
    
    //new add
    //new add
    glGetIntegerv(GL_FRAMEBUFFER_BINDING, &defaultFBO);
    glGetIntegerv(GL_RENDERBUFFER_BINDING, &defaultRBO);
    glBindFramebuffer(GL_FRAMEBUFFER, defaultFBO);
    glBindRenderbuffer(GL_RENDERBUFFER, defaultRBO);
    glGetRenderbufferParameteriv(GL_RENDERBUFFER, GL_RENDERBUFFER_WIDTH, &backingWidth);
    glGetRenderbufferParameteriv(GL_RENDERBUFFER, GL_RENDERBUFFER_HEIGHT, &backingHeight);
    
    //get height
    glGenFramebuffers(1, &frameBuffer);
    glBindFramebuffer(GL_FRAMEBUFFER, frameBuffer);
    
    //init render buffer
    glGenRenderbuffers(1, &renderBuffer);
    glBindRenderbuffer(GL_RENDERBUFFER, renderBuffer);
    glRenderbufferStorage(GL_RENDERBUFFER, GL_RGB8_OES, 640, 960);
    
    //depth buffer
    //    glGenRenderbuffersOES(1, &depthBuffer);
    //    glBindRenderbufferOES(GL_RENDERBUFFER_OES, renderBuffer);
    //    glRenderbufferStorage(GL_RENDERBUFFER, GL_DEPTH_COMPONENT16_OES, 640, 960);
    
    //render buffer
    glFramebufferRenderbuffer(GL_FRAMEBUFFER, GL_COLOR_ATTACHMENT0, GL_RENDERBUFFER, renderBuffer);
    
    
    
    GLenum status = glCheckFramebufferStatus(GL_FRAMEBUFFER) ;
    if(status != GL_FRAMEBUFFER_COMPLETE) {
        NSLog(@"failed to make complete framebuffer object %x", status);
    }
    
}

- (IBAction)next:(id)sender {
    go.alpha = 0;
    [self screenshot];
}

-(void) screenshot{
    
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(CGRectGetWidth(self.view.frame),
                                                      CGRectGetHeight(self.view.frame)), NO,
                                           1);
    
    
    [self.view
     drawViewHierarchyInRect:CGRectMake(0,
                                        
                                        0,
                                        CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame))
     afterScreenUpdates:NO];
    
    
    UIImage
    *snapshot =
    UIGraphicsGetImageFromCurrentImageContext();
    
    
    UIGraphicsEndImageContext();
    WTAppDelegate *delegate = [[UIApplication sharedApplication] delegate];
    
    //CGImageRef UIGetScreenImage();
    //CGImageRef img = UIGetScreenImage();
    delegate.finishimage = snapshot;//[UIImage imageWithCGImage:img];
    //UIImage* snapshot = [UIImage imageWithCGImage:img];
    //[delegate.textureManager savescreenshoot:snapshot];
    //return image;
}

//- (void)glkView:(GLKView *)view drawInRect:(CGRect)rect{
////    GLint defaultFBO, defaultRBO;
////    glGetIntegerv(GL_FRAMEBUFFER_BINDING_OES, &defaultFBO);
////    glGetIntegerv(GL_RENDERBUFFER_BINDING_OES, &defaultRBO);
////    glBindFramebufferOES(GL_FRAMEBUFFER_OES, defaultFBO);
////    glBindRenderbufferOES(GL_RENDERBUFFER_OES, defaultRBO);
//    [super glkView:view drawInRect:rect];
//    glBindFramebufferOES(GL_FRAMEBUFFER_OES, frameBuffer);
////    glBindRenderbufferOES(GL_RENDERBUFFER_OES, depthBuffer);
//    glBindRenderbufferOES(GL_RENDERBUFFER_OES, renderBuffer);
//    [self drawObeject:_pottery :VERTEX_ARRAY_POTTERY];
//
//}

- (void)viewDidUnload {
    [super viewDidUnload];
}

/*
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
    if (([self.view window] == nil)) {
        //transform the model world according to gravity
    }
    // Dispose of any resources that can be recreated.
}*/

-(void)viewDidDisappear:(BOOL)animated{
    
    [super viewDidDisappear:animated];
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard_iPad" bundle:nil];
    UIViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"fin"];
    vc = nil;
}


@end
