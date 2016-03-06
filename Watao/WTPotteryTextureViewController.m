//
//  WTPotteryTextureViewController.m
//  Watao
//
//  Created by 连 承亮 on 14-4-18.
//  Copyright (c) 2014年 连 承亮. All rights reserved.
//

#import "WTPotteryTextureViewController.h"

@implementation WTPotteryTextureViewController

@synthesize typeSelected;
@synthesize mode;
@synthesize offset;
@synthesize texName;
@synthesize photo;
@synthesize pflag;
@synthesize ex;//自拍是否已贴（只能一张）
@synthesize nowprice;
@synthesize tprice;
@synthesize clearmode;
@synthesize test;
@synthesize ycopy;
@synthesize deleteflag;
@synthesize testimage;
@synthesize pickerView;
@synthesize photoornot;


/*
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}
-(NSInteger) pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return 2;
}
-(NSString*) pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    return [pickerArray objectAtIndex:row];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    [pickerView reloadComponent:1];
    NSInteger areaRow=[pickerView selectedRowInComponent:0];
    NSInteger teamRow=[pickerView selectedRowInComponent:1];
    if (areaRow == 0) {photoornot = true;}else photoornot = false;
    NSLog(@"photo? %d", photoornot );
    //[_areaTextField setText:[NSString stringWithFormat:@"%@-%@",areaArr[areaRow],teamArr[areaRow][teamRow]]];
}*/

-(void)actionSheetCancel:(UIActionSheet *)actionSheet{

}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    NSLog(@"button : %ld", (long)buttonIndex);
    
    
}

/*
UIImagePickerController *imagePicker =
[[UIImagePickerController alloc] init];

// 如果我们的设备有一个摄像头,我们想拍张照片,否则,我们只是挑选照片库
if ([UIImagePickerController
     isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
    [imagePicker setSourceType:UIImagePickerControllerSourceTypeCamera];
} else {
    [imagePicker setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
}

// This line of code will generate 2 warnings right now, ignore them
[imagePicker setDelegate:self];

// Place image picker on the screen
[self presentModalViewController:imagePicker animated:YES];

// The image picker will be retained by ItemDetailViewController
// until it has been dismissed
//[imagePicker release];
}*/
//拍照后使用图片
    
    
    
//- (void)picker:(UIImagePickerController *)picker
//    didFinishPickingMediaWithInfo:(NSDictionary *)info
//    {
// //通过info对象得到用户所选取的图片
//        UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
// //将图片赋给uiimageview实例并显示
//        //[imageView setImage:image];
// //要关闭UIImagePickerController对象
// //必须掉用这个方法
//        [self dismissModalViewControllerAnimated:YES];
//}



- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex{
    deleteflag = 1;
    
    if (buttonIndex == 1){
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary])
        {
            UIImagePickerController *picker = [[UIImagePickerController alloc] init];
            picker.delegate = self;
            picker.allowsEditing = YES;
            picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            [self presentViewController:picker animated:YES completion:nil];
            //[self presentModalViewController:picker animated:YES];
            
        }
    }else{
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
        {
            UIImagePickerController *picker = [[UIImagePickerController alloc] init];
            picker.delegate = self;
            picker.allowsEditing = YES;
            picker.sourceType = UIImagePickerControllerSourceTypeCamera;
            [self presentViewController:picker animated:YES completion:nil];
        }
    }
}

- (void)actionSheet:(UIActionSheet *)actionSheet willDismissWithButtonIndex:(NSInteger)buttonIndex{
    
}



- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (UIImage *)resizeImage:(UIImage *)image toSize:(CGSize)reSize
{
    UIGraphicsBeginImageContext(CGSizeMake(reSize.width, reSize.height));
    [image drawInRect:CGRectMake(0, 0, reSize.width, reSize.height)];
    UIImage *resizeImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return resizeImage;
}


/*- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self setupGL];
}*/

- (void)glkView:(GLKView *)view drawInRect:(CGRect)rect
{
    glEnable(GL_BLEND);
    glBlendFunc(GL_ONE, GL_ONE_MINUS_SRC_ALPHA);
    //    glBlendFunc(GL_ONE, GL_ZERO);
    //    glBlendFunc(GL_ONE, GL_SRC_COLOR);
    glClearColor(255.0f/255.0f, 255.0f/255.0f, 255.0f/255.0f, 0.0f);
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

    
}


