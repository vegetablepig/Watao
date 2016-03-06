//
//  WTTutorViewController.h
//  Watao
//
//  Created by fc on 14-8-21.
//  Copyright (c) 2014年 连 承亮. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WTPotteryViewController.h"

@class WTTutorViewController;

@interface WTTutorViewController : UIViewController
{
    WTPottery *_pottery;
    UIScrollView *imageScrollView;
    UIPageControl *pageControl;
}
@property (weak, nonatomic) IBOutlet UIButton *back;


@end
