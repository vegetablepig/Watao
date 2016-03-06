//
//  WTPotteryFinViewController.h
//  Watao
//
//  Created by vegetablepig on 15-3-30.
//  Copyright (c) 2015年 连 承亮. All rights reserved.
//

#import "WTPotteryViewController.h"

@interface WTPotteryFinViewController : WTPotteryViewController {//<FinPotteryDelegate>{
    bool _changeFlag;
}
//@property (weak, nonatomic) IBOutlet UIButton *bSave;
//@property (weak, nonatomic) IBOutlet UIImageView *vSnapshot;
@property (nonatomic) GLuint frameBuffer;
@property (nonatomic) GLuint renderBuffer;
@property (nonatomic) GLuint depthBuffer;

@property (weak, nonatomic) IBOutlet UIButton *go;
-(IBAction)changeViewPoint:(UIPanGestureRecognizer*)paramSender;
- (IBAction)next:(id)sender;

-(void) screenshot;

@end
