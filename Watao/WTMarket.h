//
//  WTMarket.h
//  Watao
//
//  Created by vegetablepig on 15-3-25.
//  Copyright (c) 2015年 连 承亮. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WTPotteryViewController.h"

@class WTMarket;

@interface WTMarket : UIViewController<UIWebViewDelegate> {
    //IBOutlet UITextField *textField;
    UIActivityIndicatorView *activityIndicatorView;
    
}
@property (weak, nonatomic) IBOutlet UIWebView *WebView;
@property (weak, nonatomic) IBOutlet UIButton *back;
//- (IBAction)buttonPress:(id) sender;
//- (void)loadWebPageWithString:(NSString*)urlString;

@end
