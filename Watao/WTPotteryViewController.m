//
//  WTViewController.m
//  Watao
//
//  Created by 连 承亮 on 14-2-27.
//  Copyright (c) 2014年 连 承亮. All rights reserved.
//

#import "WTPotteryViewController.h"
#import "WTAppDelegate.h"

@implementation WTPotteryViewController

@synthesize isGravityTurnedOn;
@synthesize context;
@synthesize texcube;
@synthesize flashflag;

//-(void)viewWillAppear:(BOOL)animated
//{
//    [super viewWillAppear:animated];
//    [[self view] becomeFirstResponder];
//}

//-(void)viewWillDisappear:(BOOL)animated
//{
//    [super viewWillDisappear:animated];
////    [self.motionManager stopAccelerometerUpdates];
//    //tell accelerator to stop working
//}


- (void)viewDidLoad
{
   // for (GLuint i=0; i < 100; i++)
    //    glDeleteTextures(1, &i);
    
    one = GLKVector4Make(1.0f, 1.0f, 1.0f, 1.0f);
    zero = GLKVector4Make(0.0f, 0.0f, 0.0f, 1.0f);
    WTAppDelegate *delegate = [[UIApplication sharedApplication] delegate];
    //delegate = [[UIApplication sharedApplication] delegate];
    //set up accemoeter
    _pottery = delegate.pottery;
    _pad = delegate.pad;
    _background = delegate.background;
    _shadow = delegate.shadow;
    _bottom = delegate.bottom;
    //load objects from the appDelegate
    _scale = GLKVector3Make(1.0f*0.9f, 0.7f*0.9f, 1.0f*0.9f);//(1.0f, 0.7f, 1.0f);//set the scale of the view(1 .7 1)
    _gravity = GLKVector3Make(0.0f, 0.0f, 0.0f);
    _viewPointNow = GLKVector3Make(0.0f, 0.0f, 0.0f);
    _cameraDir = GLKVector3Make(0.0f, 0.0f, 0.0f);
    //indicate the rotation at every direction
    _cameraPoint = GLKVector3Make(0.0f, 0.0f, 0.0f);
    _perspective = 65.0f;
    _viewTransformMatrix = GLKMatrix4MakeTranslation(0.0f, 0.0f, 0.0f);
    _rotationRate = 0.5f;
    //set parameters*/
    [super viewDidLoad];
    self.context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
    //initial the context with openGLES2.0
    if (!self.context) {
        NSLog(@"Failed to create ES context");
    }
    
    GLKView *view = (GLKView *)self.view;
    view.context = self.context;
    //set the context to this view
    view.drawableDepthFormat = GLKViewDrawableDepthFormat24;
    //set the depth buffer for the view
    self.preferredFramesPerSecond = 40;
    //set the FPS to 40
//    view.drawableMultisample = GLKViewDrawableMultisample4X;
    //Enable multisampling
    [self setupGL];
    //set up OpenGL
    if (isGravityTurnedOn) {
        self.motionManager = [[CMMotionManager alloc] init];
        self.motionManager.accelerometerUpdateInterval = 0.2f;
        [self.motionManager startAccelerometerUpdatesToQueue:[NSOperationQueue currentQueue]
                                                 withHandler:^(CMAccelerometerData  *accelerometerData, NSError *error) {
                                                     [self sampleAccelertionData:accelerometerData.acceleration];
                                                     if(error){
                                                         
                                                         NSLog(@"%@", error);
                                                     }
                                                 }];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(stopAccelerometer:)
                                                     name:UIApplicationDidEnterBackgroundNotification
                                                   object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(resumeAccelerometer:)
                                                     name:UIApplicationDidBecomeActiveNotification
                                                   object:nil];
        //setup accelerometer
    }
}

-(void)resumeAccelerometer: (NSNotification*) notification{
    [self.motionManager startAccelerometerUpdatesToQueue:[NSOperationQueue currentQueue]
                                             withHandler:^(CMAccelerometerData  *accelerometerData, NSError *error) {
                                                 [self sampleAccelertionData:accelerometerData.acceleration];
                                                 if(error){
                                                     
                                                     NSLog(@"%@", error);
                                                 }
                                             }];
}

-(void)stopAccelerometer: (NSNotification*) notification{
    [self.motionManager stopAccelerometerUpdates];
}

-(void)sampleAccelertionData:(CMAcceleration)acceleration
{
//    self.accX.text = [NSString stringWithFormat:@" %.2fg",acceleration.x];
//    self.accY.text = [NSString stringWithFormat:@" %.2fg",acceleration.y];
    float gap = 0.6f;
    if(acceleration.x > gap){
        acceleration.x = gap;
    }
    if (acceleration.x < -gap) {
        acceleration.x = -gap;
    }
    if(acceleration.y > gap){
        acceleration.y = gap;
    }
    if (acceleration.y < -gap) {
        acceleration.y = -gap;
    }
    _gravity.x = acceleration.x; //reverse the x for the benefit of rotation
    _gravity.y = -acceleration.y;
    _gravity.z = acceleration.z;
    //y[-1g,1g] --- x[5.0f, 25.0f]
    //x[-1g,1g] --- y[-10.0f, 10.0f]
}

//could not auto rotate the screen
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    return (toInterfaceOrientation == UIInterfaceOrientationPortrait);
}

- (BOOL)shouldAutorotate
{
    return NO;
}

- (NSUInteger)supportedInterfaceOrientations

{
    return UIInterfaceOrientationMaskPortrait;//只支持这一个方向(正常的方向)
}

-(void)viewDidDisappear:(BOOL)animated{
    //[super viewDidDisappear:animated];
    [self tearDownGL];
    [self.motionManager stopAccelerometerUpdates];
//    _pottery = nil;
    if ([EAGLContext currentContext] == self.context) {
        //[EAGLContext setCurrentContext:nil];
    }
//    self.view = nil;
//    self.motionManager = nil;
//    self.context = nil;
//    self.effect = nil;
    //glDeleteTextures(1, &t1);
    
    /*glDeleteTextures(1, &t1);
    
    //t1 = [_background setupTexture:@"main_activity_background.png"];
    
    glDeleteTextures(1, &t2);
    
    
    
    glDeleteTextures(1, &t3);*/
    //_pottery = nil;
    //_pad = nil;
    //_background = nil;
    //_shadow = nil;
    //delegate = nil;
    //_bottom = nil;
    NSLog(@"disappear!!!");
    //delegate = nil;
}