- (void)viewDidLoad
{
    //WTAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    WTAppDelegate *delegate = [[UIApplication sharedApplication] delegate];
    delegate.attatchTexMode = WT_MODE_YANSE;
    //appDelegate.backTexName = @"procelainb.png";
    //[appDelegate.textureManager clearTexture:appDelegate.backTexName];
    pickerView.hidden = true;
    pickerArray = [NSArray arrayWithObjects:@"相机",@"相片", nil];
    deleteflag = 0;
    _ambientColor = GLKVector4Make(0.8f, 0.8f, 0.8f, 1.0f);//(0.4f, 0.4f, 0.4f, 1.0f);
    _specularColor = GLKVector4Make(0.5f, 0.5f, 0.5f, 1.0f);//(0.3f, 0.3f, 0.3f, 1.0f);
    _diffuseColor = GLKVector4Make(0.6f, 0.6f, 0.6f, 1.0f);//(0.6f, 0.6f, 0.6f, 1.0f);
    _ambientColor1 = GLKVector4Make(0.35f, 0.35f, 0.35f, 1.0f);//(0.3f, 0.3f, 0.3f, 1.0f);
    _specularColor1 = GLKVector4Make(0.0f, 0.0f, 0.0f, 1.0f);//(0.3f, 0.3f, 0.3f, 1.0f);
    _diffuseColor1 = GLKVector4Make(0.75f, 0.9f, 0.75f, 1.0f);//(0.6f, 0.6f, 0.6f, 1.0f);
    _ambientColorm = GLKVector4Make(0.5f, 0.6f, 0.6f, 1.0f);//(0.4f, 0.4f, 0.4f, 1.0f);
    _specularColorm = GLKVector4Make(0.7f, 0.7f, 0.7f, 1.0f);//(0.3f, 0.3f, 0.3f, 1.0f);
    _diffuseColorm = GLKVector4Make(0.5f, 0.5f, 0.5f, 1.0f);//(0.6f, 0.6f, 0.6f, 1.0f);
    super.isGravityTurnedOn = true;
    ex=false;
    clearmode = -1;
    
    [super viewDidLoad];
    //    UIImage *image = [appDelegate.imageManager getUIimg:@"main_activity_background.png"];
    //test.image = image;
    //WTAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    _textureManager = delegate.textureManager;
    NSLog(@"get in");
    [_background setupTexture:@"decorate_background.png"];
    [_pad setupTexture:@"shangyoumuwen.png"];
    [_shadow setupTexture:@"shadow.png"];
//    GLuint texID = [_textureManager convertToTexture];
//    [_pottery setTextureID:texID];
//    [_pottery setupTexture:@"t4.jpg"];
    delegate.backTexName = @"procelainb.png";
    [_textureManager clearTexture:@"procelainb.png"];
    [_pottery setupTexture:@"procelainb.png"];
    //WTAppDelegate *delegate = [[UIApplication sharedApplication] delegate];
    
    //delegate.textureManager = [[WTTexutureManager alloc] init:@"procelainb.png"];
    [_textureManager backupImgData];
    [_textureManager backupImgData2];
    [_textureManager backupImgData3];
    [_textureManager addTexture:1:@"":1];
    _pottery.textureID = [delegate.textureManager convertToTexturenew:_pottery.textureID];
    [_textureManager backupImgData2];
    [_textureManager restoreImgData];
    _transition = GLKVector3Make(0.0f, -1.5f, -3.5f);//_transition = GLKVector3Make(0.0f, -1.0f, -4.0f);
    _rotationRate = 0.5;
    //
    mode = @"";
    if (delegate.zipai == 0) pflag = false; else pflag = true;
    /*if (appDelegate.attatchTexMode == WT_MODE_QINHUA) {
        mode = [mode stringByAppendingString:@"qinhua"];
    }else if(appDelegate.attatchTexMode == WT_MODE_YANSE)*/
    mode = [mode stringByAppendingString:@"yanse"];
    typeSelected = TYPE_ZONE_TEXTURE+1;
    /*[self showSecondLevel];
     [self triangle0].hidden = FALSE;
     [self triangle1].hidden = TRUE;
     [self triangle2].hidden = TRUE;
     [self triangle3].hidden = TRUE;*/
    [self updateShotcut];
    [self hideSign];
    
    //_pottery.textureID = [_textureManager convertToTexturenew:_pottery.textureID];
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

- (IBAction)attachTexTap:(UITapGestureRecognizer *)sender {
    NSLog(@"tap");
    
    CGPoint location = [sender locationInView:self.view];
    CGPoint translation = location;
    WTAppDelegate *delegate = [[UIApplication sharedApplication] delegate];
     if (clearmode == 1)
     {
         
         
     }
     else if (pflag == true){
         
     } else {
         if (texName == nil || [texName isEqualToString: @""]) {
             texName = @"c_1.png";//return;
         }
         NSLog(@"11");
         float threshold = 1.0f;
         GLKVector3 camera = _cameraPoint;
         
         //FIXME gravity change the position of camera
         int level = -2;
         float y;
         bool isOnPottery = [self findLevelSelected:location Perspective:_perspective Pottery:_pottery Camera:camera TouchedLevel:&level];
         //get the position of point in the world
         //    float scale = _pottery.getBoundingBox.minHeight/_pottery.getHeight;
         float scale = _pottery.getBoundingBox.minHeight/_pottery.getHeight;

             y = (float)level/(float)WT_NUM_LEVEL;
             if (isOnPottery ){//&& [delegate.textureManager couldAddTexture:y :scale]) {
                 //[_textureManager backupImgData];
                 //draw texture line onto the origin texture
                 //            [_textureManager addTexture: y :texName:scale];
                 [_textureManager addTextureAndRecord:y :texName :scale];
                 delegate.texture = [_textureManager texturenumber];
                 _pottery.textureID = [_textureManager convertToTexturenew:_pottery.textureID];
                 //tprice += nowprice;
                 //delegate.tprice = tprice;
                 //UIImage *tt =[_textureManager addImage:[_textureManager glToUIImage] toImage: [_textureManager glToUIImage3]];
                 //test.image = tt;
                 [_textureManager backupImgData2];
                 [_textureManager restoreImgData];
                 
             }else{
                 //if outside, then restore
                 [_textureManager addTextureNo:y :texName :scale];
                 delegate.texture = [_textureManager texturenumber];
                 _pottery.textureID = [_textureManager convertToTexturenew:_pottery.textureID];
                 [_textureManager backupImgData2];
                 [_textureManager restoreImgData];
             }
             [_textureManager freeBackupData];
         
     }

    
    /*num = (num +1) % 3;
    if (clearmode == 1) { //clearmode
        float threshold = 1.0f;
        //texName = @"textureTemp.png";

     
        GLKVector3 camera = _cameraPoint;
     
        //FIXME gravity change the position of camera
        int level = -2;
        float y;
        bool isOnPottery = [self findLevelSelected:location Perspective:_perspective Pottery:_pottery Camera:camera TouchedLevel:&level];
        //get the position of point in the world
        //    float scale = _pottery.getBoundingBox.minHeight/_pottery.getHeight;
        float scale = _pottery.getBoundingBox.minHeight/_pottery.getHeight;
        NSString *texTempName;
        //WTAppDelegate *delegate = [UIApplication sharedApplication].delegate;
        //[delegate.textureManager setflag:false];
        if (sender.state == UIGestureRecognizerStateBegan){
            [_textureManager backupImgData];
            if (isOnPottery){
                y = (float)level/(float)WT_NUM_LEVEL;
                //draw white transparent line in the backup texture
                if ([delegate.textureManager couldAddTexture:y :scale]) {
                    texTempName = @"textureTemp.png";
                }else{
                    texTempName = @"textureTempForbidden.png";
                }
                [_textureManager addTexturewhite:y :texTempName:scale];
                _pottery.textureID = [_textureManager convertToTexturenew:_pottery.textureID];
            }
        }
        else if(sender.state == UIGestureRecognizerStateEnded){
            y = (float)level/(float)WT_NUM_LEVEL;
            if (isOnPottery && [delegate.textureManager couldAddTexture:y :scale] == false) {
                //[_textureManager backupImgData];
                //draw texture line onto the origin texture
                //            [_textureManager addTexture: y :texName:scale];
                [_textureManager deleteTexture:y :texName :scale];
                delegate.texture = [_textureManager texturenumber];
                _pottery.textureID = [_textureManager convertToTexturenew:_pottery.textureID];
                //tprice += nowprice;
                //delegate.tprice = tprice;
                [_textureManager backupImgData2];
                [_textureManager restoreImgData];
                
            }else{
                //if outside, then restore
                [_textureManager addTextureNo:y :texName :scale];
                delegate.texture = [_textureManager texturenumber];
                _pottery.textureID = [_textureManager convertToTexturenew:_pottery.textureID];
                [_textureManager backupImgData2];
                [_textureManager restoreImgData];
            }
            [_textureManager freeBackupData];
        }else if (sender.state == UIGestureRecognizerStateCancelled || sender.state == UIGestureRecognizerStateFailed){
            [_textureManager restoreImgData];
            _pottery.textureID = [_textureManager convertToTexturenew:_pottery.textureID];
            [_textureManager freeBackupData];
        }
        
    }
    else {
        if (pflag == true) //photomode
        {
            NSLog(@"flag: %d",pflag);
            float threshold = 1.0f;
            GLKVector3 camera = _cameraPoint;
            
            //FIXME gravity change the position of camera
            int level = -2;
            float y;
            bool isOnPottery = [self findLevelSelected:location Perspective:_perspective Pottery:_pottery Camera:camera TouchedLevel:&level];
            //get the position of point in the world
            //    float scale = _pottery.getBoundingBox.minHeight/_pottery.getHeight;
            float scale = _pottery.getBoundingBox.minHeight/_pottery.getHeight;
            NSString *texTempName;
            //WTAppDelegate *delegate = [UIApplication sharedApplication].delegate;
            //[delegate.textureManager setflag:true];
            if (sender.state == UIGestureRecognizerStateBegan){
                [_textureManager backupImgData];
                if (isOnPottery){
                    y = (float)level/(float)WT_NUM_LEVEL;
                    //draw white transparent line in the backup texture
                    if ([delegate.textureManager couldAddTexture:y :scale]) {
                        texTempName = @"textureTemp.png";
                    }else{
                        texTempName = @"textureTemp.png";
                        //texTempName = @"textureTempForbidden.png";
                    }
                    [_textureManager addTexturewhite:y :texTempName:scale];
                    _pottery.textureID = [_textureManager convertToTexturenew:_pottery.textureID];
                }
            }else if(sender.state == UIGestureRecognizerStateEnded){
                y = (float)level/(float)WT_NUM_LEVEL;
                if (isOnPottery) {
                    //draw texture line onto the origin texture
                    //            [_textureManager addTexture: y :texName:scale];
                    [_textureManager addTexturePhoto:y :photo :scale];
                    _pottery.textureID = [_textureManager convertToTexturenew:_pottery.textureID];
                    ex = true;
                    delegate.zipai = 1;
                    [_textureManager backupImgData2];
                    [_textureManager restoreImgData];
                }else{
                    //if outside, then restore
                    [_textureManager restoreImgData];
                    _pottery.textureID = [_textureManager convertToTexturenew:_pottery.textureID];
                }
                [_textureManager freeBackupData];
            }else if (sender.state == UIGestureRecognizerStateCancelled || sender.state == UIGestureRecognizerStateFailed){
                [_textureManager restoreImgData];
                _pottery.textureID = [_textureManager convertToTexturenew:_pottery.textureID];
                //[_textureManager freeBackupData];
            }
        }
        else //normal tiehua
        {
            
            if (texName == nil || [texName isEqualToString: @""]) {
                texName = @"c_1.png";//return;
            }
            NSLog(@"11");
            float threshold = 1.0f;
            GLKVector3 camera = _cameraPoint;
            
            //FIXME gravity change the position of camera
            int level = -2;
            float y;
            bool isOnPottery = [self findLevelSelected:location Perspective:_perspective Pottery:_pottery Camera:camera TouchedLevel:&level];
            //get the position of point in the world
            //    float scale = _pottery.getBoundingBox.minHeight/_pottery.getHeight;
            float scale = _pottery.getBoundingBox.minHeight/_pottery.getHeight;
            NSString *texTempName;
            NSString *texTempName1;
            //WTAppDelegate *delegate = [UIApplication sharedApplication].delegate;
            //[delegate.textureManager setflag:false];
            if (sender.state == UIGestureRecognizerStateBegan){
                //[_textureManager backupImgData];
                delegate.textureManager.testImage = nil;
                texTempName = @"textureTemp.png";texTempName1 =@"textureTempForbidden.png";
                [_textureManager newWhiteImg:texTempName:texTempName1:scale];
                if (isOnPottery){
                    y = (float)level/(float)WT_NUM_LEVEL;
                    ycopy = y;
                    //draw white transparent line in the backup texture
                    if ([delegate.textureManager couldAddTexture:y :scale]) {
                        [_textureManager addTexturewhitenew:y :texTempName:scale:0];
                    }else{
                        [_textureManager addTexturewhitenew:y :texTempName:scale:1];
                    }
                    //[_textureManager addTexturewhite:y :texTempName:scale];
                    _pottery.textureID = [_textureManager convertToTexturenew:_pottery.textureID];
                    NSLog(@"began!");
                }
            }else if(sender.state == UIGestureRecognizerStateEnded){
                y = (float)level/(float)WT_NUM_LEVEL;
                if (isOnPottery ){//&& [delegate.textureManager couldAddTexture:y :scale]) {
                    //[_textureManager backupImgData];
                    //draw texture line onto the origin texture
                    //            [_textureManager addTexture: y :texName:scale];
                    [_textureManager addTextureAndRecord:y :texName :scale];
                    delegate.texture = [_textureManager texturenumber];
                    _pottery.textureID = [_textureManager convertToTexturenew:_pottery.textureID];
                    //tprice += nowprice;
                    //delegate.tprice = tprice;
                    //UIImage *tt =[_textureManager addImage:[_textureManager glToUIImage] toImage: [_textureManager glToUIImage3]];
                    //test.image = tt;
                    [_textureManager backupImgData2];
                    [_textureManager restoreImgData];
                    
                }else{
                    //if outside, then restore
                    [_textureManager addTextureNo:y :texName :scale];
                    delegate.texture = [_textureManager texturenumber];
                    _pottery.textureID = [_textureManager convertToTexturenew:_pottery.textureID];
                    [_textureManager backupImgData2];
                    [_textureManager restoreImgData];
                }
                [_textureManager freeBackupData];
            }else if (sender.state == UIGestureRecognizerStateCancelled || sender.state == UIGestureRecognizerStateFailed){
                [_textureManager restoreImgData];
                _pottery.textureID = [_textureManager convertToTexturenew:_pottery.textureID];
                [_textureManager freeBackupData];
            }
        }
    }*/
}


-(IBAction)attachTex:(UIPanGestureRecognizer*)paramSender{
    NSLog(@"pan");
    WTAppDelegate *delegate = [[UIApplication sharedApplication] delegate];
    num = (num +1) % 3;
    if (clearmode == 1) { //clearmode
        float threshold = 1.0f;
        //texName = @"textureTemp.png";
        CGPoint translation = [paramSender translationInView:self.view];
        CGPoint location = [paramSender locationInView:self.view];
        
        GLKVector3 camera = _cameraPoint;
        
        //FIXME gravity change the position of camera
        int level = -2;
        float y;
        bool isOnPottery = [self findLevelSelected:location Perspective:_perspective Pottery:_pottery Camera:camera TouchedLevel:&level];
        //get the position of point in the world
        //    float scale = _pottery.getBoundingBox.minHeight/_pottery.getHeight;
        float scale = _pottery.getBoundingBox.minHeight/_pottery.getHeight;
        NSString *texTempName;
        //WTAppDelegate *delegate = [UIApplication sharedApplication].delegate;
        //[delegate.textureManager setflag:false];
        if (paramSender.state == UIGestureRecognizerStateBegan){
            [_textureManager backupImgData];
            if (isOnPottery){
                y = (float)level/(float)WT_NUM_LEVEL;
                //draw white transparent line in the backup texture
                if ([delegate.textureManager couldAddTexture:y :scale]) {
                    texTempName = @"textureTemp.png";
                }else{
                    texTempName = @"textureTempForbidden.png";
                }
                [_textureManager addTexturewhite:y :texTempName:scale];
                _pottery.textureID = [_textureManager convertToTexturenew:_pottery.textureID];
            }
        }else if(paramSender.state == UIGestureRecognizerStateChanged && num % 3 == 0){
            if (isOnPottery && fabs(translation.y) > threshold) {
                //draw white transparent line in the backup texture
                y = (float)level/(float)WT_NUM_LEVEL;
                if ([delegate.textureManager couldAddTexture:y :scale]) {
                    texTempName = @"textureTemp.png";
                }else{
                    texTempName = @"textureTempForbidden.png";
                }
                [_textureManager addWhiteTexture:y :texTempName :scale];
                _pottery.textureID = [_textureManager convertToTexturenew:_pottery.textureID];
                [paramSender setTranslation:CGPointMake(0, 0) inView:self.view];
            }
        }else if(paramSender.state == UIGestureRecognizerStateEnded){
            y = (float)level/(float)WT_NUM_LEVEL;
            if (isOnPottery && [delegate.textureManager couldAddTexture:y :scale] == false) {
                //[_textureManager backupImgData];
                //draw texture line onto the origin texture
                //            [_textureManager addTexture: y :texName:scale];
                [_textureManager deleteTexture:y :texName :scale];
                delegate.texture = [_textureManager texturenumber];
                _pottery.textureID = [_textureManager convertToTexturenew:_pottery.textureID];
                //tprice += nowprice;
                //delegate.tprice = tprice;
                [_textureManager backupImgData2];
                [_textureManager restoreImgData];
                
            }else{
                //if outside, then restore
                [_textureManager addTextureNo:y :texName :scale];
                delegate.texture = [_textureManager texturenumber];
                _pottery.textureID = [_textureManager convertToTexturenew:_pottery.textureID];
                [_textureManager backupImgData2];
                [_textureManager restoreImgData];
            }
            [_textureManager freeBackupData];
        }else if (paramSender.state == UIGestureRecognizerStateCancelled || paramSender.state == UIGestureRecognizerStateFailed){
            [_textureManager restoreImgData];
            _pottery.textureID = [_textureManager convertToTexturenew:_pottery.textureID];
            [_textureManager freeBackupData];
        }

    }
    else {
    if (pflag == true) //photomode
    {
        NSLog(@"flag: %d",pflag);
        float threshold = 1.0f;
        CGPoint translation = [paramSender translationInView:self.view];
        CGPoint location = [paramSender locationInView:self.view];
        GLKVector3 camera = _cameraPoint;
        
        //FIXME gravity change the position of camera
        int level = -2;
        float y;
        bool isOnPottery = [self findLevelSelected:location Perspective:_perspective Pottery:_pottery Camera:camera TouchedLevel:&level];
        //get the position of point in the world
        //    float scale = _pottery.getBoundingBox.minHeight/_pottery.getHeight;
        float scale = _pottery.getBoundingBox.minHeight/_pottery.getHeight;
        NSString *texTempName;
        //WTAppDelegate *delegate = [UIApplication sharedApplication].delegate;
        //[delegate.textureManager setflag:true];
        if (paramSender.state == UIGestureRecognizerStateBegan){
            [_textureManager backupImgData];
            if (isOnPottery){
                y = (float)level/(float)WT_NUM_LEVEL;
                //draw white transparent line in the backup texture
                if ([delegate.textureManager couldAddTexture:y :scale]) {
                    texTempName = @"textureTemp.png";
                }else{
                    texTempName = @"textureTemp.png";
                    //texTempName = @"textureTempForbidden.png";
                }
                [_textureManager addTexturewhite:y :texTempName:scale];
                _pottery.textureID = [_textureManager convertToTexturenew:_pottery.textureID];
            }
        }else if(paramSender.state == UIGestureRecognizerStateChanged  && num % 3 == 0){
            if (isOnPottery && fabs(translation.y) > threshold) {
                //draw white transparent line in the backup texture
                y = (float)level/(float)WT_NUM_LEVEL;
                if ([delegate.textureManager couldAddTexture:y :scale]) {
                    texTempName = @"textureTemp.png";
                }else{
                    texTempName = @"textureTemp.png";//texTempName = @"textureTempForbidden.png";
                }
                [_textureManager addTexturewhite:y :texTempName :scale];
                _pottery.textureID = [_textureManager convertToTexturenew:_pottery.textureID];
                [paramSender setTranslation:CGPointMake(0, 0) inView:self.view];
            }
            else{
                [_textureManager addTextureNo:y :texName :scale];
                delegate.texture = [_textureManager texturenumber];
                _pottery.textureID = [_textureManager convertToTexturenew:_pottery.textureID];
                [_textureManager backupImgData2];
                [_textureManager restoreImgData];
            }
            //[_textureManager restoreImgData2];
        }else if(paramSender.state == UIGestureRecognizerStateEnded){
            y = (float)level/(float)WT_NUM_LEVEL;
            if (isOnPottery) {
                //draw texture line onto the origin texture
                //            [_textureManager addTexture: y :texName:scale];
                [_textureManager addTexturePhoto:y :photo :scale];
                _pottery.textureID = [_textureManager convertToTexturenew:_pottery.textureID];
                ex = true;
                delegate.zipai = 1;
                [_textureManager backupImgData2];
                [_textureManager restoreImgData];
            }else{
                //if outside, then restore
                [_textureManager addTextureNo:y :texName :scale];
                delegate.texture = [_textureManager texturenumber];
                _pottery.textureID = [_textureManager convertToTexturenew:_pottery.textureID];
                [_textureManager backupImgData2];
                [_textureManager restoreImgData];

            }
            [_textureManager freeBackupData];
        }else if (paramSender.state == UIGestureRecognizerStateCancelled || paramSender.state == UIGestureRecognizerStateFailed){
            [_textureManager restoreImgData];
            _pottery.textureID = [_textureManager convertToTexturenew:_pottery.textureID];
            //[_textureManager freeBackupData];
        }
    }
    else //normal tiehua
    {
        
    if (texName == nil || [texName isEqualToString: @""]) {
        texName = @"c_1.png";//return;
        [delegate.textureManager setImgParameter:texName];
    }
       NSLog(@"11");
    float threshold = 1.0f;
    CGPoint translation = [paramSender translationInView:self.view];
    CGPoint location = [paramSender locationInView:self.view];
    GLKVector3 camera = _cameraPoint;
    
    //FIXME gravity change the position of camera
    int level = -2;
    float y;
    bool isOnPottery = [self findLevelSelected:location Perspective:_perspective Pottery:_pottery Camera:camera TouchedLevel:&level];
    //get the position of point in the world
//    float scale = _pottery.getBoundingBox.minHeight/_pottery.getHeight;
    float scale = _pottery.getBoundingBox.minHeight/_pottery.getHeight;
    NSString *texTempName;
    NSString *texTempName1;
    //WTAppDelegate *delegate = [UIApplication sharedApplication].delegate;
    //[delegate.textureManager setflag:false];
    if (paramSender.state == UIGestureRecognizerStateBegan){
        //[_textureManager backupImgData];
        delegate.textureManager.testImage = nil;
        texTempName = @"textureTemp.png";texTempName1 =@"textureTempForbidden.png";
        [_textureManager newWhiteImg:texTempName:texTempName1:scale];
        if (isOnPottery){
            y = (float)level/(float)WT_NUM_LEVEL;
            ycopy = y;
            //draw white transparent line in the backup texture
            if ([delegate.textureManager couldAddTexture:y :scale]) {
                [_textureManager addTexturewhitenew:y :texTempName:scale:0];
            }else{
                [_textureManager addTexturewhitenew:y :texTempName:scale:1];
            }
            //[_textureManager addTexturewhite:y :texTempName:scale];
            _pottery.textureID = [_textureManager convertToTexturenew:_pottery.textureID];
            NSLog(@"began!");
        }
    }else if(paramSender.state == UIGestureRecognizerStateChanged  && num % 3 == 0){
        if (isOnPottery && fabs(translation.y) > threshold) {
            //draw white transparent line in the backup texture
            y = (float)level/(float)WT_NUM_LEVEL;
            
            if(y != ycopy){
                if ([delegate.textureManager couldAddTexture:y :scale]) {
                    [_textureManager addTexturewhitenew:y :texTempName:scale:0];
                }else{
                    [_textureManager addTexturewhitenew:y :texTempName:scale:1];
                }
            //NSLog(@"began2!");
            //[_textureManager addTexturewhite:y :texTempName :scale];
             //NSLog(@"began3!");
            NSLog(@"y: %f", y);
            
            _pottery.textureID = [_textureManager convertToTexturenew:_pottery.textureID];
            [paramSender setTranslation:CGPointMake(0, 0) inView:self.view];
            ycopy = y;
            }
        }
    }else if(paramSender.state == UIGestureRecognizerStateEnded){
        y = (float)level/(float)WT_NUM_LEVEL;
        if (isOnPottery ){//&& [delegate.textureManager couldAddTexture:y :scale]) {
            //[_textureManager backupImgData];
            //draw texture line onto the origin texture
//            [_textureManager addTexture: y :texName:scale];
            [_textureManager addTextureAndRecord:y :texName :scale];
            delegate.texture = [_textureManager texturenumber];
            _pottery.textureID = [_textureManager convertToTexturenew:_pottery.textureID];
            //tprice += nowprice;
            //delegate.tprice = tprice;
            //UIImage *tt =[_textureManager addImage:[_textureManager glToUIImage] toImage: [_textureManager glToUIImage3]];
            //test.image = tt;
            [_textureManager backupImgData2];
            [_textureManager restoreImgData];
            
        }else{
            //if outside, then restore
            [_textureManager addTextureNo:y :texName :scale];
            delegate.texture = [_textureManager texturenumber];
            _pottery.textureID = [_textureManager convertToTexturenew:_pottery.textureID];
            [_textureManager backupImgData2];
            [_textureManager restoreImgData];
        }
        [_textureManager freeBackupData];
    }else if (paramSender.state == UIGestureRecognizerStateCancelled || paramSender.state == UIGestureRecognizerStateFailed){
        [_textureManager restoreImgData];
        _pottery.textureID = [_textureManager convertToTexturenew:_pottery.textureID];
        [_textureManager freeBackupData];
    }
    }
    }
}

-(void)loadTextureShotcut{
    
}

/*-(void)showSecondLevel{
//    [self triangle0].hidden = FALSE;
    [self bar].hidden = FALSE;
    [self bDown].hidden = FALSE;
    [self bUp].hidden = FALSE;
    [self bType0].hidden = FALSE;
    [self bType1].hidden = FALSE;
    [self bType2].hidden = FALSE;
    [self bType3].hidden = FALSE;
    [self bHide].hidden = FALSE;
    offset = 0;
}

-(void)hideSecondLevel{
    //    [self triangle0].hidden = FALSE;
    [self bar].hidden = TRUE;
    [self bDown].hidden = TRUE;
    [self bUp].hidden = TRUE;
    [self bType0].hidden = TRUE;
    [self bType1].hidden = TRUE;
    [self bType2].hidden = TRUE;
    [self bType3].hidden = TRUE;
    //
    [self triangle0].hidden = TRUE;
    [self triangle1].hidden = TRUE;
    [self triangle2].hidden = TRUE;
    [self triangle3].hidden = TRUE;
    //
    [self sign0].hidden = TRUE;
    [self sign1].hidden = TRUE;
    [self sign2].hidden = TRUE;
    [self sign3].hidden = TRUE;
    [self bHide].hidden = TRUE;
}*/

-(void)updateShotcut{
    int t = offset;
    WTAppDelegate *delegate = [[UIApplication sharedApplication] delegate];
    
    int end ;
    NSString* head;
    NSLog(@"typeselectes :%d", typeSelected);
    if ([mode isEqualToString:@"yanse"]) {
        if (typeSelected >0) end = [[delegate.imageManager.yanseTextureCount objectAtIndex:typeSelected-1] intValue];
        if (typeSelected == 1) head = @"c";
        if (typeSelected == 2) head = @"d";
        if (typeSelected == 3) head = @"g";
    }else {
        if (typeSelected >0) end = [[delegate.imageManager.qinhuaTextureCount objectAtIndex:typeSelected-1] intValue];
        if (typeSelected == 1) head = @"qg";
        if (typeSelected == 2) head = @"qd";
        if (typeSelected == 3) head = @"qc";
    }
    for (int i = t; i < t+4; i++) {
        NSString* name = nil;
        if (i - t < end) {
            NSString *tail; // = [NSString stringWithFormat:@"_%d.png",typeSelected,i];
            if(typeSelected > 0)
            {
                if([mode isEqualToString:@"yanse"])
                {
                    tail = [NSString stringWithFormat:@"_%d.png",i+1];
                    name = [head stringByAppendingString:tail];
                    //NSLog(@"name:%@", name);
                }else{
                    if([head isEqualToString: @"qg"] || [head isEqualToString: @"qd"]){
                        tail = [NSString stringWithFormat:@"_%d_b.png",i+1];
                    }
                    else{
                        tail = [NSString stringWithFormat:@"_%d.png",i+1];
                    }
                    name = [head stringByAppendingString:tail];
                    //NSLog(@"name:%@", name);
                }
            }
        }
        NSLog(@"%d-%d", i-t, end);
        switch (i-t) {
            case 0:
                [[self bType0] setImage:[delegate.imageManager getUIimg:name] forState: UIControlStateNormal];
                break;
            case 1:
                [[self bType1] setImage:[delegate.imageManager getUIimg:name] forState: UIControlStateNormal];
                break;
            case 2:
                [[self bType2] setImage:[delegate.imageManager getUIimg:name] forState: UIControlStateNormal];
                break;
            case 3:
                [[self bType3] setImage:[delegate.imageManager getUIimg:name] forState: UIControlStateNormal];
                break;
            default:
                break;
        }
    }
}

- (IBAction)chooseType0:(id)sender {
    //typeSelected = TYPE_ZONE_TEXTURE;
    /*[self showSecondLevel];
    [self triangle0].hidden = FALSE;
    [self triangle1].hidden = TRUE;
    [self triangle2].hidden = TRUE;
    [self triangle3].hidden = TRUE;*/
    if(ex == false) {
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
	{
		NSLog(@"支持相机");
	}
	if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary])
	{
		NSLog(@"支持图库");
	}
	if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeSavedPhotosAlbum])
	{
		NSLog(@"支持相片库");
	}
       
    UIActionSheet *actionSheet = [[UIActionSheet alloc]
                                  initWithTitle:@"选择贴图模式"
                                  delegate:self
                                  cancelButtonTitle:@"Cancel"
                                  destructiveButtonTitle:nil
                                  otherButtonTitles:@"相机", @"相册", nil];
        [actionSheet showInView:self.view];
    
        
      /*
       deleteflag = 1;
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary])
    {
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        picker.allowsEditing = YES;
        picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        [self presentViewController:picker animated:YES completion:nil];
        //[self presentModalViewController:picker animated:YES];
        
    } else {
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle:@"访问图片库错误"
                              message:@""
                              delegate:nil
                              cancelButtonTitle:@"OK!"
                              otherButtonTitles:nil];
        [alert show];
        //[alert release];
    }*/
        // The image picker will be retained by ItemDetailViewController
    // until it has been dismissed

    
    /*
    UIImagePickerController* picker = [[UIImagePickerController alloc]init];
	picker.view.backgroundColor = [UIColor orangeColor];
	UIImagePickerControllerSourceType sourcheType = UIImagePickerControllerSourceTypeCamera;
	picker.sourceType = sourcheType;
	picker.delegate = self;
	picker.allowsEditing = YES;
    [self presentViewController:picker animated:YES completion:nil];
    */
    
    //[self updateShotcut];
    }
    else{
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle:@"已有自拍贴图！"
                              message:@""
                              delegate:nil
                              cancelButtonTitle:@"OK!"
                              otherButtonTitles:nil];
        [alert show];
    }
    [self hideSign];
}

