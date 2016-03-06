//
//  WTAppDelegate.m
//  Watao
//
//  Created by 连 承亮 on 14-2-27.
//  Copyright (c) 2014年 连 承亮. All rights reserved.
//

#import "WTAppDelegate.h"
#import <AlipaySDK/AlipaySDK.h>

@implementation WTAppDelegate

@synthesize pottery;
@synthesize pad;
@synthesize background;
@synthesize shadow;
@synthesize textureManager;
@synthesize imageManager;
@synthesize texList;
@synthesize config;
@synthesize attatchTexMode;
@synthesize backTexName;
@synthesize Price;
@synthesize Id;
@synthesize total;
@synthesize Colleciton;
@synthesize width;
@synthesize height;
@synthesize tiji;
@synthesize texture; //texture amount
@synthesize zipai;
@synthesize tprice; //texture price
@synthesize order_number;
@synthesize bottom;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    imageManager = [[WTImageManager alloc] init];
    [imageManager loadAllImgFromPath:@""]; //from root path
    pottery = [[WTPottery alloc] WTPotteryIH:WT_INIT_HEIGHT IR:WT_INIT_RADIUS MINH:WT_MIN_HEIGHT MINR:WT_MIN_RADIUS MAXH:WT_MAX_HEIGHT MAXR:WT_MAX_RADIUS TH:WT_THICKNESS];
    [pottery saveToFile:@"model.wt"];
    //read config from file
    [self readConfig:@"config.plist"];
    NSLog(@"%@",config);
    NSString *str = [config objectForKey:@"isPotterySaved"];
    total = [config objectForKey:@"total"];
    NSLog(@"total: %d", total);
    
    //int number = [[config objectForKey:@"Number"] intValue];
    //int price = [[config objectForKey:@"Price"] intValue];
    
    /*
    [dic addObject:[NSNumber numberWithInt:i] forKey:@"somekey"];
    //或者
    [dic addObject:@1 forKey:@"somekey"];
    //取出时
    i = [[dic objectForKey:@"somekey"] intValue];*/
    if ([str isEqualToString:@"true"]){
        //[pottery loadFromFile:@"temp.wt"];
    }
    pad = [[WTPad alloc] initUsingOBJWithPath:@"table"];
    background = [[WTBackground alloc] init];
    texList = [[WTTextureList alloc] init];
    shadow = [[WTShadow alloc] initUsingOBJWithPath:@"shadow"];
    //bottom = [[WTBottom alloc] initUsingOBJWithPath:@"bottom"];
    NSString *texName = @"clay.png";//@"t4.jpg";
    /*if ([[config objectForKey:@"isTextureSaved"] isEqualToString:@"true"]) {
        textureManager = [[WTTexutureManager alloc] init:texName];//initFromFile:@"savedTexture.png"];
    }else{
        textureManager = [[WTTexutureManager alloc] init:texName];
    }*/
    textureManager = [[WTTexutureManager alloc] init:@"clay.png"];
//    [textureManager setImgParameter:texName];
//    [textureManager addTexture:0 :@"texture.png" ];
    attatchTexMode = WT_MODE_YANSE;
    CGRect rect = [ UIScreen mainScreen ].bounds;
    CGSize size = rect.size;
    width = size.width;
    height = size.height;
    //NSArray *split = [NSStringFromCGRect(rx) componentsSeparatedByString:@","];
    //NSString *i2 = [split objectAtIndex:2] ;
    NSLog(@"width:%d height:%d", width, height);
    return YES;
}


-(bool)readConfig: (NSString* )fileName{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    NSString *txtPath = [documentsDirectory stringByAppendingPathComponent:fileName];
    NSString *name = [fileName stringByDeletingPathExtension];
    NSString *exestr = [fileName pathExtension];
    if ([fileManager fileExistsAtPath:txtPath] == NO) {
        NSString *resourcePath = [[NSBundle mainBundle] pathForResource:name ofType:exestr];
//        NSLog(@"the name is %@,,,%@", name, exestr);
        [fileManager copyItemAtPath:resourcePath toPath:txtPath error:&error];
        config = [[NSMutableDictionary alloc]initWithContentsOfFile:txtPath];
        return FALSE;
    }else{
        config = [[NSMutableDictionary alloc]initWithContentsOfFile:txtPath];
        return TRUE;
    }
}


- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    [pottery saveToFile:@"temp.wt"]; //save the shape
    [config setObject:@"true" forKey:@"isPotterySaved"];
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
    NSLog(@"%@",config);
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    [pottery saveToFile:@"temp.wt"]; //save the shape
    [config setObject:@"true" forKey:@"isPotterySaved"];
    [textureManager saveTextureToFile:@"savedTexture.png"];
    [config setObject:@"true" forKey:@"isTextureSaved"];
    //Price = 130 + 1/80 + Size/80;//??;
    [config setObject:[NSNumber numberWithInt:Price] forKey:@"Price"];
    //    NSString *path = [[NSBundle mainBundle] pathForResource:@"config" ofType:@"plist"];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docDir = [paths objectAtIndex: 0];
    NSString* docFile = [docDir stringByAppendingPathComponent: @"config.plist"];
    [config writeToFile:docFile atomically:YES];
    config = nil;
    pad = nil;
    pottery = nil;
}

-(void) collect{
    [config setObject:[NSNumber numberWithInt:total+1] forKey:@"total"];
}

-(void)getdata{
    
    //get webservicedata here
}

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {
    
    
    
    if ([url.host isEqualToString:@"safepay"]) {
        
        [[AlipaySDK defaultService] processAuth_V2Result:url
                                         standbyCallback:^(NSDictionary *resultDic) {
                                             NSLog(@"result = %@",resultDic);
                                             //NSString *resultStr = resultDic[@"result"];
                                         }];
        
    }
    
    return YES;
}

@end