-(void)viewWillDisappear:(BOOL)animated{
    
     NSLog(@"willdisappear");
//    GLuint tmp;
//    glGenTextures(1, &tmp);
//    for (GLuint i= 0 ; i<=tmp; i++)
//    glDeleteTextures(1, &i);
    
    //glDeleteTextures(1, &t2);
    
    //glDeleteTextures(1, &t3);
    
    //lDeleteTextures(1, &t4);
    
    [self tearDownGL];
    [self.motionManager stopAccelerometerUpdates];
    if ([EAGLContext currentContext] == self.context) {
       // [EAGLContext setCurrentContext:nil];
        for (GLuint i = 0; i <= 1000; i++)
            glDeleteTextures(1, &i);
        [EAGLContext setCurrentContext:nil];
    }
    
    if ((self.isViewLoaded && [self.view window] == nil)) {
        self.view = nil;
    }
    
    [super viewWillDisappear:animated];

    /*glDeleteTextures(1, &t1);
        t1 = [_background setupTexture:@"main_activity_background.png"];
    
    glDeleteTextures(1, &t2);
    
    
    
    glDeleteTextures(1, &t3);*/
    //self.view = nil;
    //self.context = nil;*/
}

- (void)dealloc
{    
    //[self tearDownGL];
    self.motionManager = nil;
    self.context = nil;
    _pottery = nil;
    NSLog(@"dealloc");
    if ([EAGLContext currentContext] == self.context) {
        //[EAGLContext setCurrentContext:nil];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];

    if ((self.isViewLoaded && [self.view window] == nil)) {
        self.view = nil;
        
        //[self tearDownGL];
        
        /*if ([EAGLContext currentContext] == self.context) {
            [EAGLContext setCurrentContext:nil];
        }
        self.context = nil;*/
    
    _pottery = nil;
    _pad = nil;
    _background = nil;
    _shadow = nil;
      //  _shadow = nil;
      //  delegate = nil;
    //transform the model world according to gravity
    }
    // Dispose of any resources that can be recreated.

}
/**
 * initial the shader and pass the VAO data into it
 **/

- (void)setupGL
{
    [EAGLContext setCurrentContext:self.context];
    //set context as the current context
    [self loadShaders];
    //[self loadShaders1];
    
    [self CreateSimpleTextureCubemap];
    
    glEnable(GL_DEPTH_TEST);
    /////////////////////////////////
    [self setupGLfor:VERTEX_ARRAY_POTTERY :VERTEX_BUFFER_POTTERY :INDEX_BUFFER_POTTERY :_pottery];
    //setUp the state of the pottery
    /////////////////////////////////
    //set up the vertex array objects
    [self setupGLfor:VERTEX_ARRAY_PAD :VERTEX_BUFFER_PAD :INDEX_BUFFER_PAD :_pad];
    //setUp the state of the pad
    /////////////////////////////////
    [self setupGLfor:VERTEX_ARRAY_BACKGROUND :VERTEX_BUFFER_BACKGROUND :INDEX_BUFFER_BACKGROUND :_background];
    //set up the background
    /////////////////////////////////
    [self setupGLfor:VERTEX_ARRAY_SHADOW :VERTEX_BUFFER_SHADOW :INDEX_BUFFER_SHADOW :_shadow];
    //set up the shadow
    
    //[self setupGLfor:VERTEX_ARRAY_SHADOW :VERTEX_BUFFER_SHADOW :INDEX_BUFFER_SHADOW :_bottom];]

}


-(void)setupGLfor: (GLint)vertexArrayID
                 :(GLint)vertexBufferID
                 :(GLint)indexBufferID
                 :(WTMeshObject *)object{
    glGenVertexArraysOES(1, &vertexArraies[vertexArrayID]);
    glBindVertexArrayOES(vertexArraies[vertexArrayID]);
    
    //bind the vertex buffer objects to vertex array objects
    glGenBuffers(1, &vertexBuffers[vertexBufferID]);
    glBindBuffer(GL_ARRAY_BUFFER, vertexBuffers[vertexBufferID]);
    //initial the data with the vertexbuffer and hint the data with static draw
    Vertex* vertexData = object.getVertices;
//    GLuint a = sizeof(Vertex);
    if (vertexArrayID == VERTEX_ARRAY_POTTERY) {
        glBufferData(GL_ARRAY_BUFFER, sizeof(Vertex)*object.getVertexCount, vertexData, GL_DYNAMIC_DRAW);
    }else{
        glBufferData(GL_ARRAY_BUFFER, sizeof(Vertex)*object.getVertexCount, vertexData, GL_STATIC_DRAW);

    }

    //called after set up shader and find the position of these variables
    glEnableVertexAttribArray(GLKVertexAttribPosition);
    glVertexAttribPointer(GLKVertexAttribPosition, 4, GL_FLOAT, GL_FALSE, WT_VERTEX_STRIDE, BUFFER_OFFSET(0));
    //hint the data is composed of 4 components with the type of GL_FLOAT, 4th parameter has no meaning
    //the 5th parameter is the stride, aka, the size of the vertex(4*4*2)
    glEnableVertexAttribArray(GLKVertexAttribNormal);
    glVertexAttribPointer(GLKVertexAttribNormal, 3, GL_FLOAT, GL_FALSE, WT_VERTEX_STRIDE, BUFFER_OFFSET(16));
    //set the texture here
    glEnableVertexAttribArray(GLKVertexAttribTexCoord0);
    glVertexAttribPointer(GLKVertexAttribTexCoord0, 2, GL_FLOAT, GL_FALSE, WT_VERTEX_STRIDE, BUFFER_OFFSET(32));

    //setup the index here
    glGenBuffers(1, &indexBuffers[indexBufferID]);
    glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, indexBuffers[indexBufferID]);
    GLushort *indexData = object.getIndices;
    glBufferData(GL_ELEMENT_ARRAY_BUFFER, object.getIndexCount*sizeof(GLushort), indexData, GL_STATIC_DRAW);
    
    glBindVertexArrayOES(0);
}


- (UIImage *)resizeImage:(UIImage *)image toSize:(CGSize)reSize
{
    UIGraphicsBeginImageContext(CGSizeMake(reSize.width, reSize.height));
    [image drawInRect:CGRectMake(0, 0, reSize.width, reSize.height)];
    UIImage *resizeImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return resizeImage;
}