//照相机
/*
-(IBAction)takePicture:(id)sender
{
    UIImagePickerController *imagePicker =
    [[UIImagePickerController alloc] init];
    
    // 如果我们的设备有一个摄像头,我们想拍张照片,否则,我们只是挑选照片库
    if ([UIImagePickerController
         isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        [imagePicker setSourceType:UIImagePickerControllerSourceTypeCamera];
    } else {
        [imagePicker setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
    }
    
    // This line of code will generate 2 warnings right now, ignore them
    [imagePicker setDelegate:self];
    
    // Place image picker on the screen
    [self presentModalViewController:imagePicker animated:YES];
    
    // The image picker will be retained by ItemDetailViewController
    // until it has been dismissed
    //[imagePicker release];
}*/
//拍照后使用图片
/*- (void)imagePickerController:(UIImagePickerController *)picker
didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    //通过info对象得到用户所选取的图片
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    //将图片赋给uiimageview实例并显示
    [imageView setImage:image];
    //要关闭UIImagePickerController对象
    //必须掉用这个方法
    [self dismissModalViewControllerAnimated:YES];
}*/

//#pragma mark  -UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker
        didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo
{
    //imageView.image = image; //imageView为自己定义的UIImageView
    photo = image;
    //testimage.image = photo;
    pflag = true;
    NSLog(@"flag: %d",pflag);
    WTAppDelegate *delegate = [[UIApplication sharedApplication] delegate];
    delegate.zipai = 2;
    [delegate.textureManager setImgParameterI:image];
    //[imageView setUserInteractionEnabled:YES];
    //[imageView setMultipleTouchEnabled:YES];
    [picker dismissViewControllerAnimated:YES completion:nil];
    //[[picker parentViewController] dismissModalViewControllerAnimated:YES];
}

