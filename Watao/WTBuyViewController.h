//
//  WTBuyViewController.h
//  Watao
//
//  Created by fc on 14-7-31.
//  Copyright (c) 2014年 连 承亮. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WTPotteryViewController.h"
//#import "HZAreaPickerView.h"


@class WTBuyViewController;

@interface Product : NSObject{
@private
	float     _price;
	NSString *_subject;
	NSString *_body;
	NSString *_orderId;
}

@property (nonatomic, assign) float price;
@property (nonatomic, copy) NSString *subject;
@property (nonatomic, copy) NSString *body;
@property (nonatomic, copy) NSString *orderId;

@end

@interface WTBuyViewController : UIViewController{
    WTAppDelegate *delegate;
    NSString *URLhead;
    int state;
}
-(int)GetPrice;

-(void)Save_user;

-(void)update_order:(NSString *)order_number;

-(void)Save_order;

@property (strong, nonatomic) NSString *areaValue, *cityValue;
//@property (strong, nonatomic) HZAreaPickerView *locatePicker;
@property (weak, nonatomic) IBOutlet UITextField *areaText;
@property (weak, nonatomic) IBOutlet UITextField *name;
@property (weak, nonatomic) IBOutlet UITextField *email;
@property (weak, nonatomic) IBOutlet UITextField *tel;
@property (weak, nonatomic) IBOutlet UITextField *home;
@property (weak, nonatomic) IBOutlet UITextField *pname;
@property (weak, nonatomic) IBOutlet UITextField *ex;
@property (weak, nonatomic) IBOutlet UIButton *send;
@property (weak, nonatomic) IBOutlet UIImageView *pottery;
@property (weak, nonatomic) IBOutlet UITextField *price;
@property (nonatomic) float myprice;

@end