- (void)tearDownGL
{
    NSLog(@"teardown");
    
    [EAGLContext setCurrentContext:self.context];
    
//    glGenVertexArraysOES(1, &vertexArraies[vertexArrayID]);
//    glGenBuffers(1, &vertexBuffers[vertexBufferID]);
//    glGenBuffers(1, &indexBuffers[indexBufferID]);
    
    glDeleteBuffers(1, &vertexBuffers[VERTEX_BUFFER_POTTERY]);
    glDeleteVertexArraysOES(1, &vertexArraies[VERTEX_ARRAY_POTTERY]);
    glDeleteBuffers(1, &indexBuffers[INDEX_BUFFER_POTTERY]);
    
    glDeleteBuffers(1, &vertexBuffers[VERTEX_BUFFER_PAD]);
    glDeleteVertexArraysOES(1, &vertexArraies[VERTEX_ARRAY_PAD]);
    glDeleteBuffers(1, &indexBuffers[INDEX_BUFFER_PAD]);
    
    glDeleteBuffers(1, &vertexBuffers[VERTEX_BUFFER_BACKGROUND]);
    glDeleteVertexArraysOES(1, &vertexArraies[VERTEX_ARRAY_BACKGROUND]);
    glDeleteBuffers(1, &indexBuffers[INDEX_BUFFER_BACKGROUND]);

    glDeleteBuffers(1, &vertexBuffers[VERTEX_BUFFER_SHADOW]);
    glDeleteVertexArraysOES(1, &vertexArraies[VERTEX_ARRAY_SHADOW]);
    glDeleteBuffers(1, &indexBuffers[INDEX_BUFFER_SHADOW]);
    
    if (_program) {
        glDeleteProgram(_program);
        _program = 0;
    }
    if (_program1) {
        glDeleteProgram(_program1);
        _program1 = 0;
    }
}

-(void)calViewpointChange{
    float tempA = 0.008f;
    if (_viewPointNow.x < _gravity.x - tempA) {
        _viewPointNow.x += tempA;
    }else if (_viewPointNow.x > _gravity.x + tempA){
        _viewPointNow.x -= tempA;
    }
    if (_viewPointNow.y < _gravity.y - tempA) {
        _viewPointNow.y += tempA;
    }else if (_viewPointNow.y > _gravity.y + tempA){
        _viewPointNow.y -= tempA;
    }
    _cameraDir.x = 10.0f*_viewPointNow.y-15.0f;
    _cameraDir.y = 10.0f*_viewPointNow.x;
    _viewTransformMatrix = GLKMatrix4MakeTranslation(0.0f, 0.0f, 0.0f);
    _viewTransformMatrix = GLKMatrix4RotateX(_viewTransformMatrix, GLKMathDegreesToRadians(_cameraDir.x));
    //conterClock equals [5.0f-25.0f] at above
    _viewTransformMatrix = GLKMatrix4RotateY(_viewTransformMatrix, GLKMathDegreesToRadians(_cameraDir.y));
//    _viewTransformMatrix = GLKMatrix4Invert(_viewTransformMatrix, &isInvertable);
}


#pragma mark - GLKView and GLKViewController delegate methods
/**
 * called every time after the fromer frame has been displayed and prepared for the next buffer
 **/

-(void)update
{
    
    bool isInvertable;
    [self calViewpointChange];
    GLKMatrix4 invMat = GLKMatrix4Invert(_viewTransformMatrix, &isInvertable);
    float aspect = fabsf(self.view.bounds.size.width / self.view.bounds.size.height);
    GLKMatrix4 projectionMatrix = GLKMatrix4MakePerspective(GLKMathDegreesToRadians(_perspective), aspect, 0.1f, 100.0f);
    GLKMatrix4 baseModelViewMatrix = GLKMatrix4MakeTranslation(_transition.x, _transition.y, _transition.z);
    baseModelViewMatrix = GLKMatrix4Multiply(baseModelViewMatrix, invMat);
    //GLKVector3 scale = GLKVector3Make(0.15f, 0.04f, 0.15f);
    GLKVector3 translate = GLKVector3Make(0.0f, 0.0f, 0.0f);
    _modelViewMatrix = [_pottery moveRotate: _rotation scale: _scale translate:translate base:baseModelViewMatrix project: projectionMatrix]; //save the modelView Matrix in order to judge point touch
    //scale = GLKVector3Make(0.15f, 0.002f, 0.15f);
    translate = GLKVector3Make(0.0f, -1.0f*_scale.y*_pad.getHeight, 0.0f);
    [_pad moveRotate:_rotation scale:_scale translate:translate base:baseModelViewMatrix project:projectionMatrix];
    float rBottom = _pottery.getRadius[0];
    float rInit = _pottery.initRadius;
    float s = 1.0f/rInit*rBottom;
    [_shadow moveRotate:GLKMathDegreesToRadians(170.0f) scale:GLKVector3MultiplyScalar(_scale, s) translate:translate base:baseModelViewMatrix project:projectionMatrix];
    baseModelViewMatrix = GLKMatrix4MakeTranslation(0.0f, -4.5f, -15.0f);
    baseModelViewMatrix = GLKMatrix4Multiply(baseModelViewMatrix, invMat);
    [_background moveRotate:GLKMathDegreesToRadians(0.0f) scale:GLKVector3Make(3.3f, 1.3f, 0.5f) translate:translate base:baseModelViewMatrix project:projectionMatrix];
    _rotation += self.timeSinceLastUpdate * _rotationRate;

}

//dynamically setup and update the data of pottery

-(void) setupPottery{
    glBindBuffer(GL_ARRAY_BUFFER, vertexBuffers[VERTEX_BUFFER_POTTERY]);
    //initial the data with the vertexbuffer and hint the data with static draw
    Vertex* vertexData = _pottery.getVertices;
    glBufferData(GL_ARRAY_BUFFER, sizeof(Vertex)*_pottery.getVertexCount, vertexData, GL_DYNAMIC_DRAW);//~~//
    
    //called after set up shader and find the position of these variables
    glEnableVertexAttribArray(GLKVertexAttribPosition);
    glVertexAttribPointer(GLKVertexAttribPosition, 4, GL_FLOAT, GL_FALSE, WT_VERTEX_STRIDE, BUFFER_OFFSET(0));
    glEnableVertexAttribArray(GLKVertexAttribNormal);
    glVertexAttribPointer(GLKVertexAttribNormal, 3, GL_FLOAT, GL_FALSE, WT_VERTEX_STRIDE, BUFFER_OFFSET(16));
    glEnableVertexAttribArray(GLKVertexAttribTexCoord0);
    glVertexAttribPointer(GLKVertexAttribTexCoord0, 2, GL_FLOAT, GL_FALSE, WT_VERTEX_STRIDE, BUFFER_OFFSET(32));
}

/**
 * a draw loop
 **/