/*- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [[picker parentViewController] dismissModalViewControllerAnimated:YES];
    //[picker release];
}*/

/*- (IBAction)selectExistingPicture {
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary])
    {
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        picker.allowsEditing = YES;
        picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        [self presentModalViewController:picker animated:YES];
        
    } else {
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle:@"访问图片库错误"
                              message:@""
                              delegate:nil
                              cancelButtonTitle:@"OK!"
                              otherButtonTitles:nil];
        [alert show];
        //[alert release];
    }
}*/




- (IBAction)chooseType1:(id)sender {
    typeSelected = TYPE_LINE_TEXTURE;
    /*[self showSecondLevel];
    [self triangle0].hidden = TRUE;
    [self triangle1].hidden = FALSE;
    [self triangle2].hidden = TRUE;
    [self triangle3].hidden = TRUE;*/
    [self updateShotcut];
    [self hideSign];
}

- (IBAction)chooseType2:(id)sender {
    typeSelected = TYPE_XXXX_TEXTURE;
    /*[self showSecondLevel];
    [self triangle0].hidden = TRUE;
    [self triangle1].hidden = TRUE;
    [self triangle2].hidden = FALSE;
    [self triangle3].hidden = TRUE;*/
    [self updateShotcut];
    [self hideSign];
}

