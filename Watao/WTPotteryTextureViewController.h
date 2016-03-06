//
//  WTPotteryTextureViewController.h
//  Watao
//
//  Created by 连 承亮 on 14-4-18.
//  Copyright (c) 2014年 连 承亮. All rights reserved.
//

#import "WTPotteryViewController.h"
#import "WTTexutureManager.h"
#import "WTAppDelegate.h"


enum {
    TYPE_ZONE_TEXTURE = 0,
    TYPE_LINE_TEXTURE = 1,
    TYPE_XXXX_TEXTURE = 2,
    TYPE_SELFDEFINED_TEXTURE = 3,
    TYPE_NUM
};

/*static float ydw[13] = {3.0f / 8, 2.0f / 8, 2.0f / 8, 2.0f / 8, 2.5f / 8, 2.8f / 8, 2.0f / 8, 2.5f / 8, 2.0f / 8, 3.0f / 8, 2.5f / 8, 2.5f / 8, 2.5f / 8};
static int ydp[13] = {25, 25, 28, 25, 30, 30, 30, 20, 28, 28, 18, 30, 28};
static float ygw[16] = {2.0f / 8, 3.0f / 8, 2.0f / 8, 2.5f / 8, 2.5f / 8, 2.0f / 8, 2.0f / 8, 2.0f / 8, 1.5f / 8, 2.0f / 8, 3.0f / 8, 7.0f / 8, 2.5f / 8, 3.0f / 8, 4.0f / 8, 2.0f / 8};
static int ygp[16] = {20, 35, 25, 28, 30, 28, 20, 28, 25, 25, 35, 35, 28, 30, 40, 30};

static float ycw[10] = {2.0f / 8, 1.0f / 8, 0.4f / 8, 2.0f / 8, 1.0f / 8, 0.5f / 8, 0.5f / 8, 0.5f / 8, 0.5f / 8, 0.5f / 8};
static int ycp[10] = {18, 25, 15, 28, 28, 38, 15, 18, 35, 30};*/

@interface WTPotteryTextureViewController : WTPotteryViewController <TexturePotteryDelegate,UIImagePickerControllerDelegate, UIActionSheetDelegate,UIPickerViewDataSource>{
    WTTexutureManager * _textureManager;
    int num;
    NSArray *pickerArray;
}

@property (nonatomic) int typeSelected;
@property (nonatomic, strong) NSString* mode;
@property (nonatomic) int offset;
@property (nonatomic, strong) NSString* texName;
@property (nonatomic) UIImage* photo;
@property (nonatomic) bool pflag;
@property (nonatomic) bool ex;
@property (nonatomic) int nowprice;
@property (nonatomic) int tprice;
@property (nonatomic) int clearmode;
@property (weak, nonatomic) IBOutlet UIImageView *test;
@property (nonatomic) float ycopy;
@property (nonatomic) int deleteflag;

@property (nonatomic) bool photoornot;
@property (weak, nonatomic) IBOutlet UIPickerView *pickerView;

-(IBAction)attachTex:(UIPanGestureRecognizer*)paramSender;
- (IBAction)chooseType0:(id)sender;
- (IBAction)chooseType1:(id)sender;
- (IBAction)chooseType2:(id)sender;
- (IBAction)chooseType3:(id)sender;

- (IBAction)pageUp:(id)sender;
- (IBAction)pageDown:(id)sender;
//action of up and down button

//- (IBAction)hideSecondLevel:(id)sender;

- (IBAction)chooseTexture0:(id)sender;
- (IBAction)chooseTexture1:(id)sender;
- (IBAction)chooseTexture2:(id)sender;
- (IBAction)chooseTexture3:(id)sender;

@property (weak, nonatomic) IBOutlet UIImageView *testimage;
@property (weak, nonatomic) IBOutlet UIButton *bType0;
@property (weak, nonatomic) IBOutlet UIButton *bType1;
@property (weak, nonatomic) IBOutlet UIButton *bType2;
@property (weak, nonatomic) IBOutlet UIButton *bType3;

@property (weak, nonatomic) IBOutlet UIImageView *sign0;
@property (weak, nonatomic) IBOutlet UIImageView *sign1;
@property (weak, nonatomic) IBOutlet UIImageView *sign2;
@property (weak, nonatomic) IBOutlet UIImageView *sign3;

@property (weak, nonatomic) IBOutlet UIImageView *bar;
@property (weak, nonatomic) IBOutlet UIButton *bDown;
@property (weak, nonatomic) IBOutlet UIButton *bUp;

- (IBAction)clear:(id)sender;

@end