- (void)glkView:(GLKView *)view drawInRect:(CGRect)rect
{
    glEnable(GL_BLEND);
    glBlendFunc(GL_ONE, GL_ONE_MINUS_SRC_ALPHA);
//    glBlendFunc(GL_ONE, GL_ZERO);
//    glBlendFunc(GL_ONE, GL_SRC_COLOR);
    glClearColor(61.0f/255.0f, 145.0f/255.0f, 64.0f/255.0f, 0.0f);
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
    glUseProgram(_program);
//    ////////////////////////////////////////
    // pass 2 matrix to OPGLES to draw
//    glUniform1f(uniforms[UNIFORM_HEIGHT], _pottery.getHeight);
//    glUniform1fv(uniforms[UNIFORM_RADIUS], WT_NUM_LEVEL, _pottery.getRadius);

    [self drawObeject:_pottery :VERTEX_ARRAY_POTTERY];
    //draw pottery
    
    //glUseProgram(_program1);
    ////////////////////////////////////////
    [self drawObeject:_pad :VERTEX_ARRAY_PAD];
    //draw pad
    /////////////////////////////////////////
    [self drawObeject:_background :VERTEX_ARRAY_BACKGROUND];
    //draw background
    ////////////////////////////////////////
    [self drawObeject:_shadow :VERTEX_ARRAY_SHADOW];
    //draw shadow
//    glEnable(GL_BLEND);
//    glBlendFunc(GL_ONE, GL_ONE_MINUS_SRC_ALPHA);
//    //    glBlendFunc(GL_ONE, GL_ZERO);
//    //    glBlendFunc(GL_ONE, GL_SRC_COLOR);
//    glClearColor(1.0f, 1.0f, 1.0f, 0.0f);
//    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
//    //    ////////////////////////////////////////
//    glBindVertexArrayOES(vertexArraies[VERTEX_ARRAY_POTTERY]);
//    // Render the object again with ES2
//    glUseProgram(_program);
//    glUniformMatrix4fv(uniforms[UNIFORM_MODELVIEWPROJECTION_MATRIX], 1, 0, _pottery.getModelProjectionViewMatrix.m);
//    glUniformMatrix3fv(uniforms[UNIFORM_NORMAL_MATRIX], 1, 0, _pottery.getNormalMatrix.m);
//    glBindTexture(GL_TEXTURE_2D, [_pottery textureID]);
//    // pass 2 matrix to OPGLES to draw
//    //    glUniform1f(uniforms[UNIFORM_HEIGHT], _pottery.getHeight);
//    //    glUniform1fv(uniforms[UNIFORM_RADIUS], WT_NUM_LEVEL, _pottery.getRadius);
//    [self setupPottery];
//    //glDrawArrays(GL_POINTS, 0, _pottery.getVertexCount);
//    glDrawElements(GL_TRIANGLES, _pottery.getIndexCount, GL_UNSIGNED_SHORT, 0);
//    //draw pottery
//    ////////////////////////////////////////
//    glBindVertexArrayOES(vertexArraies[VERTEX_ARRAY_PAD]);
////    glUseProgram(_program);
//    glBindTexture(GL_TEXTURE_2D, [_pad textureID]);
//    glUniformMatrix4fv(uniforms[UNIFORM_MODELVIEWPROJECTION_MATRIX], 1, 0, _pad.getModelProjectionViewMatrix.m);
//    glUniformMatrix3fv(uniforms[UNIFORM_NORMAL_MATRIX], 1, 0, _pad.getNormalMatrix.m);
//    //glDrawArrays(GL_POINTS, 0, _pad.getVertexCount);
//    glDrawElements(GL_TRIANGLES, _pad.getIndexCount, GL_UNSIGNED_SHORT, 0);
//    //draw pad
//    /////////////////////////////////////////
//    glBindVertexArrayOES(vertexArraies[VERTEX_ARRAY_BACKGROUND]);
////    glUseProgram(_program);
//    glBindTexture(GL_TEXTURE_2D, [_background textureID]);
//    glUniformMatrix4fv(uniforms[UNIFORM_MODELVIEWPROJECTION_MATRIX], 1, 0, _background.getModelProjectionViewMatrix.m);
//    glUniformMatrix3fv(uniforms[UNIFORM_NORMAL_MATRIX], 1, 0, _background.getNormalMatrix.m);
//    //glDrawArrays(GL_POINTS, 0, _background.getVertexCount);
//    glDrawElements(GL_TRIANGLE_STRIP, _background.getIndexCount, GL_UNSIGNED_SHORT, 0);
//    //draw background
//    ////////////////////////////////////////
//    glBindVertexArrayOES(vertexArraies[VERTEX_ARRAY_SHADOW]);
////    glUseProgram(_program);
//    glBindTexture(GL_TEXTURE_2D, [_shadow textureID]);
//    glUniformMatrix4fv(uniforms[UNIFORM_MODELVIEWPROJECTION_MATRIX], 1, 0, _shadow.getModelProjectionViewMatrix.m);
//    glUniformMatrix3fv(uniforms[UNIFORM_NORMAL_MATRIX], 1, 0, _shadow.getNormalMatrix.m);
//    glDrawElements(GL_TRIANGLES, _shadow.getIndexCount, GL_UNSIGNED_SHORT, 0);
//    //draw shadow

}