- (IBAction)chooseType3:(id)sender{
    typeSelected = TYPE_SELFDEFINED_TEXTURE;
    /*[self showSecondLevel];
    [self triangle0].hidden = TRUE;
    [self triangle1].hidden = TRUE;
    [self triangle2].hidden = TRUE;
    [self triangle3].hidden = FALSE;*/
    [self updateShotcut];
    [self hideSign];
}

-(void)hideSign{
    [self sign0].hidden = TRUE;
    [self sign1].hidden = TRUE;
    [self sign2].hidden = TRUE;
    [self sign3].hidden = TRUE;
}

- (IBAction)pageUp:(id)sender {
    if (offset>0) {
        offset -=1;
    }
    [self updateShotcut];
    [self hideSign];
}

- (IBAction)pageDown:(id)sender {
    WTAppDelegate *delegate = [[UIApplication sharedApplication] delegate];
    int end = 0;
    if ([mode isEqualToString:@"yanse"]) {
        end = [[delegate.imageManager.yanseTextureCount objectAtIndex:typeSelected-1] intValue];
    }else if([mode isEqualToString:@"qinhua"]){
        end = [[delegate.imageManager.qinhuaTextureCount objectAtIndex:typeSelected-1] intValue];
    }
    if (offset+4<end) {
        offset+=1;
    }
    [self updateShotcut];
    [self hideSign];
}

