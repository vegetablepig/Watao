//
//  ViewController.m
//  animation
//
//  Created by fc on 14-5-12.
//  Copyright (c) 2014年 fc. All rights reserved.
//

#import "WTFlashViewController.h"
#import "WTAppDelegate.h"
#import "WTPotteryCheckViewController.h"

@interface WTFlashViewController ()
//- (IBAction)start_A:(id)sender;
@property (weak, nonatomic) IBOutlet UIImageView *Flash;
@property (weak, nonatomic) IBOutlet UIImageView *curtain;

@end

@implementation WTFlashViewController

@synthesize progress1;
@synthesize mydate;
@synthesize label;
@synthesize flashflag;
@synthesize texcube;

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
    flashflag = true;
    //NSLog(@"testdl");    //self.Flash = [[UIImageView alloc] init];
    animating = false;
    super.isGravityTurnedOn = true;
    [super viewDidLoad];
    [_background setupTexture:@"fire_bgk.jpg"];
    WTAppDelegate *delegate = [[UIApplication sharedApplication] delegate];
    if (delegate.attatchTexMode == WT_MODE_YANSE) [_pad setupTexture:@"table.png"];else [_pad setupTexture:@"shangyoumuwen.png"];
    //[_pottery setupTexture:@"clay.png"];
    //    [_pottery setupTexture:@"t4.jpg"];
    //WTAppDelegate *delegate = [[UIApplication sharedApplication] delegate];
    _pottery.textureID = [delegate.textureManager convertToTexturenew:_pottery.textureID];
    [_shadow setupTexture:@"shadow.png"];
    _transition = GLKVector3Make(0.0f, -1.5f, -3.5f);//_transition = GLKVector3Make(0.0f, -1.0f, -4.0f);
    _rotationRate = 0.2;
    //NSString * name = [NSString stringWithFormat:@"fire0"];
    //UIImage *Img = [UIImage imageNamed:name];
    //self.curtain.image = Img;
    //self.curtain.alpha = 0.7;
    //self.curtain.backgroundColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:.5];
    dataSet = [NSMutableArray arrayWithCapacity:105];
    for ( int i=0; i<=104; i++ )
    {
        NSString * name = [NSString stringWithFormat:@"fire%d", i];
        [dataSet addObject:name];
        name = nil;//**
    }
    ImgSet = [NSMutableArray arrayWithCapacity:105];
    //UIImage * img = nil;
    
    for ( int i=0; i<=104; i++ )
    {
      //  NSString * name = [dataSet objectAtIndex:i];
        //WTDelegate *app = [UIApplication sharedApplication].delegate;
        //app.imageManager getUIIMage
        NSString *path = @"";
        path = [[[NSBundle mainBundle] resourcePath]
                stringByAppendingPathComponent:[dataSet objectAtIndex:i]];
        [ImgSet addObject:[UIImage imageWithContentsOfFile:path]];
    }
    
    arr=ImgSet;
    self.Flash.animationImages = arr;
    arr = nil;
    ImgSet = nil;
    dataSet = nil;
    self.Flash.animationDuration = 5;
    self.Flash.animationRepeatCount = 1;
    CGAffineTransform trans = CGAffineTransformMakeScale(1.0f, 5.0f);
    self.progress1.transform = trans;
    self.progress1.progress = 0.0f;
    //self.Flash.image =[UIImage imageNamed:[dataSet objectAtIndex:0]];
    //NSString * Iname = [dataSet objectAtIndex:0];
    //UIImage *Img = [UIImage imageNamed:Iname];
    //self.Flash.image = Img;
    //self.Flash.alpha = 0.7;
       //_changeFlag = false;
    //TODO Flash
    //self.view.backgroundColor = [UIColor blackColor];
    
    //NSInteger AnimationNtimer = 3;
    
    //NSTimer *animationTimer = [NSTimer scheduledTimerWithTimeInterval: AnimationNtimer target:self selector:@selector(ArrowAnimationPlay:) userInfo:nil repeats: NO];
    
    
    	/*[animator setImageNames:dataSet];
	[animator setDuration:1];
	
	//test notification!
	[animator setCacheImages:YES];
	[animator setDelegate:self];
	[animator setStartSelector:@selector(start:)];
	[animator setStopSelector:@selector(stop:)];
    if ( ![animator isAnimating] )
	{
        [animator setIndex:0];
        [animator startAnimating];
	}*/
    NSString *musicFilePath = [[NSBundle mainBundle] pathForResource:@"bgm_fire" ofType:@"mp3"];       //创建音乐文件路径
    NSURL *musicURL = [[NSURL alloc] initFileURLWithPath:musicFilePath];
    
    AVAudioPlayer *thePlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:musicURL error:nil];
    
    //创建播放器
    myBackMusic = thePlayer;    //赋值给自己定义的类变量
    
    musicURL = nil;
    thePlayer = nil;
    
    [myBackMusic prepareToPlay];
    [myBackMusic setVolume:3];   //设置音量大小
    myBackMusic.numberOfLoops = -1;//设置音乐播放次数  -1为一直循环
    flag = 0;
    if (flashflag == true) NSLog(@"flash!!!");
}