- (GLuint) CreateSimpleTextureCubemap
{
    GLuint textureId;
    // Generate a texture object
    glGenTextures ( 1, &textureId );
    //NSLog(@"cubetext: %d", textureId);
    // Bind the texture object
    glBindTexture ( GL_TEXTURE_CUBE_MAP, textureId );
    WTAppDelegate *delegate = [[UIApplication sharedApplication] delegate];
    UIImage *image = [delegate.imageManager getUIimg: @"light.jpg"];
    //image = [image resizableImageWithCapInsets:UIEdgeInsetsZero resizingMode:UIImageResizingModeTile];
    image = [self resizeImage:image toSize:CGSizeMake((GLfloat)32, (GLfloat)32)];//image.size.width)];
    /*CGImageRef spriteImage = image.CGImage;
    if (!spriteImage) {
        NSLog(@"Failed to load image light.jpg");
        exit(1);
    }     // 2
    GLsizei width = CGImageGetWidth(spriteImage);
    GLsizei height = CGImageGetWidth(spriteImage);
    GLubyte * spriteData = (GLubyte *) calloc(width*height*4, sizeof(GLubyte));
    CGContextRef spriteContext = CGBitmapContextCreate(spriteData, width, height, 8, width*4,CGImageGetColorSpace(spriteImage), kCGImageAlphaPremultipliedLast);         // 3
    CGContextDrawImage(spriteContext, CGRectMake(0, 0, width, height), spriteImage);
    //CGImageRelease(spriteImage);
    CGContextRelease(spriteContext);     // 4
    */
    
    //CGImageRef spriteImage = image.CGImage;
    if (!image.CGImage) {
        NSLog(@"Failed to load image light.jpg");
        exit(1);
    }     // 2
    GLsizei width = CGImageGetWidth(image.CGImage);
    GLsizei height = CGImageGetWidth(image.CGImage);
    GLubyte * spriteData = (GLubyte *) calloc(width*height*4, sizeof(GLubyte));
    CGContextRef spriteContext = CGBitmapContextCreate(spriteData, width, height, 8, width*4,CGImageGetColorSpace(image.CGImage), kCGImageAlphaPremultipliedLast);         // 3
    CGContextDrawImage(spriteContext, CGRectMake(0, 0, width, height), image.CGImage);
    //CGImageRelease(spriteImage);
    CGContextRelease(spriteContext);
    
    
    // Load the cube face - Positive X
    glTexImage2D ( GL_TEXTURE_CUBE_MAP_POSITIVE_X, 0, GL_RGBA, width, height, 0,
                  GL_RGBA, GL_UNSIGNED_BYTE, spriteData);
    
    // Load the cube face - Negative X
    glTexImage2D ( GL_TEXTURE_CUBE_MAP_NEGATIVE_X, 0, GL_RGBA, width, height, 0,
                  GL_RGBA, GL_UNSIGNED_BYTE, spriteData);
    
    // Load the cube face - Positive Y
    glTexImage2D ( GL_TEXTURE_CUBE_MAP_POSITIVE_Y, 0, GL_RGBA, width, height, 0,
                  GL_RGBA, GL_UNSIGNED_BYTE, spriteData);
    
    // Load the cube face - Negative Y
    glTexImage2D ( GL_TEXTURE_CUBE_MAP_NEGATIVE_Y, 0, GL_RGBA, width, height, 0,
                  GL_RGBA, GL_UNSIGNED_BYTE, spriteData);
    
    // Load the cube face - Positive Z
    glTexImage2D ( GL_TEXTURE_CUBE_MAP_POSITIVE_Z, 0, GL_RGBA, width, height, 0,
                  GL_RGBA, GL_UNSIGNED_BYTE, spriteData);
    
    // Load the cube face - Negative Z
    glTexImage2D ( GL_TEXTURE_CUBE_MAP_NEGATIVE_Z, 0, GL_RGBA, width, height, 0,
                  GL_RGBA, GL_UNSIGNED_BYTE, spriteData);
    free(spriteData);
    // Set the filtering mode
    glTexParameterf ( GL_TEXTURE_CUBE_MAP, GL_TEXTURE_MIN_FILTER, GL_LINEAR  );
    glTexParameterf ( GL_TEXTURE_CUBE_MAP, GL_TEXTURE_MAG_FILTER, GL_LINEAR  );
    glTexParameterf( GL_TEXTURE_CUBE_MAP, GL_TEXTURE_WRAP_S, GL_REPEAT);
    glTexParameterf( GL_TEXTURE_CUBE_MAP, GL_TEXTURE_WRAP_T, GL_REPEAT);
    texcube = textureId;
    image = nil;
    //CGImageRelease(spriteImage);
    return textureId;
}

-(void)drawObeject:(WTMeshObject *)object
                  :(GLint)vertexArrayID{
    glBindVertexArrayOES(vertexArraies[vertexArrayID]);
    if (vertexArrayID == VERTEX_ARRAY_POTTERY){
        [self setupPottery];
        glUniform1i(uniforms[UNIFORM_FCUBE], 1);
    }
    else {glUniform1i(uniforms[UNIFORM_FCUBE], 0);}
    //glBindTexture(GL_TEXTURE_2D, [object textureID]);
    glActiveTexture(GL_TEXTURE0);
    //glEnable(GL_TEXTURE_CUBE_MAP);
    //WTAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    glBindTexture(GL_TEXTURE_CUBE_MAP, texcube);//[self CreateSimpleTextureCubemap]);
    glActiveTexture(GL_TEXTURE1);
    //glEnable(GL_TEXTURE_2D);
    if (vertexArrayID == VERTEX_ARRAY_POTTERY) {
        glBindTexture(GL_TEXTURE_2D, [_pottery textureID]);//[object textureID]);
    }
    else {glBindTexture(GL_TEXTURE_2D, [object textureID]);}
    glUniform1i(uniforms[UNIFORM_CUBE], 0);
    glUniform1i(uniforms[UNIFORM_TEXTURE], 1);
    //glActiveTexture(GL_TEXTURE2);
    //glBindTexture(GL_TEXTURE_2D, [_pad textureID]);//[object textureID]);
    //glUniform1i(uniforms[UNIFORM_TEXTURE_IN], 2);
    GLKMatrix4 modelm = object.getModelProjectionViewMatrix;
    GLKMatrix3 normalm = object.getNormalMatrix;
    
    glUniformMatrix4fv(uniforms[UNIFORM_MODELVIEWPROJECTION_MATRIX], 1, 0, modelm.m);//object.getModelProjectionViewMatrix.m);
    glUniformMatrix3fv(uniforms[UNIFORM_NORMAL_MATRIX], 1, 0, normalm.m);//object.getNormalMatrix.m);
    glUniform3fv(uniforms[UNIFORM_EYEPOINT], 1, _cameraPoint.v);
    if (vertexArrayID == VERTEX_ARRAY_POTTERY || (vertexArrayID == VERTEX_ARRAY_BACKGROUND && flashflag == true)){
        glUniform4fv(uniforms[UNIFORM_SPECULAR_COLOR], 1, _specularColor.v);
        glUniform4fv(uniforms[UNIFORM_AMBIENT_COLOR], 1, _ambientColor.v);
        glUniform4fv(uniforms[UNIFORM_DIFFUSE_COLOR], 1, _diffuseColor.v);
        glUniform4fv(uniforms[UNIFORM_SPECULAR_COLOR1], 1, _specularColor1.v);
        glUniform4fv(uniforms[UNIFORM_AMBIENT_COLOR1], 1, _ambientColor1.v);
        glUniform4fv(uniforms[UNIFORM_DIFFUSE_COLOR1], 1, _diffuseColor1.v);
        glUniform4fv(uniforms[UNIFORM_SPECULAR_COLORM], 1, _specularColorm.v);
        glUniform4fv(uniforms[UNIFORM_AMBIENT_COLORM], 1, _ambientColorm.v);
        glUniform4fv(uniforms[UNIFORM_DIFFUSE_COLORM], 1, _diffuseColorm.v);
        glUniform1i(uniforms[UNIFORM_FLAG], 1);
        glDrawElements(GL_TRIANGLES, object.getIndexCount, GL_UNSIGNED_SHORT, 0);
    } else if (vertexArrayID == VERTEX_ARRAY_BACKGROUND) {
//        glUniform4fv(uniforms[UNIFORM_SPECULAR_COLOR], 1, GLKVector4Make(0.0f, 0.0f, 0.0f, 1.0f).v);
//        glUniform4fv(uniforms[UNIFORM_SPECULAR_COLOR], 1, GLKVector4Make(0.0f, 0.0f, 0.0f, 1.0f).v);
//        glUniform4fv(uniforms[UNIFORM_SPECULAR_COLOR], 1, GLKVector4Make(0.0f, 0.0f, 0.0f, 1.0f).v);
        glUniform4fv(uniforms[UNIFORM_SPECULAR_COLOR], 1, zero.v);
        glUniform4fv(uniforms[UNIFORM_AMBIENT_COLOR], 1, one.v);
        glUniform4fv(uniforms[UNIFORM_DIFFUSE_COLOR], 1, zero.v);
        glUniform4fv(uniforms[UNIFORM_SPECULAR_COLOR1], 1, zero.v);
        glUniform4fv(uniforms[UNIFORM_AMBIENT_COLOR1], 1, one.v);
        glUniform4fv(uniforms[UNIFORM_DIFFUSE_COLOR1], 1, zero.v);
        glUniform4fv(uniforms[UNIFORM_SPECULAR_COLORM], 1, one.v);
        glUniform4fv(uniforms[UNIFORM_AMBIENT_COLORM], 1, one.v);
        glUniform4fv(uniforms[UNIFORM_DIFFUSE_COLORM], 1, one.v);
        glUniform1i(uniforms[UNIFORM_FLAG], 0);
        glDrawElements(GL_TRIANGLE_STRIP, object.getIndexCount, GL_UNSIGNED_SHORT, 0);
    } else{
        glUniform4fv(uniforms[UNIFORM_SPECULAR_COLOR], 1, _specularColor.v);
        glUniform4fv(uniforms[UNIFORM_AMBIENT_COLOR], 1, _ambientColor.v);
        glUniform4fv(uniforms[UNIFORM_DIFFUSE_COLOR], 1, _diffuseColor.v);
        glUniform4fv(uniforms[UNIFORM_SPECULAR_COLOR1], 1, _specularColor1.v);
        glUniform4fv(uniforms[UNIFORM_AMBIENT_COLOR1], 1, _ambientColor1.v);
        glUniform4fv(uniforms[UNIFORM_DIFFUSE_COLOR1], 1, _diffuseColor1.v);
        glUniform4fv(uniforms[UNIFORM_SPECULAR_COLORM], 1, _specularColorm.v);
        glUniform4fv(uniforms[UNIFORM_AMBIENT_COLORM], 1, _ambientColorm.v);
        glUniform4fv(uniforms[UNIFORM_DIFFUSE_COLORM], 1, _diffuseColorm.v);
        glUniform1i(uniforms[UNIFORM_FLAG], 1);
        glDrawElements(GL_TRIANGLES, object.getIndexCount, GL_UNSIGNED_SHORT, 0);
    }
}

