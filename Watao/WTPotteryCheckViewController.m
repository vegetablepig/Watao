//
//  WTPotteryCheckViewController.m
//  Watao
//
//  Created by 连 承亮 on 14-5-6.
//  Copyright (c) 2014年 连 承亮. All rights reserved.
//

#import "WTPotteryCheckViewController.h"
#import "WTAppDelegate.h"
#import "UMSocial.h"

@interface WTPotteryCheckViewController ()

@end

@implementation WTPotteryCheckViewController
@synthesize vSnapshot;
@synthesize frameBuffer;
@synthesize renderBuffer;
@synthesize depthBuffer;
@synthesize slider;
@synthesize u1;
@synthesize u11;
@synthesize u2;
@synthesize u21;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


//convert transition imprecisely to degree
- (IBAction)sliderchanged:(id)sender {
    WTAppDelegate *delegate = [[UIApplication sharedApplication] delegate];
    float Value = slider.value;
    
   // NSLog(@"Value:%f", Value);
    float height = [_pottery getHeight] * 8;
    float radius = [_pottery getMaxRadius] * 16;
    //NSLog(@"h: %f, r: %f", height/ 8.0, radius/16.0);
    if (Value - vv > 0.05 || vv - Value > 0.05) {
        vv = Value;
    [_pottery scale:((0.8+Value/2.5)-1)/2+1];//**
    }
    float heightnow = (int)(height*(0.8+Value/2.5));
    float radiusnow = (int)(radius*(0.8+Value/2.5));
    
    NSString *name;
    if ((int)heightnow < 10) {
        u1.image = nil;
        name = [NSString stringWithFormat:@"%d.png",(int)heightnow];
        u11.image = [delegate.imageManager getUIimg:name];
    }
    else {
        name = [NSString stringWithFormat:@"%d.png",(int)heightnow/10];
        u1.image = [delegate.imageManager getUIimg:name];
        name = [NSString stringWithFormat:@"%d.png",(int)heightnow%10];
        u11.image =[ delegate.imageManager getUIimg:name];
    }
    if ((int)radiusnow < 10) {
        u2.image = nil;
        name = [NSString stringWithFormat:@"%d.png",(int)radiusnow];
        u21.image = [delegate.imageManager getUIimg:name];
    }
    else {
        name = [NSString stringWithFormat:@"%d.png",(int)radiusnow/10];
        u2.image = [delegate.imageManager getUIimg:name];
        name = [NSString stringWithFormat:@"%d.png",(int)radiusnow%10];
        u21.image = [delegate.imageManager getUIimg:name];
    }
    delegate.tiji = (height*(0.8+Value/2.5))*(radius*(0.8+Value/2.5))*(radius*(0.8+Value/2.5))*M_PI/4.0;
    NSLog(@"tiji: %f %f", heightnow, radiusnow);
                                                                      
}