- (void)viewDidUnload {
    [self setSign0:nil];
    [self setSign1:nil];
    [self setSign2:nil];
    [self setSign3:nil];
    [self setBType1:nil];
    [self setBType2:nil];
    [self setBType3:nil];
    [self setBar:nil];
    [self setBDown:nil];
    [self setBUp:nil];
    [super viewDidUnload];
}
//- (IBAction)hideSecondLevel:(id)sender {
//    CGSize size = self.view.frame.size;
//    CGPoint location = [sender locationInView:self.view];
//    if (location.y > 0.4*size.height ) {
//        [self hideSecondLevel];
//    }
//}

- (IBAction)chooseTexture0:(id)sender {
    clearmode = -1;
    if(typeSelected != 0)
    {
    pflag = false;
    WTAppDelegate *delegate = [[UIApplication sharedApplication] delegate];
    //[delegate.textureManager setflag:false];
    int end = 0;
    if ([mode isEqualToString:@"yanse"]) {
        end = [[delegate.imageManager.yanseTextureCount objectAtIndex:typeSelected-1] intValue];//get count
    }else if([mode isEqualToString:@"qinhua"]){
        end = [[delegate.imageManager.qinhuaTextureCount objectAtIndex:typeSelected-1] intValue];
    }
    NSString* head;
        //if ([mode isEqualToString:@"yanse"]) {
        end = [[delegate.imageManager.yanseTextureCount objectAtIndex:typeSelected-1] intValue];
        if (typeSelected == 1) head = @"c";//@"yd";
        if (typeSelected == 2) head = @"d";
        if (typeSelected == 3) head = @"g";
        /*}else {
         end = [[delegate.imageManager.qinhuaTextureCount objectAtIndex:typeSelected-1] intValue];
         if (typeSelected == 1) head = @"qg";
         if (typeSelected == 2) head = @"qd";
         if (typeSelected == 3) head = @"qc";
         }*/
    if (offset < end) {
        NSString* name = nil;
        NSString *tail;
        if([head isEqualToString: @"qg"] || [head isEqualToString: @"qd"]){
            tail = [NSString stringWithFormat:@"_%d_b.png",offset+1];
        }
        else{
            tail = [NSString stringWithFormat:@"_%d.png",offset+1];
        }

        name = [head stringByAppendingString:tail];
        NSLog(@"yyy: %@", name);
        texName = name;
        
        /*float height;
        if (typeSelected == 1) height = ydw[offset];
        if (typeSelected == 2) height = ygw[offset];
        if (typeSelected == 3) height = ycw[offset];
        if (typeSelected == 1) nowprice = ydp[offset];
        if (typeSelected == 2) nowprice = ygp[offset];
        if (typeSelected == 3) nowprice = ycp[offset];*/
        [delegate.textureManager setImgParameter:texName];
    }
    }
    //WTAppDelegate *delegate = [[UIApplication sharedApplication] delegate];
    /*int end = 0;
    NSString *head;
    if ([mode isEqualToString:@"yanse"]) {
        if(typeSelected == 1){
            head = @"yd";
            end = [[delegate.imageManager.yanseTextureCount objectAtIndex:typeSelected] intValue];
        }
        else if(typeSelected == 2)
        {
        
        }
        else if(typeSelected == 3)
        {
            
        }
    }else if([mode isEqualToString:@"qinhua"]){
        if(typeSelected == 1) {
        head = @"qd";
        end = [[delegate.imageManager.qinhuaTextureCount objectAtIndex:typeSelected] intValue];
        }
    }
    if (offset < end) {
        NSString* name = nil;
        NSString *tail = [NSString stringWithFormat:@"_%d.png",offset];//typeSelected
        name = [mode stringByAppendingString:tail];
        texName = name;
        [delegate.textureManager setImgParameter:texName];
    }    */
}

