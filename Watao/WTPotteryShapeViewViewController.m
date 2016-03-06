//
//  WTPotteryShapeViewViewController.m
//  Watao
//
//  Created by 连 承亮 on 14-3-23.
//  Copyright (c) 2014年 连 承亮. All rights reserved.
//

#import "WTPotteryShapeViewViewController.h"
#import "WTAppDelegate.h"

@interface WTPotteryShapeViewViewController ()

@end

@implementation WTPotteryShapeViewViewController


@synthesize start;
@synthesize fare;
@synthesize account;
@synthesize info;
@synthesize attachTex;
@synthesize imgLogo;
@synthesize line;
//@synthesize gridBackground;
@synthesize home;
@synthesize classicShape;
@synthesize clear;
@synthesize operatingBar;
@synthesize classicalPotteryChoosen;
//@synthesize chooseFrame1;
//@synthesize chooseFrame2;
//@synthesize chooseFrame3;
//@synthesize chooseFrame4;
//@synthesize chooseFrame5;
//@synthesize chooseFrame6;
//@synthesize chooseFrame7;
//@synthesize chooseFrame8;
@synthesize shelf;
@synthesize bCP1;
@synthesize bCP2;
@synthesize bCP3;
@synthesize bCP4;
@synthesize bCP5;
@synthesize bCP6;
@synthesize bCP7;
@synthesize bCP8;
@synthesize bCP9;
@synthesize bNo;
@synthesize bYes;
@synthesize isChoosingClassical;
@synthesize test;
@synthesize texcube;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


