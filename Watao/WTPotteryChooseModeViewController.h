//
//  WTPotteryChooseModeViewController.h
//  Watao
//
//  Created by 连 承亮 on 14-5-9.
//  Copyright (c) 2014年 连 承亮. All rights reserved.
//

#import "WTPotteryViewController.h"

//prepare 2 sets of texture for the ID
@interface WTPotteryChooseModeViewController : WTPotteryViewController
@property (nonatomic) GLuint tIDQinhua;
@property (nonatomic) GLuint tIDYanse;
@property (nonatomic) GLKVector3 translationQ;
@property (nonatomic) GLKVector3 translationY;
@property (nonatomic) GLKMatrix4 matrixQ;
@property (nonatomic) GLKMatrix4 matrixY;
@property (nonatomic) float backgroundY;
@property (nonatomic) float initY;
@property (nonatomic, strong) WTBackground* bgYin;
@property (nonatomic, strong) WTBackground* bgYang;
//@property (weak, nonatomic) IBOutlet UIButton *bShare;
//- (IBAction)share:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *bWhiteBackcolor;
@property (weak, nonatomic) IBOutlet UIButton *bBlackBackcolor;
@property (weak, nonatomic) IBOutlet UIButton *bTransparentBackcolor;
- (IBAction)bWhiteTouchUp:(id)sender;
- (IBAction)bBlackTouchUp:(id)sender;
- (IBAction)bTransparentTouchUp:(id)sender;


@end