- (IBAction)chooseTexture1:(id)sender {
    clearmode = -1;
    if(typeSelected != 0)
    {
    NSLog(@"offset: %d", offset);
    pflag = false;
    WTAppDelegate *delegate = [[UIApplication sharedApplication] delegate];
    //[delegate.textureManager setflag:false];
    int end = 0;
    if ([mode isEqualToString:@"yanse"]) {
        end = [[delegate.imageManager.yanseTextureCount objectAtIndex:typeSelected-1] intValue];//get count
    }else if([mode isEqualToString:@"qinhua"]){
        end = [[delegate.imageManager.qinhuaTextureCount objectAtIndex:typeSelected-1] intValue];
    }
    NSString* head;
        //if ([mode isEqualToString:@"yanse"]) {
        end = [[delegate.imageManager.yanseTextureCount objectAtIndex:typeSelected-1] intValue];
        if (typeSelected == 1) head = @"c";//@"yd";
        if (typeSelected == 2) head = @"d";
        if (typeSelected == 3) head = @"g";
        /*}else {
         end = [[delegate.imageManager.qinhuaTextureCount objectAtIndex:typeSelected-1] intValue];
         if (typeSelected == 1) head = @"qg";
         if (typeSelected == 2) head = @"qd";
         if (typeSelected == 3) head = @"qc";
         }*/
    if (offset+1 < end) {
        NSString* name = nil;
        
        NSString *tail;
        if([head isEqualToString: @"qg"] || [head isEqualToString: @"qd"]){
            tail = [NSString stringWithFormat:@"_%d_b.png",offset+2];
        }
        else{
            tail = [NSString stringWithFormat:@"_%d.png",offset+2];
        }
        name = [head stringByAppendingString:tail];
        texName = name;
        /*float height;
         if (typeSelected == 1) height = ydw[offset];
         if (typeSelected == 2) height = ygw[offset];
         if (typeSelected == 3) height = ycw[offset];
         if (typeSelected == 1) nowprice = ydp[offset];
         if (typeSelected == 2) nowprice = ygp[offset];
         if (typeSelected == 3) nowprice = ycp[offset];*/
        [delegate.textureManager setImgParameter:texName];
    }
    }
    /*if ([mode isEqualToString:@"yanse"]) {
        end = [[delegate.imageManager.yanseTextureCount objectAtIndex:typeSelected] intValue];//get count
    }else if([mode isEqualToString:@"qinhua"]){
        end = [[delegate.imageManager.qinhuaTextureCount objectAtIndex:typeSelected] intValue];
    }
    if (offset+1 < end) {
        NSString* name = nil;
        NSString *tail = [NSString stringWithFormat:@"_%d_%d.png",typeSelected,offset+1];
        name = [mode stringByAppendingString:tail];
        texName = name;
        [delegate.textureManager setImgParameter:texName];
    }*/
}