- (BOOL)loadShaders
{
    GLuint vertShader, fragShader;
    NSString *vertShaderPathname, *fragShaderPathname;
    
    // Create shader program.
    _program = glCreateProgram();
    
    // Create and compile vertex shader.
    vertShaderPathname = [[NSBundle mainBundle] pathForResource:@"ShaderShape" ofType:@"vsh"];
    if (![self compileShader:&vertShader type:GL_VERTEX_SHADER file:vertShaderPathname]) {
        NSLog(@"Failed to compile vertex shader");
        return NO;
    }
    
    // Create and compile fragment shader.
    fragShaderPathname = [[NSBundle mainBundle] pathForResource:@"ShaderShape" ofType:@"fsh"];
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

/*-(void) save_user{
    NSString *uuid = [[[[UIDevice currentDevice] identifierForVendor] UUIDString] substringWithRange:NSMakeRange(0, 15)];
    NSLog(@"ID:%@", uuid);
    
    NSURL *url = [NSURL URLWithString:@"http://watao-test.jian-yin.com/index.php/webservices/save_user"];
    NSString *boundary = @"iOS_BOUNDARY_STRING";
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@", boundary];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"POST"];
    [request addValue:contentType forHTTPHeaderField:@"Content-Type"];
    
    NSMutableData *body = [NSMutableData data];
    
    /*[body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"; filename=\"test.png\"\r\n", @"image"] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[@"Content-Type: application/octet-stream\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[NSData dataWithData:UIImagePNGRepresentation([delegate.imageManager getUIimg:@"clay.png"])]];
 
    NSMutableDictionary *form =[NSMutableDictionary dictionaryWithCapacity:10];
    
    [form setObject:uuid forKey:@"username"];
    [form setObject:@"wataoios" forKey:@"password"];
    [form setObject:@"1" forKey:@"gender"];
    [form setObject:@"cairf888@126.com" forKey:@"email"];
    [form setObject:@"13757126026" forKey:@"phone_number"];
    [form setObject:@"浙江大学蒙民伟楼306-2" forKey:@"address"];
    
     for (NSString*key in [form allKeys]) {
     NSLog(@"%@ - %@",key,[form objectForKey:key]);
     NSString *value = [form objectForKey:key];
     [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
     [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n%@",key, value] dataUsingEncoding:NSUTF8StringEncoding]];
     }
    
    [body appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [request setHTTPBody:body];
    NSURLConnection *urlConnection = [NSURLConnection connectionWithRequest:request delegate:self];
    [urlConnection start];
}

- (void) save_order{
    NSString *uuid = [[[[UIDevice currentDevice] identifierForVendor] UUIDString] substringWithRange:NSMakeRange(0, 15)];
    NSLog(@"ID:%@", uuid);
    
    NSURL *url = [NSURL URLWithString:@"http://watao-test.jian-yin.com/index.php/webservices/save_order"];
    NSString *boundary = @"iOS_BOUNDARY_STRING";
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@", boundary];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"POST"];
    [request addValue:contentType forHTTPHeaderField:@"Content-Type"];
    
    NSMutableData *body = [NSMutableData data];
    
    [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
     [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"; filename=\"test.png\"\r\n", @"image_decorator"] dataUsingEncoding:NSUTF8StringEncoding]];
     [body appendData:[@"Content-Type: application/octet-stream\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
     [body appendData:[NSData dataWithData:UIImagePNGRepresentation([delegate.imageManager getUIimg:@"clay.png"])]];
    
    [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"; filename=\"test.png\"\r\n", @"image"] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[@"Content-Type: application/octet-stream\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[NSData dataWithData:UIImagePNGRepresentation([delegate.imageManager getUIimg:@"clay.png"])]];
    
    NSMutableDictionary *form =[NSMutableDictionary dictionaryWithCapacity:10];
    
    [form setObject:uuid forKey:@"username"];
    [form setObject:@"wataoios" forKey:@"order_number"];
    [form setObject:@"1" forKey:@"agree_post_to_market"];
    [form setObject:@"0.1" forKey:@"price"];
    [form setObject:@"test" forKey:@"name"];
    [form setObject:@"13757126026" forKey:@"phone"];
    [form setObject:@"浙江大学蒙民伟楼306-2" forKey:@"address"];

    
    for (NSString*key in [form allKeys]) {
        NSLog(@"%@ - %@",key,[form objectForKey:key]);
        NSString *value = [form objectForKey:key];
        [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n%@",key, value] dataUsingEncoding:NSUTF8StringEncoding]];
    }
    
    [body appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [request setHTTPBody:body];
    NSURLConnection *urlConnection = [NSURLConnection connectionWithRequest:request delegate:self];
    [urlConnection start];

    
}*/

- (IBAction)test:(id)sender {
    //[self save_order];
    /*
    NSDate *now = [NSDate date];
    NSLog(@"now date is: %@", now);
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSUInteger unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
   NSDateComponents *dateComponent = [calendar components:unitFlags fromDate:now];

    int year = [dateComponent year];
    int month = [dateComponent month];
     int day = [dateComponent day];
  int hour = [dateComponent hour];
    int minute = [dateComponent minute];
    int second = [dateComponent second];

    NSLog(@"year is: %d", year);
   NSLog(@"month is: %d", month);
   NSLog(@"day is: %d", day);
  NSLog(@"hour is: %d", hour);
    NSLog(@"minute is: %d", minute);
     NSLog(@"second is: %d", second);
    

    NSURL *url = [NSURL URLWithString:@"http://watao-test.jian-yin.com/index.php/webservices/image_upload"];
    NSString *boundary = @"iOS_BOUNDARY_STRING";
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@", boundary];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"POST"];
    [request addValue:contentType forHTTPHeaderField:@"Content-Type"];
    
    NSMutableData *body = [NSMutableData data];
    
    [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"; filename=\"test.png\"\r\n", @"image"] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[@"Content-Type: application/octet-stream\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[NSData dataWithData:UIImagePNGRepresentation([delegate.imageManager getUIimg:@"clay.png"])]];
    
    
    [body appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [request setHTTPBody:body];
    NSURLConnection *urlConnection = [NSURLConnection connectionWithRequest:request delegate:self];
    [urlConnection start];
    /*NSMutableURLRequest    *urlRequest = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReturnCacheDataElseLoad timeoutInterval:30];
    
    NSString *postStr = [[NSString alloc] initWithFormat:@"name=%@&psw=%@",@"admin",@"admin"];
    NSData *postData = [postStr dataUsingEncoding:NSUTF8StringEncoding];
    [urlRequest setHTTPMethod:@"POST"];
    //[urlRequest setHTTPBody:postData];
    //[urlRequest setHTTPBodyStream:<#(NSInputStream *)#>];
    
    NSURLConnection *urlConnection = [NSURLConnection connectionWithRequest:urlRequest delegate:self];
    [urlConnection start];
    
    */
    /*
    NSMutableURLRequest *req = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:upload_image]
                                                            cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                        timeoutInterval:60.0];
    // 定义boundary
    NSString *boundary = @"----Boundary+WhateverYouLikeToPutInHere----datatata--done";
    // 使用POST方法
    [req setHTTPMethod:@"POST"];
    // 设置Content-Type
    [req setValue:[NSString stringWithFormat:@"multipart/form-data; boundary=%@", boundary, nil] forHTTPHeaderField:@"Content-Type"];
    
    // 把图片变成data。
    UIImage *theImage = delegate.finishimage;
    //NSBitmapImageRep *bitmap = [[theImage representations] objectAtIndex:0];
    NSData *imageData = [NSData dataWithData:UIImagePNGRepresentation(theImage)];
    
    // 需要POST的键值对
    NSMutableDictionary *values = [NSMutableDictionary dictionaryWithCapacity:10];
               
    [values setObject:imageData forKey:@"image"];
                            //NSDictionary dictionaryWithObjectsAndKeys:[messageField string], @"status", imageData, @"photo", nil];
    
    // 初始化POST Data
    NSMutableData *d = [NSMutableData data];
    
    // 遍历键值对，将其转换成NSData
    for (NSString *key in [values allKeys]) {
        
        // Append一个Boundary
        [d appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        
        id currentValue = [values objectForKey:key];
        
        if( [currentValue isKindOfClass:[NSData class]] ) {
            // 如果是图片对象的处理方法。
            // 设置Content-Disposition，这里设置图片对应的key的名字
            [d appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"; filename=\"image.png\"\r\n", key]
                           dataUsingEncoding:NSUTF8StringEncoding]];
            // 设置图片的Content-Type
            [d appendData:[@"Content-Type: image/png\r\n" dataUsingEncoding:NSASCIIStringEncoding]];
            // 设置传输编码为二进制
            [d appendData:[@"Content-Transfer-Encoding: binary\r\n\r\n" dataUsingEncoding:NSASCIIStringEncoding]];
            // Append图片
            [d appendData:currentValue];
        }
        else {
            // 字符串值的处理方法
            // Append一个Boundary
            [d appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
            // 设置字符串键
            [d appendData:[@"Content-Disposition: form-data; name=\"status\"\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
            // 设置字符串值
            [d appendData:[[NSString stringWithFormat:@"%@", currentValue] dataUsingEncoding:NSUTF8StringEncoding]];
        }
    }
    // 最后Append一个Boundary
    [d appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    // 设置数据为请求的Body
    [req setHTTPBody:d];
    [req ]*/
     /*NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
     
     request.HTTPMethod = @"POST";

     [fileURLs enumerateObjectsUsingBlock:^(NSURL *fileURL, NSUInteger idx, BOOL *stop) {
     NSString *bodyStr = [NSString stringWithFormat:@"\n--%@\n", boundary];
     [data appendData:[bodyStr dataUsingEncoding:NSUTF8StringEncoding]];
     
     NSString *fileName = fileNames[idx];
     bodyStr = [NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"; filename=\"%@\" \n", name, fileName];
     [data appendData:[bodyStr dataUsingEncoding:NSUTF8StringEncoding]];
     [data appendData:[@"Content-Type: application/octet-stream\n\n" dataUsingEncoding:NSUTF8StringEncoding]];
     
     [data appendData:[NSData dataWithContentsOfURL:fileURL]];
     
     [data appendData:[@"\n" dataUsingEncoding:NSUTF8StringEncoding]];
     }];
     
     NSString *tailStr = [NSString stringWithFormat:@"--%@--\n", boundary];
     [data appendData:[tailStr dataUsingEncoding:NSUTF8StringEncoding]];
     
     request.HTTPBody = data;
     
     NSString *headerString = [NSString stringWithFormat:@"multipart/form-data; boundary=%@", boundary];
     [request setValue:headerString forHTTPHeaderField:@"Content-Type"];
     
*/
    
}


- (void)viewDidLoad
{
    super.isGravityTurnedOn = true;
    [super viewDidLoad];
    WTAppDelegate *delegate = [[UIApplication sharedApplication] delegate];
    delegate.textureManager.zipai = nil;
    delegate.attatchTexMode = WT_MODE_YANSE;
    //load the given texture
    t1 = [_background setupTexture:@"main_activity_background.png"];//main_activity_background.png"];
    t2 = [_pad setupTexture:@"table.png"];
    [_pottery setupTexture:@"clay.png"];
    //delegate.textureManager = [[WTTexutureManager alloc] init:@"clay.png"];
    //WTTexutureManager *_textureManager = delegate.textureManager;
    [delegate.textureManager clearTexture:@"clay.png"];
    [delegate.textureManager backupImgData];
    [delegate.textureManager backupImgData2];
    [delegate.textureManager backupImgData3];
    delegate.zipai = 0;
    //_pottery.textureID = [delegate.textureManager convertToTexturenew:_pottery.textureID];
    t4 = _pottery.textureID;
    
    t3 = [_shadow setupTexture:@"shadow.png"];

    _ambientColor = GLKVector4Make(0.3f, 0.3f, 0.3f, 1.0f);//(0.4f, 0.4f, 0.4f, 1.0f);
    _specularColor = GLKVector4Make(0.7f, 0.7f, 0.7f, 1.0f);//(0.3f, 0.3f, 0.3f, 1.0f);
    _diffuseColor = GLKVector4Make(0.6f, 0.6f, 0.6f, 1.0f);//(0.6f, 0.6f, 0.6f, 1.0f);
    _ambientColor1 = GLKVector4Make(0.3f, 0.3f, 0.3f, 1.0f);//(0.4f, 0.4f, 0.4f, 1.0f);
    _specularColor1 = GLKVector4Make(0.0f, 0.0f, 0.0f, 1.0f);//(0.3f, 0.3f, 0.3f, 1.0f);
    _diffuseColor1 = GLKVector4Make(0.75f, 0.9f, 0.75f, 1.0f);//(0.6f, 0.6f, 0.6f, 1.0f);
    _ambientColorm = GLKVector4Make(0.6f, 0.6f, 0.6f, 1.0f);//(0.4f, 0.4f, 0.4f, 1.0f);
    _specularColorm = GLKVector4Make(0.7f, 0.7f, 0.7f, 1.0f);//(0.3f, 0.3f, 0.3f, 1.0f);
    _diffuseColorm = GLKVector4Make(0.8f, 0.8f, 0.6f, 1.0f);//(0.6f, 0.6f, 0.6f, 1.0f);
    //load texture must be done after context is being set
    _transition = GLKVector3Make(1.2f, -1.5f, -3.5f);//(1.4f, -1.9f, -5.0f);//1.4f -1.0f -4.0f
    _isShapeStarted = false;
    _isButtonPressed = false;
    _rotationRate = 0.5f;
    attachTex.enabled = false;
    attachTex.alpha = 0;
    home.enabled = false;
    home.alpha = 0;
    classicShape.enabled = false;
    classicShape.alpha = 0;
    clear.enabled = false;
    clear.alpha = 0;
    operatingBar.alpha = 0;
    classicalPotteryChoosen = 0;
    isChoosingClassical = false;
    [delegate.textureManager.texList.list removeAllObjects];
    //UIImage *image = [delegate.imageManager getUIimg: @"light.jpg"];
    //image = [image resizableImageWithCapInsets:UIEdgeInsetsZero resizingMode:UIImageResizingModeTile];
    //image = [self resizeImage:image toSize:CGSizeMake(image.size.width, image.size.width)];
    //test.image = image;
    [self hideAll];
    /*
    NSString *musicFilePath = [[NSBundle mainBundle] pathForResource:@"bgm_shape" ofType:@"mp3"];       //创建音乐文件路径
    NSURL *musicURL = [[NSURL alloc] initFileURLWithPath:musicFilePath];
    
    AVAudioPlayer *thePlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:musicURL error:nil];
    
    //创建播放器
    myBackMusic = thePlayer;    //赋值给自己定义的类变量
    */
    //[musicURL release];
    //[thePlayer release];
    /*
    [myBackMusic prepareToPlay];
    [myBackMusic setVolume:3];   //设置音量大小
    myBackMusic.numberOfLoops = -1;//设置音乐播放次数  -1为一直循环
*/
    
}

////test the save module
//- (IBAction)savePotteryShape:(id)sender {
//    [_pottery saveToFile:@"temp.wt"];
//}
//
//- (IBAction)loadPotteryShape:(id)sender {
//    [_pottery loadFromFile:@"temp.wt"];
//}
- (IBAction)tap:(UITapGestureRecognizer *)sender {
    if (!_isShapeStarted)
        [self startShape1];
}

-(IBAction)shape:(UIPanGestureRecognizer *)paramSender{
    if(paramSender.state == UIGestureRecognizerStateChanged && _isShapeStarted){
        CGPoint translation = [paramSender translationInView:self.view];
        CGPoint location = [paramSender locationInView:self.view];
//        GLKVector3 camera = GLKVector3Make(0.0f, 0.0f, 0.0f);
        GLKVector3 camera = _cameraPoint;
        int level = -2;
        BOOL isOnPottery = [self findLevelSelected:location Perspective:_perspective Pottery:_pottery Camera:camera TouchedLevel:&level];
        CGSize frameSize = self.view.frame.size;        
        //TODO box have to be completed
        if (abs(translation.y)>abs(translation.x)) {
            if(translation.y<0){// && isOnPottery){
                [_pottery taller:level :_scale.y*10];
            }else if(translation.y > 0){// && isOnPottery){
                [_pottery shorter:level :_scale.y*10];
            }
        }
        else{
            if(((translation.x>0 && location.x>frameSize.width/2)||(translation.x<0&&location.x<frameSize.width/2))&&isOnPottery){
                [_pottery fatter: level : _scale.y];
                //getting larger
            }else if(((translation.x>0 && location.x<frameSize.width/2)||(translation.x<0&&location.x>frameSize.width/2))&&isOnPottery){
                [_pottery thinner: level : _scale.y];
                //getting thinner
            }
        }
    }
    else /*if (!_isButtonPressed) {
        if ((paramSender.state == UIGestureRecognizerStateBegan || paramSender.state == UIGestureRecognizerStateChanged)) {
            CGPoint translation = [paramSender translationInView:self.view];
            CGPoint location = [paramSender locationInView:self.view];
            int touchedLevel = -2;
            bool isOnPottery = [self findLevelSelected:location Perspective:_perspective Pottery:_pottery Camera:_cameraPoint TouchedLevel:&touchedLevel];
            if (isOnPottery) {
                _rotationRate = 0.0f;
                _rotation += translation.x/110.0f;
            }else{
                _rotationRate = 0.2f;
            }
        }
        else{
            _rotationRate = 0.2f;
        }
    }
    else*/{
        [self startShape1];
    }
    [paramSender setTranslation:CGPointMake(0, 0) inView:self.view];
}

-(void)startShape1{
    [myBackMusic play];   //播放
    //UIButton *t = (UIButton *)sender;
    //t.hidden = YES;
    if (!_isShapeStarted && !_isButtonPressed) {
        _isButtonPressed = true;
        _rotationRate = 2.0f;
        // set a timer that updates the progress
        _timer = [NSTimer scheduledTimerWithTimeInterval: 0.03f target: self selector: @selector(translation) userInfo: nil repeats: YES] ;
        start.enabled = NO;
        start.hidden = NO;
        account.enabled = false;
        info.enabled = false;
        start.hidden = NO;
        fare.enabled = false;
        start.hidden = NO;
        //home button
        attachTex.hidden = false;
        clear.hidden = false;
        home.hidden = false;
        classicShape.hidden = false;
        operatingBar.hidden = false;
        attachTex.alpha = 0.0f;
        clear.alpha = 0.0f;
        home.alpha = 0.0f;
        classicShape.alpha = 0.0f;
        operatingBar.alpha = 0.0f;
    }

}

- (IBAction)startShape:(id)sender {
//    NSLog(@"startShape:%@", sender);
    [myBackMusic play];   //播放
    UIButton *t = (UIButton *)sender;
    t.hidden = YES;
    if (!_isShapeStarted && !_isButtonPressed) {
        _isButtonPressed = true;
        _rotationRate = 2.0f;
        // set a timer that updates the progress
        _timer = [NSTimer scheduledTimerWithTimeInterval: 0.03f target: self selector: @selector(translation) userInfo: nil repeats: YES] ;
        start.enabled = NO;
        start.hidden = NO;
        account.enabled = false;
        info.enabled = false;
        start.hidden = NO;
        fare.enabled = false;
        start.hidden = NO;
        //home button
        attachTex.hidden = false;
        clear.hidden = false;
        home.hidden = false;
        classicShape.hidden = false;
        operatingBar.hidden = false;
        attachTex.alpha = 0.0f;
        clear.alpha = 0.0f;
        home.alpha = 0.0f;
        classicShape.alpha = 0.0f;
        operatingBar.alpha = 0.0f;
    }
}

-(void)translation{
    if (_transition.x <= 0) { //finish translation
        _isShapeStarted = true;
        [_timer invalidate];
        _timer = nil;
        //cancel timer
        attachTex.enabled = true;
        clear.enabled = true;
        classicShape.enabled = true;
        home.enabled = true;
        start.hidden = true;
        fare.hidden = true;
        account.hidden = true;
        info.hidden = true;
        imgLogo.hidden = true;
        line.hidden = true;
    }else{
        float gap = 0.08;
        start.alpha = start.alpha -gap;
        account.alpha = account.alpha-gap;
        info.alpha = info.alpha-gap;
        fare.alpha = fare.alpha - gap;
        imgLogo.alpha = imgLogo.alpha - gap;
        line.alpha = line.alpha - gap;
        attachTex.alpha = attachTex.alpha + gap;
        clear.alpha = clear.alpha + gap;
        home.alpha = home.alpha + gap;
        classicShape.alpha = classicShape.alpha + gap;
        //operatingBar.alpha = operatingBar.alpha + gap;
        _transition.x -= 0.06f;
    }
}

-(IBAction)resetShape:(id)sender{
//    NSLog(@"resetShape:%@", sender);
    //delegate.pottery = nil;
    /*
    _pottery = [[WTPottery alloc] WTPotteryIH:WT_INIT_HEIGHT IR:WT_INIT_RADIUS MINH:WT_MIN_HEIGHT MINR:WT_MIN_RADIUS MAXH:WT_MAX_HEIGHT MAXR:WT_MAX_RADIUS TH:WT_THICKNESS];
    
    [_pottery setupTexture:@"clay.png"];//@"t4.jpg"];
    delegate.pottery = _pottery;*/
    WTAppDelegate *delegate = [[UIApplication sharedApplication] delegate];
    [delegate.pottery loadFromFile:@"model.wt"];
    
}


-(IBAction)backHome:(id)sender{
//    NSLog(@"backHome:%@", sender);
    if (_isShapeStarted) {
        _isShapeStarted = false;
        _rotationRate = 0.5f;
        // set a timer that updates the progress
        _timer = [NSTimer scheduledTimerWithTimeInterval: 0.03f target: self selector: @selector(back) userInfo: nil repeats: YES] ;
        attachTex.enabled = false;
        classicShape.enabled = false;
        clear.enabled = false;
        home.enabled = false;
        //operating button
        start.alpha = 0.0f;
        imgLogo.alpha = 0.0f;
        line.alpha = 0.0f;
        fare.alpha = 0.0f;
        account.alpha = 0.0f;
        info.alpha = 0.0f;
        imgLogo.hidden = false;
        line.hidden = false;
        fare.hidden = false;
        start.hidden = false;
        account.hidden = false;
        info.hidden = false;
        //home button
    }
}

- (IBAction)market:(id)sender {
    //NSString *urlText = [ NSString stringWithFormat:@"http://weidian/s/259682588"];
    //[[UIApplication sharedApplication] openURL:[ NSURL URLWithString:urlText]];
}

- (IBAction)keep:(id)sender {
}

- (IBAction)info:(id)sender {
}

- (IBAction)next:(id)sender {
    //[myBackMusic stop];
    WTAppDelegate *delegate = [[UIApplication sharedApplication] delegate];
    delegate.attatchTexMode = WT_MODE_YANSE;
    //appDelegate.backTexName = @"whiteBackTexture.jpg";
    //[appDelegate.textureManager clearTexture:appDelegate.backTexName];
}

- (IBAction)choosePottery1:(id)sender {
    [self hideFrame];
    classicalPotteryChoosen = 1;
    //chooseFrame1.hidden = NO;
    NSString *s = [NSString stringWithFormat:@"sampler_data%d",classicalPotteryChoosen];
    [_pottery setFromTxt: s];
    [self hideAll];
    [self showcatalog];
}

- (IBAction)choosePottery2:(id)sender {
    [self hideFrame];
    classicalPotteryChoosen = 2;
    //chooseFrame2.hidden = NO;
    NSString *s = [NSString stringWithFormat:@"sampler_data%d",classicalPotteryChoosen];
    [_pottery setFromTxt: s];
    [self hideAll];
    [self showcatalog];
}

- (IBAction)choosePottery3:(id)sender {
    [self hideFrame];
    classicalPotteryChoosen = 3;
    //chooseFrame3.hidden = NO;
    NSString *s = [NSString stringWithFormat:@"sampler_data%d",classicalPotteryChoosen];
    [_pottery setFromTxt: s];
    [self hideAll];
    [self showcatalog];
}

- (IBAction)choosePottery4:(id)sender {
    [self hideFrame];
    classicalPotteryChoosen = 4;
    //chooseFrame4.hidden = NO;
    NSString *s = [NSString stringWithFormat:@"sampler_data%d",classicalPotteryChoosen];
    [_pottery setFromTxt: s];
    [self hideAll];
    [self showcatalog];
}

- (IBAction)choosePottery5:(id)sender {
    [self hideFrame];
    classicalPotteryChoosen = 5;
    //chooseFrame5.hidden = NO;
    NSString *s = [NSString stringWithFormat:@"sampler_data%d",classicalPotteryChoosen];
    [_pottery setFromTxt: s];
    [self hideAll];
    [self showcatalog];
}

- (IBAction)choosePottery6:(id)sender {
    [self hideFrame];
    classicalPotteryChoosen = 6;
    //chooseFrame6.hidden = NO;
    NSString *s = [NSString stringWithFormat:@"sampler_data%d",classicalPotteryChoosen];
    [_pottery setFromTxt: s];
    [self hideAll];
    [self showcatalog];
}

- (IBAction)choosePottery7:(id)sender {
    [self hideFrame];
    classicalPotteryChoosen = 7;
    //chooseFrame7.hidden = NO;
    NSString *s = [NSString stringWithFormat:@"sampler_data%d",classicalPotteryChoosen];
    [_pottery setFromTxt: s];
    [self hideAll];
    [self showcatalog];
}

- (IBAction)choosePottery8:(id)sender {
    [self hideFrame];
    classicalPotteryChoosen = 8;
    //chooseFrame8.hidden = NO;
    NSString *s = [NSString stringWithFormat:@"sampler_data%d",classicalPotteryChoosen];
    [_pottery setFromTxt: s];
    [self hideAll];
    [self showcatalog];
}

- (IBAction)choosePottery9:(id)sender {
    [self hideFrame];
    classicalPotteryChoosen = 9;
    //chooseFrame8.hidden = NO;
    NSString *s = [NSString stringWithFormat:@"sampler_data%d",classicalPotteryChoosen];
    [_pottery setFromTxt: s];
    [self hideAll];
    [self showcatalog];
}

-(void)back{
    if (_transition.x>=0.6) {
        _isButtonPressed = false;
        [_timer invalidate];
        _timer = nil;
        attachTex.hidden = true;
        clear.hidden = true;
        home.hidden = true;
        classicShape.hidden = true;
        operatingBar.hidden = true;
        //
        fare.enabled = true;
        start.enabled = true;
        account.enabled = true;
        info.enabled = true;
    }else{
        float gap = 0.08f;
        start.alpha = start.alpha + gap;
        account.alpha = account.alpha + gap;
        info.alpha = info.alpha + gap;
        fare.alpha = fare.alpha + gap;
        imgLogo.alpha = imgLogo.alpha + gap;
        line.alpha = line.alpha + gap;
        //
        clear.alpha = clear.alpha - gap;
        home.alpha = home.alpha - gap;
        classicShape.alpha = classicShape.alpha - gap;
        operatingBar.alpha = operatingBar.alpha - gap;
        _transition.x += 0.06f;
    }
    [myBackMusic stop];
}


- (void)viewDidUnload {
    [myBackMusic stop];
    [self setOperatingBar:nil];
    [self setHome:nil];
    [self setClear:nil];
    [self setClassicShape:nil];
    //[self setChooseFrame1:nil];
    //[self setChooseFrame2:nil];
    //[self setChooseFrame3:nil];
    //[self setChooseFrame4:nil];
    //[self setChooseFrame5:nil];
    //[self setChooseFrame6:nil];
    //[self setChooseFrame8:nil];
    //[self setChooseFrame7:nil];
    [self setBCP1:nil];
    [self setBCP2:nil];
    [self setBCP3:nil];
    [self setBCP4:nil];
    [self setBCP5:nil];
    [self setBCP6:nil];
    [self setBCP8:nil];
    [self setBCP7:nil];
    [self setBCP9:nil];
    [self setShelf:nil];
    [self setBYes:nil];
    [self setBNo:nil];
    [super viewDidUnload];
}


-(void)hideAll{
    shelf.hidden = YES;
    bYes.hidden = YES;
    bNo.hidden = YES;
    //[self hideFrame];
    bCP1.hidden = YES;
    bCP2.hidden = YES;
    bCP3.hidden = YES;
    bCP4.hidden = YES;
    bCP5.hidden = YES;
    bCP6.hidden = YES;
    bCP7.hidden = YES;
    bCP8.hidden = YES;
    bCP9.hidden = YES;
}

-(void)hideFrame{
    //chooseFrame1.hidden = YES;
    //chooseFrame2.hidden = YES;
    //chooseFrame3.hidden = YES;
    //chooseFrame4.hidden = YES;
    //chooseFrame5.hidden = YES;
    //chooseFrame6.hidden = YES;
    //chooseFrame7.hidden = YES;
    //chooseFrame8.hidden = YES;
}

-(void)showAll{
    shelf.hidden = NO;
    bYes.hidden = NO;
    bNo.hidden = NO;
    bCP1.hidden =NO;
    bCP2.hidden = NO;
    bCP3.hidden = NO;
    bCP4.hidden = NO;
    bCP5.hidden = NO;
    bCP6.hidden = NO;
    bCP7.hidden = NO;
    bCP8.hidden = NO;
    bCP9.hidden = NO;
    //[self hideFrame];
}

-(void) showcatalog{
    attachTex.hidden = false;
    clear.hidden = false;
    home.hidden = false;
    classicShape.hidden = false;
}

-(void) hidecatalog{
    attachTex.hidden = true;
    clear.hidden = true;
    home.hidden = true;
    classicShape.hidden = true;
}

/*- (IBAction)pressYes:(id)sender {
    //choose the model
    NSString *s = [NSString stringWithFormat:@"classical_%d",classicalPotteryChoosen];
    [_pottery setFromTxt: s];
    [self hideAll];
    [self showcatalog];
}*/

- (IBAction)pressCancel:(id)sender {
    [self hideAll];
    [self showcatalog];
}

- (IBAction)chooseClassical:(id)sender {
    //if (!isChoosingClassical) {
    [self showAll];
    [self hidecatalog];
    //chooseFrame1.hidden = NO;
        //classicalPotteryChoosen = 1;
    //}else{
    //    [self hideAll];
    //}
    //isChoosingClassical = !isChoosingClassical;
}
- (IBAction)collection:(id)sender {
    
    
    
    NSLog(@"123");
    
    [self performSegueWithIdentifier:@"colloctionmodal" sender:self];
    
}

/*- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
    if (([self.view window] == nil)) {
        myBackMusic = nil;
        _timer = nil;
        //transform the model world according to gravity
    }
    // Dispose of any resources that can be recreated.
}
*/
/*-(void)viewDidDisappear:(BOOL)animated{
    
    [super viewDidDisappear:animated];
    myBackMusic = nil;
    _timer = nil;
    
}*/

/*-(void)viewWillDisappear:(BOOL)animated{
    //[super viewWillDisappear:animated];
    
    glDeleteTextures(1, &t1);
    
    glDeleteTextures(1, &t2);
    
    glDeleteTextures(1, &t3);
    
    glDeleteTextures(1, &t4);
    
    glDeleteTextures(1, &texcube);
    
    
    [super viewWillDisappear:animated];
    /*glDeleteTextures(1, &t1);
     
     t1 = [_background setupTexture:@"main_activity_background.png"];
     
     glDeleteTextures(1, &t2);
     
     
     
     glDeleteTextures(1, &t3);
    //self.view = nil;
    //self.context = nil;
}*/



@end
