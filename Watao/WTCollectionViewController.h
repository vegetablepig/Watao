//
//  WTCollectionViewController.h
//  Watao
//
//  Created by fc on 14-8-21.
//  Copyright (c) 2014年 连 承亮. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WTPotteryViewController.h"

@class WTCollectionViewController;

@interface WTCollectionViewController : UIViewController
{
    //WTPottery *_pottery;
}
@property (weak, nonatomic) IBOutlet UIButton *button;
- (IBAction)collection1:(id)sender;

@end