-(GLKVector3) getTransition{
    return _transition;
}

#pragma mark -  OpenGL ES 2 shader compilation

- (BOOL)loadShaders
{
    GLuint vertShader, fragShader;
    NSString *vertShaderPathname, *fragShaderPathname;
    
    // Create shader program.
    _program = glCreateProgram();
    
    // Create and compile vertex shader.
    vertShaderPathname = [[NSBundle mainBundle] pathForResource:@"Shader" ofType:@"vsh"];
    if (![self compileShader:&vertShader type:GL_VERTEX_SHADER file:vertShaderPathname]) {
        NSLog(@"Failed to compile vertex shader");
        return NO;
    }
    
    // Create and compile fragment shader.
    fragShaderPathname = [[NSBundle mainBundle] pathForResource:@"Shader" ofType:@"fsh"];
    if (![self compileShader:&fragShader type:GL_FRAGMENT_SHADER file:fragShaderPathname]) {

        NSLog(@"Failed to compile fragment shader");
            return NO;
    }
    
    // Attach vertex shader to program.
    glAttachShader(_program, vertShader);
    
    // Attach fragment shader to program.
    glAttachShader(_program, fragShader);
    
    // Bind attribute locations.
    // This needs to be done prior to linking.
    glBindAttribLocation(_program, GLKVertexAttribPosition, "position");
    glBindAttribLocation(_program, GLKVertexAttribNormal, "normal");
    glBindAttribLocation(_program, GLKVertexAttribTexCoord0, "texCoordIn");

    // Link program.
    if (![self linkProgram:_program]) {
        NSLog(@"Failed to link program: %d", _program);
        
        if (vertShader) {
            glDeleteShader(vertShader);
            vertShader = 0;
        }
        if (fragShader) {
            glDeleteShader(fragShader);
            fragShader = 0;
        }
        if (_program) {
            glDeleteProgram(_program);
            _program = 0;
        }
        
        return NO;
    }

    // Get uniform locations.
    uniforms[UNIFORM_MODELVIEWPROJECTION_MATRIX] = glGetUniformLocation(_program, "modelViewProjectionMatrix");
    uniforms[UNIFORM_NORMAL_MATRIX] = glGetUniformLocation(_program, "normalMatrix");
    uniforms[UNIFORM_HEIGHT]=glGetUniformLocation(_program,"height");
    uniforms[UNIFORM_RADIUS]=glGetUniformLocation(_program, "radius");
    //get position for the texture uniform used for multi texuture
    uniforms[UNIFORM_TEXTURE]=glGetUniformLocation(_program, "texture1");
    //get texture
    uniforms[UNIFORM_EYEPOINT]=glGetUniformLocation(_program, "eyePosition");
    //pass eye position into shader
    uniforms[UNIFORM_AMBIENT_COLOR]=glGetUniformLocation(_program, "ambientColor");
    uniforms[UNIFORM_SPECULAR_COLOR]=glGetUniformLocation(_program, "specularColor");
    uniforms[UNIFORM_DIFFUSE_COLOR]=glGetUniformLocation(_program, "diffuseColor");
    uniforms[UNIFORM_AMBIENT_COLOR1]=glGetUniformLocation(_program, "ambientColor1");
    uniforms[UNIFORM_SPECULAR_COLOR1]=glGetUniformLocation(_program, "specularColor1");
    uniforms[UNIFORM_DIFFUSE_COLOR1]=glGetUniformLocation(_program, "diffuseColor1");
    uniforms[UNIFORM_AMBIENT_COLORM]=glGetUniformLocation(_program, "ambientColorm");
    uniforms[UNIFORM_SPECULAR_COLORM]=glGetUniformLocation(_program, "specularColorm");
    uniforms[UNIFORM_DIFFUSE_COLORM]=glGetUniformLocation(_program, "diffuseColorm");
    uniforms[UNIFORM_CUBE]=glGetUniformLocation(_program, "textureCub");
    uniforms[UNIFORM_FLAG]=glGetUniformLocation(_program, "flag");
    uniforms[UNIFORM_FCUBE]=glGetUniformLocation(_program, "fcube");
    // Release vertex and fragment shaders.
    if (vertShader) {
        glDetachShader(_program, vertShader);
        glDeleteShader(vertShader);
    }
    if (fragShader) {
        glDetachShader(_program, fragShader);
        glDeleteShader(fragShader);
    }
    
    return YES;
}

