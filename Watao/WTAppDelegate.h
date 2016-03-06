//
//  WTAppDelegate.h
//  Watao
//
//  Created by 连 承亮 on 14-2-27.
//  Copyright (c) 2014年 连 承亮. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GLKit/GLKit.h>
#import "WTPottery.h"
#import "WTPad.h"
#import "WTBackground.h"
#import "WTShadow.h"
#import "WTBottom.h"
#import "WTTexutureManager.h"
#import "WTImageManager.h"

#define WT_INIT_RADIUS 0.6f
#define WT_INIT_HEIGHT 1.2f
#define WT_MIN_HEIGHT 0.6f
#define WT_MIN_RADIUS 0.3f
#define WT_MAX_HEIGHT 3.6f
#define WT_MAX_RADIUS 1.2f
#define WT_THICKNESS 0.04f
//0.08f

enum{
    WT_MODE_QINHUA,
    WT_MODE_YANSE,
    WT_MODE_NUM
};

@interface WTAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) WTPottery *pottery;
@property (strong, nonatomic) WTPad *pad;
@property (strong, nonatomic) WTBackground *background;
@property (strong, nonatomic) WTShadow *shadow;
@property (strong, nonatomic) WTBottom *bottom;
@property (strong, nonatomic) WTTexutureManager *textureManager;
@property (strong, nonatomic) WTImageManager *imageManager;
@property (strong, nonatomic) WTTextureList *texList;
@property (strong, nonatomic) NSMutableDictionary *config;
@property (strong, nonatomic) NSString* backTexName;
@property (strong, nonatomic) UIImage *finishimage;
@property (strong, nonatomic) UIImage *finishtexture;
@property (nonatomic) int attatchTexMode;
@property (nonatomic) int Price;
@property (nonatomic) int Id;
@property (nonatomic) int total;
@property (nonatomic) BOOL Colleciton;
@property (nonatomic) int width;
@property (nonatomic) int height;
@property (nonatomic) float tiji;
@property (nonatomic) int texture;
@property (nonatomic) int zipai;
@property (nonatomic) int tprice;
@property (nonatomic) NSString *order_number;


-(void) collect;

@end
