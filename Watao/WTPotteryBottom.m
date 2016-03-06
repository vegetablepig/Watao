//
//  WTCollectionViewController.c
//  Watao
//
//  Created by fc on 14-8-21.
//  Copyright (c) 2014年 连 承亮. All rights reserved.
//

#import "WTPotteryBottom.h"
#import "WTTexutureManager.h"
#import "WTAppDelegate.h"
#import "WTFontTexture.h"

@implementation WTPotteryBottom

@synthesize texcube;
@synthesize flashflag;
@synthesize type;
@synthesize selection;

- (IBAction)t1:(id)sender {
    if (type != 1) {type = 1;selection = 1;[self updateview];}
}
- (IBAction)t2:(id)sender {
    if (type != 2) {type = 2;selection = 1;[self updateview];}
}
- (IBAction)t3:(id)sender {
    if (type != 3) {type = 3;selection = 1;[self updateview];}
}
- (IBAction)c1:(id)sender {
    selection = 1; [self updateview];
}
- (IBAction)c2:(id)sender {
    selection = 2;[self updateview];
}
- (IBAction)c3:(id)sender {
    selection = 3;[self updateview];
}
- (IBAction)c4:(id)sender {
    selection = 4;[self updateview];
}
- (IBAction)c5:(id)sender {
    selection = 5;[self updateview];
}

- (void) updateview{
    switch (type) {
        case 1:
            break;
        case 2:
            break;
        case 3:
            break;
    }
}

- (void)viewDidLoad
{
    type = 1;
    selection = 2;
    
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
    [super viewDidLoad];
    [_background setupTexture:@"decorate_background.png"];
    [_bottom setupTexture:@"procelainb.png"];
    //    [_pottery setupTexture:@"t4.jpg"];
    //WTAppDelegate *delegate = [[UIApplication sharedApplication] delegate];
    //_pottery.textureID = [delegate.textureManager convertToTexturenew:_pottery.textureID];
    //[_shadow setupTexture:@"shadow.png"];
    _transition = GLKVector3Make(0.0f, -1.5f, -3.5f);//_transition = GLKVector3Make(0.0f, -1.0f, -4.0f);
    //_rotationRate = 0.2;
    //_changeFlag = false;
    //    [self setUpNewRenderBuffer];
    
    //[self screenshot];
}

- (void)setupGL
{
    [EAGLContext setCurrentContext:self.context];
    //set context as the current context
    [self loadShaders];
    //[self loadShaders1];
    
    //[self CreateSimpleTextureCubemap];
    glEnable(GL_DEPTH_TEST);
    /////////////////////////////////
    //[self setupGLfor:VERTEX_ARRAY_POTTERY :VERTEX_BUFFER_POTTERY :INDEX_BUFFER_POTTERY :_pottery];
    //setUp the state of the pottery
    /////////////////////////////////
    //set up the vertex array objects
    
    //setUp the state of the pad
    /////////////////////////////////
    [self setupGLfor:VERTEX_ARRAY_BACKGROUND :VERTEX_BUFFER_BACKGROUND :INDEX_BUFFER_BACKGROUND :_background];
    //set up the background
    /////////////////////////////////
    [self setupGLfor:VERTEX_ARRAY_PAD :VERTEX_BUFFER_PAD :INDEX_BUFFER_PAD :_bottom];
    //set up the shadow
}

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
    
    //[self drawObeject:_pottery :VERTEX_ARRAY_POTTERY];
    //draw pottery
    
    //glUseProgram(_program1);
    ////////////////////////////////////////
    //[self drawObeject:_pad :VERTEX_ARRAY_PAD];
    //draw pad
    /////////////////////////////////////////
    [self drawObeject:_background :VERTEX_ARRAY_BACKGROUND];
    //draw background
    ////////////////////////////////////////
    [self drawObeject:_bottom :VERTEX_ARRAY_PAD];

    
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
    if (vertexArrayID == VERTEX_ARRAY_BACKGROUND) {
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
        glDrawElements(GL_TRIANGLE_FAN, object.getIndexCount, GL_UNSIGNED_SHORT, 0);
    }
}



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
    //scale = GLKVector3Make(0.15f, 0.002f, 0.15f);
    translate = GLKVector3Make(0.0f, 1.0f, 0.0f);
    //[_bottom moveRotateX:_rotation rotatex: -1.5707f scale:GLKVector3Make(0.5f, 0.05f, 0.5f) translate:translate base:baseModelViewMatrix project:projectionMatrix];
    float rBottom = _pottery.getRadius[0];
    float rInit = _pottery.initRadius;
    float s = 1.0f/rInit*rBottom;
        baseModelViewMatrix = GLKMatrix4MakeTranslation(0.0f, -4.5f, -15.0f);
    baseModelViewMatrix = GLKMatrix4Multiply(baseModelViewMatrix, invMat);
    [_background moveRotate:GLKMathDegreesToRadians(0.0f) scale:GLKVector3Make(3.3f, 1.3f, 0.5f) translate:GLKVector3Make(0.0f, 0.0f, 0.0f) base:baseModelViewMatrix project:projectionMatrix];
    //_rotation += self.timeSinceLastUpdate * _rotationRate;
    
}