- (BOOL)loadShaders1
{
    GLuint vertShader, fragShader;
    NSString *vertShaderPathname, *fragShaderPathname;
    
    // Create shader program.
    _program1 = glCreateProgram();
    
    // Create and compile vertex shader.
    vertShaderPathname = [[NSBundle mainBundle] pathForResource:@"Shaderno" ofType:@"vsh"];
    if (![self compileShader:&vertShader type:GL_VERTEX_SHADER file:vertShaderPathname]) {
        NSLog(@"Failed to compile vertex shader");
        return NO;
    }
    
    // Create and compile fragment shader.
    fragShaderPathname = [[NSBundle mainBundle] pathForResource:@"Shaderno" ofType:@"fsh"];
    if (![self compileShader:&fragShader type:GL_FRAGMENT_SHADER file:fragShaderPathname]) {
        
        NSLog(@"Failed to compile fragment shader");
        return NO;
    }
    
    // Attach vertex shader to program.
    glAttachShader(_program1, vertShader);
    
    // Attach fragment shader to program.
    glAttachShader(_program1, fragShader);
    
    // Bind attribute locations.
    // This needs to be done prior to linking.
    glBindAttribLocation(_program1, GLKVertexAttribPosition, "position");
    glBindAttribLocation(_program1, GLKVertexAttribNormal, "normal");
    glBindAttribLocation(_program1, GLKVertexAttribTexCoord0, "texCoordIn");
    
    // Link program.
    if (![self linkProgram:_program1]) {
        NSLog(@"Failed to link program: %d", _program1);
        
        if (vertShader) {
            glDeleteShader(vertShader);
            vertShader = 0;
        }
        if (fragShader) {
            glDeleteShader(fragShader);
            fragShader = 0;
        }
        if (_program1) {
            glDeleteProgram(_program1);
            _program1 = 0;
        }
        
        return NO;
    }
    
    // Get uniform locations.
    uniforms[UNIFORM_MODELVIEWPROJECTION_MATRIX] = glGetUniformLocation(_program1, "modelViewProjectionMatrix");
    uniforms[UNIFORM_NORMAL_MATRIX] = glGetUniformLocation(_program1, "normalMatrix");
    uniforms[UNIFORM_HEIGHT]=glGetUniformLocation(_program1,"height");
    uniforms[UNIFORM_RADIUS]=glGetUniformLocation(_program1, "radius");
    //get position for the texture uniform used for multi texuture
    uniforms[UNIFORM_TEXTURE]=glGetUniformLocation(_program1, "texture1");
    //get texture
    uniforms[UNIFORM_EYEPOINT]=glGetUniformLocation(_program1, "eyePosition");
    //pass eye position into shader
    uniforms[UNIFORM_AMBIENT_COLOR]=glGetUniformLocation(_program1, "ambientColor");
    uniforms[UNIFORM_SPECULAR_COLOR]=glGetUniformLocation(_program1, "specularColor");
    uniforms[UNIFORM_DIFFUSE_COLOR]=glGetUniformLocation(_program1, "diffuseColor");
    uniforms[UNIFORM_AMBIENT_COLOR1]=glGetUniformLocation(_program1, "ambientColor1");
    uniforms[UNIFORM_SPECULAR_COLOR1]=glGetUniformLocation(_program1, "specularColor1");
    uniforms[UNIFORM_DIFFUSE_COLOR1]=glGetUniformLocation(_program1, "diffuseColor1");
    uniforms[UNIFORM_AMBIENT_COLORM]=glGetUniformLocation(_program1, "ambientColorm");
    uniforms[UNIFORM_SPECULAR_COLORM]=glGetUniformLocation(_program1, "specularColorm");
    uniforms[UNIFORM_DIFFUSE_COLORM]=glGetUniformLocation(_program1, "diffuseColorm");
    uniforms[UNIFORM_CUBE]=glGetUniformLocation(_program1, "textureCub");
    uniforms[UNIFORM_FLAG]=glGetUniformLocation(_program1, "flag");
    uniforms[UNIFORM_FCUBE]=glGetUniformLocation(_program1, "fcube");
    // Release vertex and fragment shaders.
    if (vertShader) {
        glDetachShader(_program1, vertShader);
        glDeleteShader(vertShader);
    }
    if (fragShader) {
        glDetachShader(_program1, fragShader);
        glDeleteShader(fragShader);
    }
    
    return YES;
}



- (BOOL)compileShader:(GLuint *)shader type:(GLenum)type file:(NSString *)file
{
    GLint status;
    const GLchar *source;
    
    source = (GLchar *)[[NSString stringWithContentsOfFile:file encoding:NSUTF8StringEncoding error:nil] UTF8String];
    if (!source) {
        NSLog(@"Failed to load vertex shader");
        return NO;
    }    
    *shader = glCreateShader(type);
    glShaderSource(*shader, 1, &source, NULL);
    glCompileShader(*shader);
    
#if defined(DEBUG)
    GLint logLength;
    glGetShaderiv(*shader, GL_INFO_LOG_LENGTH, &logLength);
    if (logLength > 0) {
        GLchar *log = (GLchar *)malloc(logLength);
        glGetShaderInfoLog(*shader, logLength, &logLength, log);
        NSLog(@"Shader compile log:\n%s", log);
        free(log);
    }
#endif
    
    glGetShaderiv(*shader, GL_COMPILE_STATUS, &status);
    if (status == 0) {
        glDeleteShader(*shader);
        return NO;
    }
    
    return YES;
}

- (BOOL)linkProgram:(GLuint)prog
{
    GLint status;
    glLinkProgram(prog);
    
#if defined(DEBUG)
    GLint logLength;
    glGetProgramiv(prog, GL_INFO_LOG_LENGTH, &logLength);
    if (logLength > 0) {
        GLchar *log = (GLchar *)malloc(logLength);
        glGetProgramInfoLog(prog, logLength, &logLength, log);
        NSLog(@"Program link log:\n%s", log);
        free(log);
    }
#endif
    
    glGetProgramiv(prog, GL_LINK_STATUS, &status);
    if (status == 0) {
        return NO;
    }
    
    return YES;
}
/**
 *  used to test the correctness of the shader program
 **/