// 自拍覆盖普通 //

- (IBAction)chooseTexture2:(id)sender {
    clearmode = -1;
    if(typeSelected != 0)
    {
    pflag = false;
    WTAppDelegate *delegate = [[UIApplication sharedApplication] delegate];
    //[delegate.textureManager setflag:false];
        //imageView.image = [delegate.textureManager test];
    int end = 0;
    if ([mode isEqualToString:@"yanse"]) {
        end = [[delegate.imageManager.yanseTextureCount objectAtIndex:typeSelected-1] intValue];
    }else if([mode isEqualToString:@"qinhua"]){
        end = [[delegate.imageManager.qinhuaTextureCount objectAtIndex:typeSelected-1] intValue];
    }
    NSString* head;
        //if ([mode isEqualToString:@"yanse"]) {
        end = [[delegate.imageManager.yanseTextureCount objectAtIndex:typeSelected-1] intValue];
        if (typeSelected == 1) head = @"c";//@"yd";
        if (typeSelected == 2) head = @"d";
        if (typeSelected == 3) head = @"g";
        /*}else {
         end = [[delegate.imageManager.qinhuaTextureCount objectAtIndex:typeSelected-1] intValue];
         if (typeSelected == 1) head = @"qg";
         if (typeSelected == 2) head = @"qd";
         if (typeSelected == 3) head = @"qc";
         }*/
    if (offset+2 < end) {
        NSString* name = nil;
        NSString *tail;
        if([head isEqualToString: @"qg"] || [head isEqualToString: @"qd"]){
            tail = [NSString stringWithFormat:@"_%d_b.png",offset+3];
        }
        else{
            tail = [NSString stringWithFormat:@"_%d.png",offset+3];
        }

        name = [head stringByAppendingString:tail];
        texName = name;
        /*float height;
         if (typeSelected == 1) height = ydw[offset];
         if (typeSelected == 2) height = ygw[offset];
         if (typeSelected == 3) height = ycw[offset];
         if (typeSelected == 1) nowprice = ydp[offset];
         if (typeSelected == 2) nowprice = ygp[offset];
         if (typeSelected == 3) nowprice = ycp[offset];*/
        [delegate.textureManager setImgParameter:texName];
    }
    }
}

- (IBAction)chooseTexture3:(id)sender {
    clearmode = -1;
    if(typeSelected != 0)
    {
    pflag = false;
    WTAppDelegate *delegate = [[UIApplication sharedApplication] delegate];
    //[delegate.textureManager setflag:false];
    int end = 0;
    if ([mode isEqualToString:@"yanse"]) {
        end = [[delegate.imageManager.yanseTextureCount objectAtIndex:typeSelected-1] intValue];
    }else if([mode isEqualToString:@"qinhua"]){
        end = [[delegate.imageManager.qinhuaTextureCount objectAtIndex:typeSelected-1] intValue];
    }
    NSString* head;
    //if ([mode isEqualToString:@"yanse"]) {
        end = [[delegate.imageManager.yanseTextureCount objectAtIndex:typeSelected-1] intValue];
        if (typeSelected == 1) head = @"c";//@"yd";
        if (typeSelected == 2) head = @"d";
        if (typeSelected == 3) head = @"g";
    /*}else {
        end = [[delegate.imageManager.qinhuaTextureCount objectAtIndex:typeSelected-1] intValue];
        if (typeSelected == 1) head = @"qg";
        if (typeSelected == 2) head = @"qd";
        if (typeSelected == 3) head = @"qc";
    }*/
    if (offset+3 < end) {
        NSString* name = nil;
        NSString *tail;
        if([head isEqualToString: @"qg"] || [head isEqualToString: @"qd"]){
            tail = [NSString stringWithFormat:@"_%d_b.png",offset+4];
        }
        else{
            tail = [NSString stringWithFormat:@"_%d.png",offset+4];
        }

        name = [head stringByAppendingString:tail];
        texName = name;
        /*float height;
         if (typeSelected == 1) height = ydw[offset];
         if (typeSelected == 2) height = ygw[offset];
         if (typeSelected == 3) height = ycw[offset];
         if (typeSelected == 1) nowprice = ydp[offset];
         if (typeSelected == 2) nowprice = ygp[offset];
         if (typeSelected == 3) nowprice = ycp[offset];*/
        [delegate.textureManager setImgParameter:texName];
    }
    }
}


- (IBAction)clear:(id)sender {
    /*WTAppDelegate *delegate = [[UIApplication sharedApplication] delegate];
//    [delegate.textureManager setupBasicImg:@"t4.jpg"];
    [delegate.textureManager clearTexture:delegate.backTexName];
    _pottery.textureID = [_textureManager convertToTexture:_pottery.textureID];
    delegate.texture = 0;
    delegate.zipai = 0;
    tprice = 0;
    ex = false;*/
    clearmode = 1;
}

- (IBAction)next:(id)sender {
    //NSLog(@"tzipai : %d", delegate.zipai);
    WTAppDelegate *delegate = [[UIApplication sharedApplication] delegate];
    [delegate.textureManager restoreImgData2];
    if ([mode isEqualToString:@"yanse"]) {
        //WTAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
        delegate.attatchTexMode = WT_MODE_QINHUA;
        [self performSegueWithIdentifier:@"youShang" sender:self];
    }else if([mode isEqualToString:@"qinhua"]){
        [self performSegueWithIdentifier:@"qinHua" sender:self];
    }
}
/*
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
    if (([self.view window] == nil)) {
        //_textureManager= nil;
        //transform the model world according to gravity
    }
    // Dispose of any resources that can be recreated.
}*/

-(void)viewWillDisappear:(BOOL)animated{
    
    NSLog(@"willdisappear");
    
    if (deleteflag == 0){

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
    }
    //[super viewWillDisappear:animated];
    
    /*glDeleteTextures(1, &t1);
     t1 = [_background setupTexture:@"main_activity_background.png"];
     
     glDeleteTextures(1, &t2);
     
     
     
     glDeleteTextures(1, &t3);*/
    //self.view = nil;
    //self.context = nil;*/
}

- (void)viewDidDisappear:(BOOL)animated{
    //[super viewDidDisappear:animated];
    //[self tearDownGL];
    //[self.motionManager stopAccelerometerUpdates];
    //    _pottery = nil;
    //if ([EAGLContext currentContext] == self.context) {
        //[EAGLContext setCurrentContext:nil];
    //}
    //self.view = nil;
    //self.motionManager = nil;
    //self.context = nil;
    //self.effect = nil;
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




@end