-(IBAction)changeViewPoint:(UIPanGestureRecognizer*)paramSender{
    if (paramSender.state == UIGestureRecognizerStateBegan || paramSender.state == UIGestureRecognizerStateChanged) {
        CGPoint translation = [paramSender translationInView:self.view];
        CGPoint location = [paramSender locationInView:self.view];
        int touchedLevel = -2;
        //bool isOnPottery = [self findLevelSelected:location Perspective:_perspective Pottery:_pottery Camera:_cameraPoint TouchedLevel:&touchedLevel];
        if (true) {
            _rotation += translation.x/100.0f;
            if (_rotationx + translation.y/100.0f < 0.3f && _rotationx + translation.y/100.0f > -0.5f)
                _rotationx += translation.y/100.0f;
            //_viewPointNow.y += translation.y/1000.0f;
        }else{
            //_rotationRate = 0.2f;
        }
    }else{
        //_rotationRate = 0.2f;
    }
    [paramSender setTranslation:CGPointMake(0, 0) inView:self.view];
}

- (GLuint) CreateSimpleTextureCubemap
{
    GLuint textureId;
    // Generate a texture object
    glGenTextures ( 1, &textureId );
    
    // Bind the texture object
    glBindTexture ( GL_TEXTURE_CUBE_MAP, textureId );
    WTAppDelegate *delegate = [[UIApplication sharedApplication] delegate];
    UIImage *image = [delegate.imageManager getUIimg: @"light.jpg"];
    //image = [image resizableImageWithCapInsets:UIEdgeInsetsZero resizingMode:UIImageResizingModeTile];
    image = [self resizeImage:image toSize:CGSizeMake((GLfloat)1024, (GLfloat)1024)];//image.size.width)];
    CGImageRef spriteImage = image.CGImage;
    if (!spriteImage) {
        NSLog(@"Failed to load image light.jpg");
        exit(1);
    }     // 2
    GLsizei width = CGImageGetWidth(spriteImage);
    GLsizei height = CGImageGetWidth(spriteImage);
    GLubyte * spriteData = (GLubyte *) calloc(width*height*4, sizeof(GLubyte));
    CGContextRef spriteContext = CGBitmapContextCreate(spriteData, width, height, 8, width*4,CGImageGetColorSpace(spriteImage), kCGImageAlphaPremultipliedLast);         // 3
    CGContextDrawImage(spriteContext, CGRectMake(0, 0, width, height), spriteImage);
    CGContextRelease(spriteContext);     // 4
    
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
    return textureId;
}


- (BOOL)loadShaders
{
    GLuint vertShader, fragShader;
    NSString *vertShaderPathname, *fragShaderPathname;
    
    // Create shader program.
    _program = glCreateProgram();
    
    // Create and compile vertex shader.
    vertShaderPathname = [[NSBundle mainBundle] pathForResource:@"ShaderTexture" ofType:@"vsh"];
    if (![self compileShader:&vertShader type:GL_VERTEX_SHADER file:vertShaderPathname]) {
        NSLog(@"Failed to compile vertex shader");
        return NO;
    }
    
    // Create and compile fragment shader.
    fragShaderPathname = [[NSBundle mainBundle] pathForResource:@"ShaderTexture" ofType:@"fsh"];
    if (![self compileShader:&fragShader type:GL_FRAGMENT_SHADER file:fragShaderPathname]) {
        /*int compiled[1];
         GLchar aa[100];
         GLsizei s[10];
         s[0] = 100;
         glGetShaderiv(fragShader, GL_COMPILE_STATUS, compiled);
         if (compiled[0] == 0) {//若编译失败则显示错误日志并删除此shader
         //NSLog(@"ES20_ERROR", "Could not compile shader " + shaderType + ":");
         glGetShaderInfoLog(fragShader,100, NULL,aa);
         NSLog(@"ES20_ERROR: %s",aa);
         
         //GLES20.glDeleteShader(shader);
         //shader = 0;*/
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


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
    if (([self.view window] == nil)) {
        //transform the model world according to gravity
    }
    // Dispose of any resources that can be recreated.
}

@end