- (BOOL)validateProgram:(GLuint)prog
{
    GLint logLength, status;
    
    glValidateProgram(prog);
    glGetProgramiv(prog, GL_INFO_LOG_LENGTH, &logLength);
    if (logLength > 0) {
        GLchar *log = (GLchar *)malloc(logLength);
        glGetProgramInfoLog(prog, logLength, &logLength, log);
        NSLog(@"Program validate log:\n%s", log);
        free(log);
    }
    
    glGetProgramiv(prog, GL_VALIDATE_STATUS, &status);
    if (status == 0) {
        return NO;
    }
    
    return YES;
}

/**
 * convert the screen on touch to the world
 * imprecise
 */

/*-(GLKVector3)convertScreenToWorld:(CGPoint)pScreen
                      Perspective: (float)perspective
                          Pottery: (WTPottery *)pottery
                          Positon: (GLKVector3)potteryPositon
                           Camera:(GLKVector3) cameraPoint
                        CameraDir:(GLKVector3) cameraDir
                         distance:(float *)distance
{
    //compute the position of Xs and Ys
    CGSize size = self.view.frame.size;
    float height = tan(GLKMathDegreesToRadians(perspective/2.0f));
    float width = height*(float)size.width/(float)size.height;
    //let's assume distance from screen to eye is 1
    float xs = (pScreen.x - size.width/2.0f)/size.width*width*2.0f;
    float ys =  (size.height/2.0f - pScreen.y)/size.height*height*2.0f;
    //convert linear equation of the eye line is (tXs,tYs,t)=0 (t > 0)
    //calculate the nearest point on the pottery axis
    GLKVector3 pTouch = GLKVector3Make(xs,ys,-1.0f);
    GLKVector3 pPottery = GLKVector3Make(potteryPositon.x, 0.0f, potteryPositon.z);
    WTLine la,lb;
    la.pa = cameraPoint;
    la.pb = pTouch;
    //set the first line: eye line
    lb.pa = potteryPositon;
    lb.pb = pPottery;
    //calculate the rotation according to 
    WTUtility *utility = [[WTUtility alloc] init:la :lb];
    //calculate the distance and nearest point
    *distance = utility.getDistance;
    GLKVector3 point = utility.getNearestPoint;
    return point;
}*/


-(bool)findLevelSelected:(CGPoint)pScreen
             Perspective: (float)perspective
                 Pottery: (WTPottery *)pottery
                  Camera:(GLKVector3) cameraPoint
            TouchedLevel:(int *)touchedLevel
{
    //compute the position of Xs and Ys
    float distance;
    CGSize size = self.view.frame.size;
    float height = tan(GLKMathDegreesToRadians(perspective/2.0f));
    float width = height*(float)size.width/(float)size.height;
    //let's assume distance from screen to eye is 1
    float xs = (pScreen.x - size.width/2.0f)/size.width*width*2.0f;
    float ys =  (size.height/2.0f - pScreen.y)/size.height*height*2.0f;
    //convert linear equation of the eye line is (tXs,tYs,t)=0 (t > 0)
    //calculate the nearest point on the pottery axis
    GLKVector3 pTouch = GLKVector3Make(xs,ys,-1.0f);
//    GLKVector3 pPotteryTop = GLKVector3Make(potteryPositon.x, potteryPositon.y+pottery.getHeight*_scale.y, potteryPositon.z);
//    GLKVector3 pPotteryTop;
    WTLine la,lb;
    la.pa = cameraPoint;
    la.pb = pTouch;
    //set the first line: eye line
//    GLKMatrix3 m = GLKMatrix3MakeXRotation(GLKMathDegreesToRadians(cameraDir.x));
//    m = GLKMatrix3RotateY(m, GLKMathDegreesToRadians(cameraDir.y));
//    bool isInvertable;
//    m = GLKMatrix3Invert(m, &isInvertable);
    GLKVector4 pPotteryBottom = GLKVector4Make(0.0f, 0.0f, 0.0f,1.0f);
    GLKVector4 pPotteryTop = GLKVector4Make(0.0f, pottery.getHeight, 0.0f,1.0f);
    pPotteryBottom = GLKMatrix4MultiplyVector4(_modelViewMatrix, pPotteryBottom);
    pPotteryTop = GLKMatrix4MultiplyVector4(_modelViewMatrix, pPotteryTop);
    //rotate the pottery according to the camera dir
    lb.pa = GLKVector3Make(pPotteryBottom.x,pPotteryBottom.y,pPotteryBottom.z);
    lb.pb = GLKVector3Make(pPotteryTop.x,pPotteryTop.y,pPotteryTop.z);
    //set the second line: pottery axis
    WTUtility *utility = [[WTUtility alloc] init:la :lb];
    //calculate the distance and nearest point
    if ([utility isVertical]) {
//    if (true) {
        //if vertical
        //calculate the distance and nearest point
        distance = utility.getDistance;
        GLKVector3 point = utility.getNearestPoint;
        float d =  pottery.getHeight*_scale.y;
        if ([utility distance:point :lb.pa] > d || [utility distance:point :lb.pb] > d || distance > pottery.getBoundingBox.maxRadiusNow) {
//            NSLog(@"hahah, bug found");
            return false;
        }else{
            *touchedLevel = [utility distance:point :lb.pa]*pottery.getRadiusCount/d;
            return true;
        }        
    }else{
        float minDis = 1000000.0f;
        float t = pottery.getHeight*_scale.y/(float)pottery.getRadiusCount; //unit Heigt
        GLKVector3 normalV = GLKVector3Normalize(GLKVector3Subtract(lb.pb, lb.pa));
        GLKVector3 normalL = GLKVector3Subtract(la.pb, la.pa);
        GLKVector3 pp,pr;
        int level = -1;
        float *radius = pottery.getRadius;
        for (int i = 0; i < _pottery.getRadiusCount; i++) {
            pp = GLKVector3Add(lb.pa , GLKVector3MultiplyScalar(normalV, t*i));
            pr = [utility calPointOnPlane:pp :normalV :la.pa :normalL];
            float dp = [utility distance:pp :pr];
            float d1 = pottery.getBoundingBox.maxRadiusNow - dp; //larger than 0 if within Bounding Box
            float d = fabs(radius[i]*_scale.x - dp);//fixme not exact scale here after rotation
            if (d < minDis && d1 > 0 && pr.z > pp.z) {
                minDis = d;
                level = i;
            }
        }
        if (level == -1) {
            //not in the bounding box
            return false;
        }else{
            *touchedLevel = level;
            return true;
        }
    }
}

@end