-(IBAction)changeViewPoint:(UIPanGestureRecognizer*)paramSender{
    if (paramSender.state == UIGestureRecognizerStateBegan || paramSender.state == UIGestureRecognizerStateChanged) {
        CGPoint translation = [paramSender translationInView:self.view];
        CGPoint location = [paramSender locationInView:self.view];
        int touchedLevel = -2;
        bool isOnPottery = [self findLevelSelected:location Perspective:_perspective Pottery:_pottery Camera:_cameraPoint TouchedLevel:&touchedLevel];
        if (isOnPottery) {
            _rotationRate = 0.0f;
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



- (void)viewDidLoad
{
    WTAppDelegate *delegate = [[UIApplication sharedApplication] delegate];
    NSLog(@"zipai : %d num : %d", delegate.zipai, delegate.texture);
    _ambientColor = GLKVector4Make(0.8f, 0.8f, 0.8f, 1.0f);//(0.4f, 0.4f, 0.4f, 1.0f);
    _specularColor = GLKVector4Make(0.7f, 0.7f, 0.7f, 1.0f);//(0.3f, 0.3f, 0.3f, 1.0f);
    _diffuseColor = GLKVector4Make(0.6f, 0.6f, 0.6f, 1.0f);//(0.6f, 0.6f, 0.6f, 1.0f);
    _ambientColor1 = GLKVector4Make(0.3f, 0.3f, 0.3f, 1.0f);//(0.4f, 0.4f, 0.4f, 1.0f);
    _specularColor1 = GLKVector4Make(0.0f, 0.0f, 0.0f, 1.0f);//(0.3f, 0.3f, 0.3f, 1.0f);
    _diffuseColor1 = GLKVector4Make(0.75f, 0.9f, 0.75f, 1.0f);//(0.6f, 0.6f, 0.6f, 1.0f);
    _ambientColorm = GLKVector4Make(0.5f, 0.6f, 0.6f, 1.0f);//(0.4f, 0.4f, 0.4f, 1.0f);
    _specularColorm = GLKVector4Make(0.7f, 0.7f, 0.7f, 1.0f);//(0.3f, 0.3f, 0.3f, 1.0f);
    _diffuseColorm = GLKVector4Make(0.5f, 0.5f, 0.5f, 1.0f);//(0.6f, 0.6f, 0.6f, 1.0f);
    _colFlag = false;
    vv = 0.5;
    super.isGravityTurnedOn = true;
    [super viewDidLoad];
    //
    [_background setupTexture:@"pottery_finished_activity_background.png"];
    [_pad setupTexture:@"finish_table.png"];
//    [_pottery setupTexture:@"t4.jpg"];
    //WTAppDelegate *delegate = [[UIApplication sharedApplication] delegate];
    delegate.finishtexture = [delegate.textureManager glToUIImage];
    _pottery.textureID = [delegate.textureManager convertToTexturenew:_pottery.textureID];
    [_shadow setupTexture:@"shadow.png"];
    _transition = GLKVector3Make(0.0f, -1.5f, -3.5f);//_transition = GLKVector3Make(0.0f, -1.0f, -4.0f);
    _rotationRate = 0.0;//0.2;
    _changeFlag = false;
    float height = [_pottery getHeight] * 8;
    float radius = [_pottery getMaxRadius] * 16;
    NSString *name;
    if ((int)height < 10) {
        u1.image = nil;
        name = [NSString stringWithFormat:@"%d.png",(int)height];
        u11.image = [delegate.imageManager getUIimg:name];
    }
    else {
        name = [NSString stringWithFormat:@"%d.png",(int)height/10];
        u1.image = [delegate.imageManager getUIimg:name];
        name = [NSString stringWithFormat:@"%d.png",(int)height%10];
        u11.image =[ delegate.imageManager getUIimg:name];
    }
    if ((int)radius < 10) {
        u2.image = nil;
        name = [NSString stringWithFormat:@"%d.png",(int)radius];
        u21.image = [delegate.imageManager getUIimg:name];
    }
    else {
        name = [NSString stringWithFormat:@"%d.png",(int)radius/10];
        u2.image = [delegate.imageManager getUIimg:name];
        name = [NSString stringWithFormat:@"%d.png",(int)radius%10];
        u21.image =[ delegate.imageManager getUIimg:name];
    }
    
    
    delegate.tiji = height*radius*radius*M_PI/4.0;
    //NSLog(@"height: %f; radius: %f", height, radius);
//    [self setUpNewRenderBuffer];
}


//TODO seperate pottery from render buffer 
-(void)setUpNewRenderBuffer{
    GLint backingWidth, backingHeight;
    GLint defaultFBO, defaultRBO;
    /*
    glGetIntegerv(GL_FRAMEBUFFER_BINDING_OES, &defaultFBO);
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

-(IBAction)saveIt:(id)sender{
    //get screenShot of the pottery now
    UIImage *image = [self snapshot:[self view]];
    vSnapshot.image = image;
    //NSData * data = UIImagePNGRepresentation(image);
    //[self saveImage:data];
    //[self getImage];
    //save the texture test
//    WTAppDelegate* delegate = [UIApplication sharedApplication].delegate;
//    [delegate.textureManager saveTextureToFile:@"savedImage.png"];
//    UIImageWriteToSavedPhotosAlbum( image, self, nil , nil );
//   [self getImage];
    ////
//    NSError *error;
//    NSFileManager *fileManager = [NSFileManager defaultManager];
//    NSString *resourcePath = [[NSBundle mainBundle] pathForResource:@"yanse" ofType:@"png"];
//    
//    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//    NSString *documentsDirectory = [paths objectAtIndex:0];
//    NSString *txtPath = [documentsDirectory stringByAppendingPathComponent:@"savedImage.png"];
//    [fileManager copyItemAtPath:txtPath toPath:resourcePath error:&error];
    ////
}

- (IBAction)share:(id)sender {
    UIImage *image = [self snapshot:[self view]];
    //NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    //    NSString *documentsDirectory = [paths objectAtIndex:0];
    //    NSString *txtPath = [documentsDirectory stringByAppendingPathComponent:@"savedImage.png"];
            [UMSocialSnsService presentSnsIconSheetView:self
                                         appKey:@"536b2cec56240bb2c3034993"
                                      shareText:@"image from watao"
                                     shareImage:image
                                shareToSnsNames:[NSArray arrayWithObjects:UMShareToSina,UMShareToTencent,UMShareToRenren,nil]
                                       delegate:nil];
}

-(void)getImage{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *savedImagePath = [documentsDirectory stringByAppendingPathComponent:@"savedImage.png"];
    vSnapshot.image = [UIImage imageWithContentsOfFile:savedImagePath];
}

- (void)saveImage:(NSData *)imageData {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *savedImagePath = [documentsDirectory stringByAppendingPathComponent:@"savedImage.png"];
    [imageData writeToFile:savedImagePath atomically:NO];
}


- (UIImage*)snapshot:(UIView*)eaglview{
    
    GLint backingWidth, backingHeight;
    
    // Bind the color renderbuffer used to render the OpenGL ES view
    // If your application only creates a single color renderbuffer which is already bound at this point,
    // this call is redundant, but it is needed if you're dealing with multiple renderbuffers.
    // Note, replace "_colorRenderbuffer" with the actual name of the renderbuffer object defined in your class.
    GLint defaultRBO;
    glGetIntegerv(GL_RENDERBUFFER_BINDING, &defaultRBO);
    glBindRenderbuffer(GL_RENDERBUFFER, defaultRBO);
    
    // Get the size of the backing CAEAGLLayer
    glGetRenderbufferParameteriv(GL_RENDERBUFFER, GL_RENDERBUFFER_WIDTH, &backingWidth);
    glGetRenderbufferParameteriv(GL_RENDERBUFFER, GL_RENDERBUFFER_HEIGHT, &backingHeight);
    NSInteger x = 0, y = 0, width = backingWidth, height = backingHeight;
    NSInteger dataLength = width * height * 4;
    GLubyte *data = (GLubyte*)malloc(dataLength * sizeof(GLubyte));
    // Read pixel data from the framebuffer
    glPixelStorei(GL_PACK_ALIGNMENT, 4);
    glReadPixels(x, y, width, height, GL_RGBA, GL_UNSIGNED_BYTE, data);
    
    // Create a CGImage with the pixel data
    // If your OpenGL ES content is opaque, use kCGImageAlphaNoneSkipLast to ignore the alpha channel
    // otherwise, use kCGImageAlphaPremultipliedLast
    
    CGDataProviderRef ref = CGDataProviderCreateWithData(NULL, data, dataLength, NULL);
    CGColorSpaceRef colorspace = CGColorSpaceCreateDeviceRGB();
    CGImageRef iref = CGImageCreate(width, height, 8, 32, width * 4, colorspace, kCGBitmapByteOrder32Big | kCGImageAlphaPremultipliedLast,
                                    ref, NULL, true, kCGRenderingIntentDefault);
    // OpenGL ES measures data in PIXELS
    // Create a graphics context with the target size measured in POINTS
    
    NSInteger widthInPoints, heightInPoints;
    if (NULL != UIGraphicsBeginImageContextWithOptions) {
        // On iOS 4 and later, use UIGraphicsBeginImageContextWithOptions to take the scale into consideration
        // Set the scale parameter to your OpenGL ES view's contentScaleFactor
        // so that you get a high-resolution snapshot when its value is greater than 1.0
        CGFloat scale = eaglview.contentScaleFactor;
        widthInPoints = width / scale;
        heightInPoints = height / scale;
        UIGraphicsBeginImageContextWithOptions(CGSizeMake(widthInPoints, heightInPoints), NO, scale);
    }
    else {
        // On iOS prior to 4, fall back to use UIGraphicsBeginImageContext
        widthInPoints = width;
        heightInPoints = height;
        UIGraphicsBeginImageContext(CGSizeMake(widthInPoints, heightInPoints));
    }
    CGContextRef cgcontext = UIGraphicsGetCurrentContext();
    // UIKit coordinate system is upside down to GL/Quartz coordinate system
    // Flip the CGImage by rendering it to the flipped bitmap context
    // The size of the destination area is measured in POINTS
    CGContextSetBlendMode(cgcontext, kCGBlendModeCopy);
    CGContextDrawImage(cgcontext, CGRectMake(0.0, 0.0, widthInPoints, heightInPoints), iref);
    
    // Retrieve the UIImage from the current context
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    // Clean up
    free(data);
    CFRelease(ref);
    CFRelease(colorspace);
    CGImageRelease(iref);
    
    return image; 
}
- (IBAction)col:(id)sender {
    /*WTAppDelegate *myDelegate = [[UIApplication sharedApplication] delegate];
    [_pottery saveToFile:@"temp1.wt"]; //save the shape
    [myDelegate.config setObject:@"true" forKey:@"isPotterySaved"];
    [myDelegate.textureManager saveTextureToFile:@"savedTexture1.png"];
    [myDelegate.config setObject:@"true" forKey:@"isTextureSaved"];
    //    NSString *path = [[NSBundle mainBundle] pathForResource:@"config" ofType:@"plist"];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docDir = [paths objectAtIndex: 0];
    NSString* docFile = [docDir stringByAppendingPathComponent: @"config.plist"];
    [myDelegate.config writeToFile:docFile atomically:YES];
    */
    //UIImage *snapshot;
    /**CGImageRef cgScreen = UIGetScreenImage();
    if (cgScreen) {
        snapshot = [UIImage imageWithCGImage:cgScreen];
        CGImageRelease(cgScreen);
    }*/
    //CGRect rect = CGRectMake(0,0, 640, 750);//创建要剪切的矩形框 这里你可以自己修改
    //UIImage *res = [UIImage imageWithCGImage:CGImageCreateWithImageInRect([snapshot CGImage], rect)];
    //UIImageWriteToSavedPhotosAlbum(snapshot, nil, nil, nil);[pottery saveToFile:@"temp.wt"]; //save the shape
    NSString *message = @"收藏成功";
    
    WTAppDelegate *delegate = [[UIApplication sharedApplication] delegate];
        //int i = delegate.Id;
    delegate.total = 0;
    if (_colFlag == false){
        //save it
        NSString *textname = [[@"savedTexture" stringByAppendingString:[NSString stringWithFormat:@"%d",delegate.total+1]] stringByAppendingString:@".png"];
        NSString *wtname = [[@"savedWt" stringByAppendingString:[NSString stringWithFormat:@"%d",delegate.total+1]] stringByAppendingString:@".wt"];
        
        [delegate collect];

        [_pottery saveToFile:wtname]; //save the shape
        [delegate.textureManager saveTextureToFile:textname];
        [delegate.textureManager savescreenshoot:delegate.finishimage];
        //alert message
        
        _colFlag = true;
    } else{
        message = @"取消收藏";
        //delete it
        /*delegate.id = ;
        NSString *str = [config objectForKey:@"isPotterySaved"];
        delegate*/
        _colFlag = false;
    }
    
    UIView *showview =  [[UIView alloc]init];
    UIWindow * window = [UIApplication sharedApplication].keyWindow;
    showview.backgroundColor = [UIColor blackColor];
    showview.frame = CGRectMake(1, 1, 1, 1);
    showview.alpha = 1.0f;
    showview.layer.cornerRadius = 5.0f;
    showview.layer.masksToBounds = YES;
    [window addSubview:showview];
    UILabel *label = [[UILabel alloc]init];
    CGSize LabelSize = [message sizeWithFont:[UIFont systemFontOfSize:17] constrainedToSize:CGSizeMake(290, 9000)];
    label.frame = CGRectMake(10, 5, LabelSize.width, LabelSize.height);
    label.text = message;
    label.textColor = [UIColor whiteColor];
    label.textAlignment = 1;
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont boldSystemFontOfSize:15];
    [showview addSubview:label];
    showview.frame = CGRectMake((720 - LabelSize.width - 20) - 80, 330, LabelSize.width+20, LabelSize.height+10);
    [UIView animateWithDuration:1.5 animations:^{
        showview.alpha = 0;
    } completion:^(BOOL finished) {
        [showview removeFromSuperview];
    }];
    
    //_pottery.textureID = [delegate.textureManager convertToTexture:_pottery.textureID];
    /*[config setObject:@"true" forKey:@"isPotterySaved"];
    
    [textureManager saveTextureToFile:@"savedTexture.png"];
    [config setObject:@"true" forKey:@"isTextureSaved"];
    //    NSString *path = [[NSBundle mainBundle] pathForResource:@"config" ofType:@"plist"];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docDir = [paths objectAtIndex: 0];
    NSString* docFile = [docDir stringByAppendingPathComponent: @"config.plist"];
    [config writeToFile:docFile atomically:YES];
    //输入写入
    //
    //    //那怎么证明我的数据写入了呢？读出来看看
    NSMutableDictionary *data1 = [[NSMutableDictionary alloc] initWithContentsOfFile:docFile];
    NSLog(@"%@", data1);
    NSLog(@"%@",config);*/
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
    _modelViewMatrix = [_pottery moveRotateX: _rotation rotatex: _rotationx scale: _scale translate:translate base:baseModelViewMatrix project: projectionMatrix]; //save the modelView Matrix in order to judge point touch
    //scale = GLKVector3Make(0.15f, 0.002f, 0.15f);
    translate = GLKVector3Make(0.0f, -1.0f*_scale.y*_pad.getHeight, 0.0f);
    [_pad moveRotateX:_rotation rotatex: _rotationx scale:_scale translate:translate base:baseModelViewMatrix project:projectionMatrix];
    float rBottom = _pottery.getRadius[0];
    float rInit = _pottery.initRadius;
    float s = 1.0f/rInit*rBottom;
    [_shadow moveRotateX:GLKMathDegreesToRadians(170.0f) rotatex: _rotationx scale:GLKVector3MultiplyScalar(_scale, s) translate:translate base:baseModelViewMatrix project:projectionMatrix];
    baseModelViewMatrix = GLKMatrix4MakeTranslation(0.0f, -4.5f, -15.0f);
    baseModelViewMatrix = GLKMatrix4Multiply(baseModelViewMatrix, invMat);
    [_background moveRotate:GLKMathDegreesToRadians(0.0f) scale:GLKVector3Make(3.3f, 1.3f, 0.5f) translate:translate base:baseModelViewMatrix project:projectionMatrix];
    
    //[_pottery moveRotateX: _rotationx scale: _scale translate:translate base:baseModelViewMatrix project: projectionMatrix];
    //[_pad moveRotateX:_rotationx scale:_scale translate:translate base:baseModelViewMatrix project:projectionMatrix];
    
    _rotation += self.timeSinceLastUpdate * _rotationRate;
    
}

- (void)viewDidUnload {
    [self setBSave:nil];
    [self setVSnapshot:nil];
    [super viewDidUnload];
}

/*
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
    if (([self.view window] == nil)) {
        //nPottery= nil;
        //transform the model world according to gravity
    }
    // Dispose of any resources that can be recreated.
}
*/

@end