- (BOOL)loadShaders
{
    GLuint vertShader, fragShader;
    NSString *vertShaderPathname, *fragShaderPathname;
    
    // Create shader program.
    _program = glCreateProgram();
    
    // Create and compile vertex shader.
    vertShaderPathname = [[NSBundle mainBundle] pathForResource:@"ShaderFire" ofType:@"vsh"];
    if (![self compileShader:&vertShader type:GL_VERTEX_SHADER file:vertShaderPathname]) {
        NSLog(@"Failed to compile vertex shader");
        return NO;
    }
    
    // Create and compile fragment shader.
    fragShaderPathname = [[NSBundle mainBundle] pathForResource:@"ShaderFire" ofType:@"fsh"];
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

/*- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    //NSLog(@"testwa");
    //[self performSegueWithIdentifier:@"rawEnd" sender:self];
    [myBackMusic play];
    
    //WTPotteryCheckViewController *viewController2 = [[WTPotteryCheckViewController alloc] init];
    //[self presentModalViewController:viewController2 animated:YES];

}*/

//-(void)ArrowAnimationPlay:(NSTimer *) timer{
	//UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"wtq" message:@"I have a message" delegate:self cancelButtonTitle:@"cancel" otherButtonTitles:nil];
	//[alert show];
    //[UINavigationController pushViewController: WTPotteryCheckViewController animated:YES];
//}


-(void)glkView:(GLKView *)view drawInRect:(CGRect)rect{
    WTAppDelegate *delegate = [[UIApplication sharedApplication] delegate];
    NSLog(@"flash! %d", flashflag);
    [super glkView:(GLKView *)view drawInRect:(CGRect)rect];
    if ([self.Flash isAnimating] == false && animating == true) {
        [self.Flash setAnimationImages:nil];
        //appDelegate.attatchTexMode = WT_MODE_YANSE;
        /*NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];//设置你想要的格式,hh与HH的区别:分别表示12小时制,24小时制
        NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:@"Asia/Beijing"];
        [formatter setTimeZone:timeZone];
        NSDate *dateend = [NSDate date];
        double dd = (double)[dateend timeIntervalSince1970] - [mydate timeIntervalSince1970];
        NSLog(@"time: %f %f %f", [dateend timeIntervalSince1970],[mydate timeIntervalSince1970],dd);*/
        [myBackMusic stop];
        if(delegate.attatchTexMode == WT_MODE_YANSE)
        {
            [self go];//[self performSegueWithIdentifier:@"youShang" sender:self];
        } else
            //if (appDelegate.attatchTexMode == WT_MODE_QINHUA)
        {
            [self go1];//[self performSegueWithIdentifier:@"qinHua" sender:self];
        }
    }
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
    glEnable(GL_TEXTURE_CUBE_MAP);
    //WTAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    glBindTexture(GL_TEXTURE_CUBE_MAP, texcube);//[self CreateSimpleTextureCubemap]);
    glActiveTexture(GL_TEXTURE1);
    glEnable(GL_TEXTURE_2D);
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
    glUniformMatrix3fv(uniforms[UNIFORM_NORMAL_MATRIX], 1, 0, normalm.m);//object.getNormalMatrix.m)
    /*
    glUniformMatrix4fv(uniforms[UNIFORM_MODELVIEWPROJECTION_MATRIX], 1, 0, object.getModelProjectionViewMatrix.m);
    glUniformMatrix3fv(uniforms[UNIFORM_NORMAL_MATRIX], 1, 0, object.getNormalMatrix.m);*/
    glUniform3fv(uniforms[UNIFORM_EYEPOINT], 1, _cameraPoint.v);
    if (vertexArrayID == VERTEX_ARRAY_POTTERY){
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
    } else if (vertexArrayID == VERTEX_ARRAY_BACKGROUND)    {
        glUniform4fv(uniforms[UNIFORM_SPECULAR_COLOR], 1, _bspecularColor.v);
        glUniform4fv(uniforms[UNIFORM_AMBIENT_COLOR], 1, _bambientColor.v);
        glUniform4fv(uniforms[UNIFORM_DIFFUSE_COLOR], 1, _bdiffuseColor.v);
        glUniform4fv(uniforms[UNIFORM_SPECULAR_COLOR1], 1, _bspecularColor.v);
        glUniform4fv(uniforms[UNIFORM_AMBIENT_COLOR1], 1, _bambientColor.v);
        glUniform4fv(uniforms[UNIFORM_DIFFUSE_COLOR1], 1, _bdiffuseColor.v);
        glUniform4fv(uniforms[UNIFORM_SPECULAR_COLORM], 1, _bspecularColorm.v);
        glUniform4fv(uniforms[UNIFORM_AMBIENT_COLORM], 1, _bambientColorm.v);
        glUniform4fv(uniforms[UNIFORM_DIFFUSE_COLORM], 1, _bdiffuseColorm.v);
        glUniform1i(uniforms[UNIFORM_FLAG], 0);
        glDrawElements(GL_TRIANGLE_STRIP, object.getIndexCount, GL_UNSIGNED_SHORT, 0);
    }else{
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


-(void) update
{
    [super update];
    //NSDate *datenow;
    if (animating == false) {animating = true;
        [self.Flash startAnimating];
        /*NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];//设置你想要的格式,hh与HH的区别:分别表示12小时制,24小时制
        NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:@"Asia/Beijing"];
        [formatter setTimeZone:timeZone];*/
        mydate = [NSDate date];
        NSLog(@"start!");
        //NSTimeInterval now=[mydate timeIntervalSince1970]*1;
        //NSLog(@"time: %f", [mydate timeIntervalSince1970]);
    }
    if (flag <= 2) {mydate = [NSDate date];}else if(flag == 3)[myBackMusic play];
    flag++;
    NSLog(@"Updating");
    /*NSDate *nowdate =[NSDate date];
    
    NSTimeInterval cha=(float)[nowdate timeIntervalSince1970] - [mydate timeIntervalSince1970];
    NSLog(@"%f", cha);*/
    /*NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];//设置你想要的格式,hh与HH的区别:分别表示12小时制,24小时制
    NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:@"Asia/Beijing"];
    [formatter setTimeZone:timeZone];*/
    WTAppDelegate *delegate = [[UIApplication sharedApplication] delegate];
    NSDate *dateend = [NSDate date];
    NSLog(@"time: %f",(float)([dateend timeIntervalSince1970] - [mydate timeIntervalSince1970]));
    float p = (float)([dateend timeIntervalSince1970] - [mydate timeIntervalSince1970]) / 4.8f;
    if (p > 1.0f) p = 1.0f;
    NSString *wendu;
    if (delegate.attatchTexMode == WT_MODE_YANSE) wendu = [[NSString alloc]initWithFormat:@"%d",(int)(p*1280.0)];else wendu = [[NSString alloc]initWithFormat:@"%d",(int)(p*780.0)];
    NSString *str = [[@"当前温度为:" stringByAppendingString:wendu] stringByAppendingString:@"°C"];
    //NSLog(@"wendu : %@", str);
    label.text = str;
    [progress1 setProgress: (float)([dateend timeIntervalSince1970] - [mydate timeIntervalSince1970]) / 4.8f animated:YES];
    if((float)([dateend timeIntervalSince1970] - [mydate timeIntervalSince1970]) < 1.5f)
    {
        _ambientColor = GLKVector4Make(0.3f+(float)([dateend timeIntervalSince1970] - [mydate timeIntervalSince1970])*.4, ((float)([dateend timeIntervalSince1970] - [mydate timeIntervalSince1970]))*0.2f/1.5f, ((float)([dateend timeIntervalSince1970] - [mydate timeIntervalSince1970]))*0.2f/1.5f, 1.0f);//(0.4f, 0.4f, 0.4f, 1.0f);
        _specularColor =GLKVector4Make(0.0f, 0.0f, 0.0f, 1.0f);
        _diffuseColor =  GLKVector4Make(0.25f+(float)([dateend timeIntervalSince1970] - [mydate timeIntervalSince1970])*.3, ((float)([dateend timeIntervalSince1970] - [mydate timeIntervalSince1970]))*0.1f/1.5f, ((float)([dateend timeIntervalSince1970] - [mydate timeIntervalSince1970]))*0.1f/1.5f, 1.0f);//(0.3f, 0.3f, 0.3f, 1.0f);//(0.6f, 0.6f, 0.6f, 1.0f);
        _ambientColor1 = GLKVector4Make(0.0f, 0.0f, 0.0f, 1.0f);//(0.4f, 0.4f, 0.4f, 1.0f);
        _specularColor1 = GLKVector4Make(0.0f, 0.0f, 0.0f, 1.0f);//(0.3f, 0.3f, 0.3f, 1.0f);
        _diffuseColor1 = GLKVector4Make(0.0f, 0.0f, 0.0f, 1.0f);//(0.6f, 0.6f, 0.6f, 1.0f);
        _ambientColorm = GLKVector4Make(0.5f, 0.5f, 0.5f, 1.0f);//(0.4f, 0.4f, 0.4f, 1.0f);
        _specularColorm = GLKVector4Make(0.7f, 0.7f, 0.7f, 1.0f);//(0.3f, 0.3f, 0.3f, 1.0f);
        _diffuseColorm = GLKVector4Make(0.9f, 0.9f, 0.8f, 1.0f);//(0.6f, 0.6f, 0.6f, 1.0f);
        _bambientColor = GLKVector4Make(0.3f+(float)([dateend timeIntervalSince1970] - [mydate timeIntervalSince1970])*.4, 0.3f+(float)([dateend timeIntervalSince1970] - [mydate timeIntervalSince1970])*.4, 0.3f+(float)([dateend timeIntervalSince1970] - [mydate timeIntervalSince1970])*.4, 1.0f);//(0.4f, 0.4f, 0.4f, 1.0f);
        _bspecularColor =GLKVector4Make(0.0f, 0.0f, 0.0f, 1.0f);
        _bdiffuseColor =  GLKVector4Make(0.25f+(float)([dateend timeIntervalSince1970] - [mydate timeIntervalSince1970])*.3, 0.25f+(float)([dateend timeIntervalSince1970] - [mydate timeIntervalSince1970])*.3, 0.25f+(float)([dateend timeIntervalSince1970] - [mydate timeIntervalSince1970])*.3, 1.0f);//(0.3f, 0.3f, 0.3f, 1.0f);//(0.6f, 0.6f, 0.6f, 1.0f);
        _bambientColorm = GLKVector4Make(1.0f, 1.0f, 1.0f, 1.0f);//(0.4f, 0.4f, 0.4f, 1.0f);
        _bspecularColorm = GLKVector4Make(1.0f, 1.0f, 1.0f, 1.0f);//(0.3f, 0.3f, 0.3f, 1.0f);
        _bdiffuseColorm = GLKVector4Make(1.0f, 1.0f, 1.0f, 1.0f);//(0.6f, 0.6f, 0.6f, 1.0f);
        

        //NSLog(@"1!");
    }
    else if((float)([dateend timeIntervalSince1970] - [mydate timeIntervalSince1970]) > 3.5f)
    {
        _ambientColor = GLKVector4Make(0.9f-((float)([dateend timeIntervalSince1970] - [mydate timeIntervalSince1970])-3.5f)*0.6f, 0.2f-((float)([dateend timeIntervalSince1970] - [mydate timeIntervalSince1970])-3.5f)*0.1f, 0.2f-((float)([dateend timeIntervalSince1970] - [mydate timeIntervalSince1970])-3.5f)*0.1f, 1.0f);//(0.4f, 0.4f, 0.4f, 1.0f);
        _specularColor = GLKVector4Make(0.0f, 0.0f, 0.0f, 1.0f);//(0.3f, 0.3f, 0.3f, 1.0f);
        _diffuseColor = GLKVector4Make(0.7f-((float)([dateend timeIntervalSince1970] - [mydate timeIntervalSince1970])-3.5f)*0.45f, 0.1f-((float)([dateend timeIntervalSince1970] - [mydate timeIntervalSince1970])-3.5f)*0.05f, 0.1f-((float)([dateend timeIntervalSince1970] - [mydate timeIntervalSince1970])-3.5f)*0.05f, 1.0f);//(0.6f, 0.6f, 0.6f, 1.0f);
        _ambientColor1 = GLKVector4Make(0.0f, 0.0f, 0.0f, 1.0f);//(0.4f, 0.4f, 0.4f, 1.0f);
        _specularColor1 = GLKVector4Make(0.0f, 0.0f, 0.0f, 1.0f);//(0.3f, 0.3f, 0.3f, 1.0f);
        _diffuseColor1 = GLKVector4Make(0.0f, 0.0f, 0.0f, 1.0f);//(0.6f, 0.6f, 0.6f, 1.0f);
        _ambientColorm = GLKVector4Make(0.5f, 0.5f, 0.5f, 1.0f);//(0.4f, 0.4f, 0.4f, 1.0f);
        _specularColorm = GLKVector4Make(0.7f, 0.7f, 0.7f, 1.0f);//(0.3f, 0.3f, 0.3f, 1.0f);
        _diffuseColorm = GLKVector4Make(0.9f, 0.9f, 0.8f, 1.0f);//(0.6f, 0.6f, 0.6f, 1.0f);
        _bambientColor = GLKVector4Make(0.9f-((float)([dateend timeIntervalSince1970] - [mydate timeIntervalSince1970])-3.5f)*0.6f,0.9f-((float)([dateend timeIntervalSince1970] - [mydate timeIntervalSince1970])-3.5f)*0.6f,0.9f-((float)([dateend timeIntervalSince1970] - [mydate timeIntervalSince1970])-3.5f)*0.6f, 1.0f);//(0.4f, 0.4f, 0.4f, 1.0f);
        _bspecularColor =GLKVector4Make(0.0f, 0.0f, 0.0f, 1.0f);
        _bdiffuseColor =  GLKVector4Make(0.7f-((float)([dateend timeIntervalSince1970] - [mydate timeIntervalSince1970])-3.5f)*0.45f,0.7f-((float)([dateend timeIntervalSince1970] - [mydate timeIntervalSince1970])-3.5f)*0.45f,0.7f-((float)([dateend timeIntervalSince1970] - [mydate timeIntervalSince1970])-3.5f)*0.45f, 1.0f);//(0.3f, 0.3f, 0.3f, 1.0f);//(0.6f, 0.6f, 0.6f, 1.0f);
        _bambientColorm = GLKVector4Make(1.0f, 1.0f, 1.0f, 1.0f);//(0.4f, 0.4f, 0.4f, 1.0f);
        _bspecularColorm = GLKVector4Make(1.0f, 1.0f, 1.0f, 1.0f);//(0.3f, 0.3f, 0.3f, 1.0f);
        _bdiffuseColorm = GLKVector4Make(1.0f, 1.0f, 1.0f, 1.0f);//(0.6f, 0.6f, 0.6f, 1.0f);
        //NSLog(@"3!");
    }
    else
    {
        _ambientColor = GLKVector4Make(0.9f, 0.2f, 0.2f, 1.0f);//(0.4f, 0.4f, 0.4f, 1.0f);
        _specularColor = GLKVector4Make(0.0f, 0.0f, 0.0f, 1.0f);//(0.3f, 0.3f, 0.3f, 1.0f);
        _diffuseColor = GLKVector4Make(0.7f, 0.1f, 0.1f, 1.0f);//(0.6f, 0.6f, 0.6f, 1.0f);
        _ambientColor1 = GLKVector4Make(0.0f, 0.0f, 0.0f, 1.0f);//(0.4f, 0.4f, 0.4f, 1.0f);
        _specularColor1 = GLKVector4Make(0.0f, 0.0f, 0.0f, 1.0f);//(0.3f, 0.3f, 0.3f, 1.0f);
        _diffuseColor1 = GLKVector4Make(0.0f, 0.0f, 0.0f, 1.0f);//(0.6f, 0.6f, 0.6f, 1.0f);
        _ambientColorm = GLKVector4Make(0.5f, 0.5f, 0.5f, 1.0f);//(0.4f, 0.4f, 0.4f, 1.0f);
        _specularColorm = GLKVector4Make(0.7f, 0.7f, 0.7f, 1.0f);//(0.3f, 0.3f, 0.3f, 1.0f);
        _diffuseColorm = GLKVector4Make(0.9f, 0.9f, 0.8f, 1.0f);//(0.6f, 0.6f, 0.6f, 1.0f);
        _bambientColor = GLKVector4Make(0.9f, 0.9f, 0.9f, 1.0f);//(0.4f, 0.4f, 0.4f, 1.0f);
        _bspecularColor =GLKVector4Make(0.0f, 0.0f, 0.0f, 1.0f);
        _bdiffuseColor =  GLKVector4Make(0.7f, 0.7f, 0.7f, 1.0f);//(0.3f, 0.3f, 0.3f, 1.0f);//(0.6f, 0.6f, 0.6f, 1.0f);
        _bambientColorm = GLKVector4Make(1.0f, 1.0f, 1.0f, 1.0f);//(0.4f, 0.4f, 0.4f, 1.0f);
        _bspecularColorm = GLKVector4Make(1.0f, 1.0f, 1.0f, 1.0f);//(0.3f, 0.3f, 0.3f, 1.0f);
        _bdiffuseColorm = GLKVector4Make(1.0f, 1.0f, 1.0f, 1.0f);//(0.6f, 0.6f, 0.6f, 1.0f);
        //NSLog(@"2!");
    }
    dateend = nil;
    /*if ([self.Flash isAnimating] == false && animating == true) {
        
        //appDelegate.attatchTexMode = WT_MODE_YANSE;
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];//设置你想要的格式,hh与HH的区别:分别表示12小时制,24小时制
        NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:@"Asia/Beijing"];
        [formatter setTimeZone:timeZone];
        NSDate *dateend = [NSDate date];
        double dd = (double)[dateend timeIntervalSince1970] - [mydate timeIntervalSince1970];
        NSLog(@"time: %f %f %f", [dateend timeIntervalSince1970],[mydate timeIntervalSince1970],dd);
        [myBackMusic stop];
       if(appDelegate.attatchTexMode == WT_MODE_YANSE)
        {
            [self go];//[self performSegueWithIdentifier:@"youShang" sender:self];
        } else
            //if (appDelegate.attatchTexMode == WT_MODE_QINHUA)
        {
            [self go1];//[self performSegueWithIdentifier:@"qinHua" sender:self];
        }
    }*/
    /*
    _ambientColor = GLKVector4Make(0.9f-(float)0.4f, 0.2f, 0.2f, 1.0f);//(0.4f, 0.4f, 0.4f, 1.0f);
    _specularColor = GLKVector4Make(0.0f, 0.0f, 0.0f, 1.0f);//(0.3f, 0.3f, 0.3f, 1.0f);
    _diffuseColor = GLKVector4Make(0.7f-(float)0.3f, 0.1f, 0.1f, 1.0f);//(0.6f, 0.6f, 0.6f, 1.0f);
    _ambientColor1 = GLKVector4Make(0.0f, 0.0f, 0.0f, 1.0f);//(0.4f, 0.4f, 0.4f, 1.0f);
    _specularColor1 = GLKVector4Make(0.0f, 0.0f, 0.0f, 1.0f);//(0.3f, 0.3f, 0.3f, 1.0f);
    _diffuseColor1 = GLKVector4Make(0.0f, 0.0f, 0.0f, 1.0f);//(0.6f, 0.6f, 0.6f, 1.0f);
    _ambientColorm = GLKVector4Make(0.6f, 0.6f, 0.6f, 1.0f);//(0.4f, 0.4f, 0.4f, 1.0f);
    _specularColorm = GLKVector4Make(0.7f, 0.7f, 0.7f, 1.0f);//(0.3f, 0.3f, 0.3f, 1.0f);
    _diffuseColorm = GLKVector4Make(0.8f, 0.8f, 0.8f, 1.0f);//(0.6f, 0.6f, 0.6f, 1.0f);*/
}

-(void) go{
    [self performSegueWithIdentifier:@"youShang" sender:self];
}

-(void) go1{
    [self performSegueWithIdentifier:@"qinHua" sender:self];
}

/*-(void)start:(id)_context
{
	NSLog( @"Animation playback has been triggered" );
}

- (void) stop:(id)_context
{
	NSLog( @"Animation playback has finished" );
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}*/

//- (void)dealloc
//{//
//	self.Flash = nil;
 //   self.curtain = nil;
//}

- (void)viewDidUnload {
    [self setCurtain:nil];
    [self setFlash:nil];
    [super viewDidUnload];
}

/*- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
    if (([self.view window] == nil)) {
        myBackMusic = nil;
        dataSet = nil;
        ImgSet = nil;
        arr = nil;
        mydate = nil;
    }
    // Dispose of any resources that can be recreated.
}*/


-(void)viewDidDisappear:(BOOL)animated{
   
    [super viewDidDisappear:animated];
    self.Flash = nil;
    myBackMusic = nil;
    dataSet = nil;
    ImgSet = nil;
    arr = nil;
    mydate = nil;
    self.view = nil;
}



@end
