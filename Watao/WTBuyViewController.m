//
//  WTBuyViewController.c
//  Watao
//
//  Created by fc on 14-7-31.
//  Copyright (c) 2014年 连 承亮. All rights reserved.
//

#import "WTBuyViewController.h"
#import "WTTexutureManager.h"
//#import "UMSocial.h"
#import "WTAppDelegate.h"
#import "Order.h"
#import "DataSigner.h"
#import <AlipaySDK/AlipaySDK.h>

#import "APAuthV2Info.h"
@implementation Product
@end

@implementation WTBuyViewController
@synthesize name;
@synthesize tel;
@synthesize home;
@synthesize pname;
@synthesize ex;
@synthesize email;
@synthesize areaText;
@synthesize pottery;
@synthesize areaValue=_areaValue;//, cityValue=_cityValue;
@synthesize price;
@synthesize myprice;
//@synthesize locatePicker=_locatePicker;

/*- (void)dealloc {
    [areaText release];
    [cityText release];
    [_cityValue release];
    [_areaValue release];
    [super dealloc];
}*/

/*public static final String BASE_URL = "http://nieyu.haojifang.cn/webservices/";
 public static final String GET_VERSION_URL = BASE_URL + "get_app_version";
 public static final String GET_DECORATOR_URL = BASE_URL + "get_decorators_list";
 public static final String GET_BASE_PRICE_UR L = BASE_URL + "";
 public static final String UPLOAD_ORDER = BASE_URL + "save_order";
 public static final String LOGIN_URL = BASE_URL + "save_user";
 public static final String CHANGE_ORDER_STATUS = BASE_URL + "update_order_flag";*/

-(void)setAreaValue:(NSString *)areaValue
{
    if (![_areaValue isEqualToString:areaValue]) {
        //_areaValue = [areaValue retain];
        self.areaText.text = areaValue;
    }
}

/*-(void)setCityValue:(NSString *)cityValue
{
    if (![_cityValue isEqualToString:cityValue]) {
        _cityValue = [cityValue retain];
        self.cityText.text = cityValue;
    }
}*/
- (IBAction)test:(id)sender {
  
    /*
    
    NSString *URLString = @"http://nieyu.haojifang.cn/";
    NSURL *url = [NSURL URLWithString:URLString];
    NSData* data = xxxxxxxxxxx;
    [request setURL:url];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:data];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:[NSString stringWithFormat:@"%d", [data length]] forHTTPHeaderField:@"Content-Length"];
    NSURLConnection *conn = [[[NSURLConnection alloc] initWithRequest:request delegate:nil] autorelease];
    [conn start];
    
get:
    
    NSURL *url = [NSURL URLWithString:URLString];
    NSMutableURLRequest  *request = [[[NSMutableURLRequest alloc] init] autorelease];
    [request setURL:url];
    [request setHTTPMethod:@"GET"];
    NSURLConnection *conn = [[[NSURLConnection alloc] initWithRequest:request delegate:nil] autorelease];
    [conn start];*/
    
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    delegate = [[UIApplication sharedApplication] delegate];
    NSLog(@"zipai: %d", delegate.zipai);
    state = 0;
    URLhead = @"http://watao.jian-yin.com/";
    float _price = 0;
    _price=delegate.tiji/10+330+delegate.texture*8;
    //_price = 50 + delegate.texyure*8;
    NSLog(@"textnum: %d", delegate.texture);
    switch (delegate.texture) {
        case 0:
        case 1:
            break;
        case 2:
            _price += 10;
            break;
        case 3:
            _price += 30;
            break;
        case 4:
            _price += 40;
            break;
        case 5:
        case 6:
            _price += 50;
            break;
        case 7:
        case 8:
            _price += 70;
            break;
        default:
            _price += 150;
            break;
    }
    if (delegate.zipai == 1) _price+=30;
    //_price += delegate.tprice;
    price.text = [NSString stringWithFormat:@"%d元",(int)(_price)];
    myprice = _price;
    /*NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *imgPath = [documentsDirectory stringByAppendingPathComponent:@"screenshoot.png"];
    UIImage* tmp = [UIImage imageWithContentsOfFile:imgPath];
    NSLog(@"path: %@",imgPath);*/
    [pottery setImage:delegate.finishimage];
}
- (IBAction)send:(id)sender {
    /*name.delegate = self;
    tel.delegate =self;
    home.delegate = self;
    pname.delegate =self;
    ex.delegate = self;
    */
    state = 0;
    //WTAppDelegate *delegate = [[UIApplication sharedApplication] delegate];
    NSString *sname = name.text;
    NSString *stel = tel.text;
    NSString *semail = email.text;
    NSString *shome = home.text;
    NSString *spname = pname.text;
    NSString *sex = ex.text;
    
    
    
    NSRange range = [semail rangeOfString:@"@"];
    
    NSLog(@" range length:  %lu", (unsigned long)range.length);
    
    if (![sname  isEqual: @""] && ![stel  isEqual: @""] && ![shome  isEqual: @""] && ![spname  isEqual: @""] && ![sex  isEqual: @""] && ![semail isEqual:@""] && range.length !=0 ){
    NSLog(@"!!%@ !!%@ !!%@ !!%@ !!%@ !!%@", sname, stel, semail, shome, spname, sex);
    [self save_user];
    
    NSString *message = @"Made in Watao";
    UIWindow * window = [UIApplication sharedApplication].keyWindow;
    UIView *showview =  [[UIView alloc]init];
    showview.backgroundColor = [UIColor blackColor];
    showview.frame = CGRectMake(1, 1, 1, 1);
    showview.alpha = 1.0f;
    showview.layer.cornerRadius = 5.0f;
    showview.layer.masksToBounds = YES;
    [window addSubview:showview];
    
    UILabel *label = [[UILabel alloc]init];
    CGSize LabelSize = [message sizeWithFont:[UIFont systemFontOfSize:17] constrainedToSize:CGSizeMake(290, 9000)];
    label.frame = CGRectMake(10, 5, LabelSize.width, LabelSize.height);
    label.text = message;
    label.textColor = [UIColor whiteColor];
    label.textAlignment = 1;
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont boldSystemFontOfSize:15];
    [showview addSubview:label];
    showview.frame = CGRectMake((delegate.width - LabelSize.width - 20)/2, delegate.height - 100, LabelSize.width+20, LabelSize.height+10);
    [UIView animateWithDuration:1.5 animations:^{
        showview.alpha = 0;
    } completion:^(BOOL finished) {
        [showview removeFromSuperview];
    }];
        showview = nil;
    //int price = [self GetPrice];
        
        
    Product *product = [[Product alloc] init];
    product.subject = @"哇陶定制";
    product.body = @"testbody";
    product.price = (int)myprice;
    NSLog(@"price: %f", myprice);
    /*============================================================================*/
    /*=======================需要填写商户app申请的===================================*/
    /*============================================================================*/
	NSString *partner = @"2088811654507285";
    NSString *seller = @"3142837216@qq.com";
    NSString *privateKey = @"MIICWwIBAAKBgQCxHciEJgtkoAFtUAZphXj2SBECBCHSpkLtNYs7wVFZVIgcjclS moIm9pcC59N6R3YX9aroOwtiHWyqN/yesKUYpkurWjR/AbeKY1GfHGhiwrRnSxky MGlAwA4w8clOc8oK68variL37DY/M3j7OZqcEFR6RQ7APjKfG6erQcMjCwIDAQAB AoGALUzKzlHUtCXgd47yNOb4azU/dF6OMAxqLbV2KRBmuAxQy8zP4xq1kzWaphmZ EztXzwT8c202mh+gfWDYcdYIQ3rDpobkhpiIMCRky+zW7fxtQ/aFfFbfv9FCPZM/ Lpt7UmJFzfTk6Ad2cDBx8dkTk5QM7TfCgCPAyhgDsYKVg+ECQQDY4B8QEZBEuxEY A0Yi27fbrVx7aVxHzqWC+7Xv72Whaqx8GEbuJpKLW4UDHSVdcrmbdISlzQE23gPQ dgi3InoDAkEA0RF7FZUeX2n/tw4ylb63/FQ5ZWXPrAAwf3oL+6OSVoMzV9e9QBRj 97XdTW+QK6yIYltP/r7kSj2zMsqc6rzoWQJAJQbWptKo0+MwPu5IKiljEYFemb9a PvQ788nvvQAdVNq2ihVG/t/dAyfj5K00NOkiYTUadIg0nd53vj54rHOZawJAXctz 5vjhiXjqqluKQjgwHtpCbcVBaC8lkutUWO7HhlySOkSluQvs1YMX59e3XICpJ0dE GkvV66DGtnDD+WQK8QJAPhmEuJLMRWesk4wvmejzUSvd5TnVCHCnt3xScDr/yxWh 0qUQ1G8iXZLqS2+I4jZ/75js0vsDiNAaYYusNNiqEg==";
    
        /*
        NSString *privateKey = @"MIICdwIBADANBgkqhkiG9w0BAQEFAASCAmEwggJdAgEAAoGBAMFrdgZMa3rdYOx2 PeeZIgy1RyoOf8UxyWaTYaEtCuxxyy3rwCur99zwRXudbVOrxih6odzZ6cwVm/NF I8G3+TwGKA+GMpImG6sg81KCeDjVbhAV09pAIHaq7eTz3moEOUBc4qXBRxHhubJT QT1dGIxLbP6Ir8nGAIiUyKC/E7TlAgMBAAECgYEAv1tXqyeT9jxrFcZtvGHuI/B8 9Yjes/NrtAX/wvvTINX8E/R3bT13vaggtgmsDemV5Jpe5SbafcSrQ2SV2aPv+M/y Fs+l04l7A5fG90eSGTTxCHqo0W/qqspInYfN96Cipow/HeYE65RpZJ4Cc2    Bb0ogX IHtQd7iN9sUHWgPRF4ECQQDmknq9dRXVJKKKuQ300HhPcVxVbs0F2qb0jwHp7h+5 VpuC31HB+LcDukyx4j8uqyF29lOze3btUBjPygj8/wIRAkEA1sAX8JuMmg/JABBH Ac8S9bcYi4WX24VcRqzwCPQbRA/CrnLiA2KooK9AE5NPcS45pHAQQUwYoO66SSze 5N5xlQJBAKDAAPizd7w5JWVn7TYAXdCtLP2XGTN6pKmeRmxMiyuRGSyd+4crmpTr vurJ3NjxkIw64lIgwuJi1FmR9sBEHbECQAKK872dmeSZG0As8SpMUWUnbdr5Efs/ cQBFO/JfMZN0vFFketifam+8o32X2PD2IyiXSxn61K/TI9GJ/nmnSKECQGaiFmuy 64VMz4Cxuuq8gU3l0SNDLRXgGFvOIZFkf+wzQMNMKbM2jN8aQE1GbAGbY/gu74W7 RaVLrmkX4z7gEHE=";
    /*============================================================================*/
    /*============================================================================*/
    /*============================================================================*/

	//partner和seller获取失败,提示
    
	if ([partner length] == 0 ||
        [seller length] == 0 ||
        [privateKey length] == 0)
	{
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
														message:@"缺少partner或者seller或者私钥。"
													   delegate:self
											  cancelButtonTitle:@"确定"
											  otherButtonTitles:nil];
		[alert show];
        
		return;
	}
	
	/*
	 *生成订单信息及签名
	 */
	//将商品信息赋予AlixPayOrder的成员变量
    
    Order *order = [[Order alloc] init];
	order.partner = partner;
	order.seller = seller;
	order.tradeNO = [self generateTradeNO];//[self generateTradeNO]; //订单ID（由商家自行制定）
	order.productName = product.subject; //商品标题
	order.productDescription = product.body; //商品描述
	order.amount = [NSString stringWithFormat:@"%.2f",product.price]; //商品价格
	order.notifyURL =  @"http://www.xxx.com"; //回调URL
    
    order.service = @"mobile.securitypay.pay";
    order.paymentType = @"1";
    order.inputCharset = @"utf-8";
    order.itBPay = @"30m";
    order.showUrl = @"m.alipay.com";
	
	//应用注册scheme,在AlixPayDemo-Info.plist定义URL types
	NSString *appScheme = @"Watao";
	
	//将商品信息拼接成字符串
	NSString *orderSpec = [order description];
	NSLog(@"orderSpec = %@",orderSpec);
	
	//获取私钥并将商户信息签名,外部商户可以根据情况存放私钥和签名,只需要遵循RSA签名规范,并将签名字符串base64编码和UrlEncode
	id<DataSigner> signer = CreateRSADataSigner(privateKey);
	NSString *signedString = [signer signString:orderSpec];
	
	//将签名成功字符串格式化为订单字符串,请严格按照该格式
    NSString *orderString = nil;
    NSString *status = @"";
	if (signedString != nil) {
		orderString = [NSString stringWithFormat:@"%@&sign=\"%@\"&sign_type=\"%@\"",
                       orderSpec, signedString, @"RSA"];
        
        [[AlipaySDK defaultService] payOrder:orderString fromScheme:appScheme callback:^(NSDictionary *resultDic) {
            NSLog(@"reslut!! = %@",resultDic);
            //[status  stringByAppendingString:      ];
            NSLog(@"status: %@", [resultDic objectForKey:@"resultStatus"]);
            if ([[resultDic objectForKey:@"resultStatus"] isEqualToString:@"9000"])
            {//支付成功
                //NSLog(@"9000status: %@", [resultDic objectForKey:@"resultStatus"]);
                /*NSString *message = @"支付成功";
                UIWindow * window = [UIApplication sharedApplication].keyWindow;
                UIView *showview =  [[UIView alloc]init];
                showview.backgroundColor = [UIColor blackColor];
                showview.frame = CGRectMake(1, 1, 1, 1);
                showview.alpha = 1.0f;
                showview.layer.cornerRadius = 5.0f;
                showview.layer.masksToBounds = YES;
                [window addSubview:showview];
                
                UILabel *label = [[UILabel alloc]init];
                CGSize LabelSize = [message sizeWithFont:[UIFont systemFontOfSize:17] constrainedToSize:CGSizeMake(290, 9000)];
                label.frame = CGRectMake(10, 5, LabelSize.width, LabelSize.height);
                label.text = message;
                label.textColor = [UIColor whiteColor];
                label.textAlignment = 1;
                label.backgroundColor = [UIColor clearColor];
                label.font = [UIFont boldSystemFontOfSize:15];
                [showview addSubview:label];
                showview.frame = CGRectMake((delegate.width - LabelSize.width - 20)/2, delegate.height - 100, LabelSize.width+20, LabelSize.height+10);
                [UIView animateWithDuration:1.5 animations:^{
                    showview.alpha = 0;
                } completion:^(BOOL finished) {
                    [showview removeFromSuperview];
                }];*/
                NSString *mess = [NSString stringWithFormat: @"感谢使用哇陶\n订单号：%@\n客服电话：18079819897\n制作和配送时间约3周。\n公众号：哇陶科技", delegate.order_number];
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                                message:mess
                                                               delegate:self
                                                      cancelButtonTitle:@"确定"
                                                      otherButtonTitles:nil];
                [alert show];
                
                [self update_order:delegate.order_number];

            }else{//支付失败
                //NSLog(@"6001status: %@", [resultDic objectForKey:@"resultStatus"]);
                /*NSString *message = @"支付失败";
                UIWindow * window = [UIApplication sharedApplication].keyWindow;
                UIView *showview =  [[UIView alloc]init];
                showview.backgroundColor = [UIColor blackColor];
                showview.frame = CGRectMake(1, 1, 1, 1);
                showview.alpha = 1.0f;
                showview.layer.cornerRadius = 5.0f;
                showview.layer.masksToBounds = YES;
                [window addSubview:showview];
                
                UILabel *label = [[UILabel alloc]init];
                CGSize LabelSize = [message sizeWithFont:[UIFont systemFontOfSize:17] constrainedToSize:CGSizeMake(290, 9000)];
                label.frame = CGRectMake(10, 5, LabelSize.width, LabelSize.height);
                label.text = message;
                label.textColor = [UIColor whiteColor];
                label.textAlignment = 1;
                label.backgroundColor = [UIColor clearColor];
                label.font = [UIFont boldSystemFontOfSize:15];
                [showview addSubview:label];
                showview.frame = CGRectMake((delegate.width - LabelSize.width - 20)/2, delegate.height - 100, LabelSize.width+20, LabelSize.height+10);
                [UIView animateWithDuration:1.5 animations:^{
                    showview.alpha = 0;
                } completion:^(BOOL finished) {
                    [showview removeFromSuperview];
                }];*/
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                                message:@"支付失败！请重新支付。"
                                                               delegate:self
                                                      cancelButtonTitle:@"确定"
                                                      otherButtonTitles:nil];
                [alert show];
                
                
                

            }
        }];
        
        //[tableView deselectRowAtIndexPath:indexPath animated:YES];
    }
        

    }else {
        NSString *message = @"请完善信息";
        if (![sname  isEqual: @""] && ![stel  isEqual: @""] && ![shome  isEqual: @""] && ![spname  isEqual: @""] && ![sex  isEqual: @""] && ![semail isEqual:@""] && range.length == 0) message = @"请输入正确的邮箱地址";
        UIWindow * window = [UIApplication sharedApplication].keyWindow;
        UIView *showview =  [[UIView alloc]init];
        showview.backgroundColor = [UIColor blackColor];
        showview.frame = CGRectMake(1, 1, 1, 1);
        showview.alpha = 1.0f;
        showview.layer.cornerRadius = 5.0f;
        showview.layer.masksToBounds = YES;
        [window addSubview:showview];
        
        UILabel *label = [[UILabel alloc]init];
        CGSize LabelSize = [message sizeWithFont:[UIFont systemFontOfSize:17] constrainedToSize:CGSizeMake(290, 9000)];
        label.frame = CGRectMake(10, 5, LabelSize.width, LabelSize.height);
        label.text = message;
        label.textColor = [UIColor whiteColor];
        label.textAlignment = 1;
        label.backgroundColor = [UIColor clearColor];
        label.font = [UIFont boldSystemFontOfSize:15];
        [showview addSubview:label];
        showview.frame = CGRectMake((delegate.width - LabelSize.width - 20)/2, delegate.height - 100, LabelSize.width+20, LabelSize.height+10);
        [UIView animateWithDuration:1.5 animations:^{
            showview.alpha = 0;
        } completion:^(BOOL finished) {
            [showview removeFromSuperview];
        }];

    }
}

-(void)update_order:(NSString *)order_number{
    
    NSString *urlstring = [NSString stringWithFormat: @"http://watao.jian-yin.com/index.php/webservices/update_order_flag?order_number=%@&order_flag=已支付", delegate.order_number];
    urlstring = [urlstring stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding];
    //NSLog(urlstring);
    
    NSURL *url = [NSURL URLWithString:urlstring];
    NSURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    
    NSURLConnection *urlConnection = [NSURLConnection connectionWithRequest:request delegate:self];
    [urlConnection start];

}


-(int) GetPrice
{
    //WTAppDelegate *delegate = [[UIApplication sharedApplication] delegate];
    return delegate.Price;
}
/*
#pragma mark - HZAreaPicker delegate
-(void)pickerDidChaneStatus:(HZAreaPickerView *)picker
{
    if (picker.pickerStyle == HZAreaPickerWithStateAndCityAndDistrict) {
        self.areaValue = [NSString stringWithFormat:@"%@ %@ %@", picker.locate.state, picker.locate.city, picker.locate.district];
    } else{
        self.cityValue = [NSString stringWithFormat:@"%@ %@", picker.locate.state, picker.locate.city];
    }
}

-(void)cancelLocatePicker
{
    [self.locatePicker cancelPicker];
    self.locatePicker.delegate = nil;
    self.locatePicker = nil;
}


#pragma mark - TextField delegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if ([textField isEqual:self.areaText]) {
        [self cancelLocatePicker];
        self.locatePicker = [[[HZAreaPickerView alloc] initWithStyle:HZAreaPickerWithStateAndCityAndDistrict delegate:self] autorelease];
        [self.locatePicker showInView:self.view];
    } else {
        [self cancelLocatePicker];
        self.locatePicker = [[[HZAreaPickerView alloc] initWithStyle:HZAreaPickerWithStateAndCity delegate:self] autorelease];
        [self.locatePicker showInView:self.view];
    }
    return NO;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    [self cancelLocatePicker];
}*/

- (NSString *)generateTradeNO
{
	static int kNumber = 15;
	
	NSString *sourceStr = @"0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ";
	NSMutableString *resultStr = [[NSMutableString alloc] init];
	srand(time(0));
	for (int i = 0; i < kNumber; i++)
	{
		unsigned index = rand() % [sourceStr length];
		NSString *oneStr = [sourceStr substringWithRange:NSMakeRange(index, 1)];
		[resultStr appendString:oneStr];
	}
	return resultStr;
}

/*NSError *error;
 NSData *jsonData = [NSJSONSerialization dataWithJSONObject:data options:NSJSONWritingPrettyPrinted error:&error];//此处data参数是我上面提到的key为"data"的数组
 NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];*/

//-(void)save_user{
    /*
    NSURL *url = [NSURL URLWithString:@"http://nieyu.haojifang.cn/webservices/save_user"];
    NSMutableURLRequest *save_user = [NSMutableURLRequest requestWithURL:url];
    save_user.HTTPMethod = @"POST";
    [save_user setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    // 3.设置请求体
    NSDictionary *json = @{
                           /*@"order_id" : @"123",
                           @"user_id" : @"789",
                           @"shop" : @"Toll"
                           @"usename" : @"cai",
                           @"pwd": @"cai",
                           @"gender": @"2",
                           @"email": @"cairf888@126.com",

                           //@"data": @{"save_result":"faild"
                           };
    
    //    NSData --> NSDictionary
    // NSDictionary --> NSData
    NSData *data = [NSJSONSerialization dataWithJSONObject:json options:NSJSONWritingPrettyPrinted error:nil];
    save_user.HTTPBody = data;
    
    // 4.发送请求
    [NSURLConnection sendAsynchronousRequest:save_user queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        NSLog(@"%d", data.length);
    }];
/*#import "YYViewController.h"
 
    @interface YYViewController ()
    
    @end
    
    @implementation YYViewController
    
    - (void)viewDidLoad
    {
        [super viewDidLoad];
    }
    
    - (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
    {
        // 1.创建请求
        NSURL *url = [NSURL URLWithString:@"http://192.168.1.200:8080/MJServer/order"];
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
        request.HTTPMethod = @"POST";
        
        // 2.设置请求头
        [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        
        // 3.设置请求体
        NSDictionary *json = @{
                               @"order_id" : @"123",
                               @"user_id" : @"789",
                               @"shop" : @"Toll"
                               };
        
        //    NSData --> NSDictionary
        // NSDictionary --> NSData
        NSData *data = [NSJSONSerialization dataWithJSONObject:json options:NSJSONWritingPrettyPrinted error:nil];
        request.HTTPBody = data;
        
        // 4.发送请求
        [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
            NSLog(@"%d", data.length);
        }];
    }
    
    @end*/


-(void) save_user{
    NSString *uuid = [[[[UIDevice currentDevice] identifierForVendor] UUIDString] substringWithRange:NSMakeRange(0, 15)];
    NSLog(@"ID:%@", uuid);
    
    NSURL *url = [NSURL URLWithString:@"http://watao.jian-yin.com/index.php/webservices/save_user"];
    NSString *boundary = @"iOS_BOUNDARY_STRING";
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@", boundary];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"POST"];
    [request addValue:contentType forHTTPHeaderField:@"Content-Type"];
    
    NSMutableData *body = [NSMutableData data];
    
    /*[body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
     [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"; filename=\"test.png\"\r\n", @"image"] dataUsingEncoding:NSUTF8StringEncoding]];
     [body appendData:[@"Content-Type: application/octet-stream\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
     [body appendData:[NSData dataWithData:UIImagePNGRepresentation([delegate.imageManager getUIimg:@"clay.png"])]];
     */
    NSMutableDictionary *form =[NSMutableDictionary dictionaryWithCapacity:10];

    [form setObject:uuid forKey:@"username"];
    [form setObject:@"wataoios" forKey:@"password"];
    [form setObject:@"2" forKey:@"gender"];
    [form setObject:email.text forKey:@"email"];
    [form setObject:tel.text forKey:@"phone_number"];
    [form setObject:home.text forKey:@"address"];
    
    for (NSString*key in [form allKeys]) {
        NSLog(@"%@ - %@",key,[form objectForKey:key]);
        NSString *value = [form objectForKey:key];
        [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n%@",key, value] dataUsingEncoding:NSUTF8StringEncoding]];
    }
    
    [body appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [request setHTTPBody:body];
    NSURLConnection *urlConnection = [NSURLConnection connectionWithRequest:request delegate:self];
    [urlConnection start];
}

- (void) save_order{
    //NSArray *radius[10];
    NSString *shape = [NSString stringWithFormat:@"%f",[delegate.pottery getRadius:2]];
    for (int i = 1; i< 10; i++){
        shape = [shape stringByAppendingString:@","];
        shape = [shape stringByAppendingString: [NSString stringWithFormat:@"%f",[delegate.pottery getRadius:i*5+2]]];
    }
    //NSString *shape = [radius componentsJoinedByString:@","];
    NSLog(@"shape :%@", shape);
    NSString *uuid = [[[[UIDevice currentDevice] identifierForVendor] UUIDString] substringWithRange:NSMakeRange(0, 15)];
    NSLog(@"ID:%@", uuid);
    
    NSURL *url = [NSURL URLWithString:@"http://watao.jian-yin.com/index.php/webservices/save_order"];
    NSString *boundary = @"iOS_BOUNDARY_STRING";
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@", boundary];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"POST"];
    [request addValue:contentType forHTTPHeaderField:@"Content-Type"];
    
    NSMutableData *body = [NSMutableData data];
    
    [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"; filename=\"decoratore.png\"\r\n", @"image_decorator"] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[@"Content-Type: application/octet-stream\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[NSData dataWithData:UIImagePNGRepresentation(delegate.finishtexture)]];
    
    [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"; filename=\"image.png\"\r\n", @"image"] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[@"Content-Type: application/octet-stream\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[NSData dataWithData:UIImagePNGRepresentation(delegate.finishimage)]];
    if (delegate.zipai == 1){
        
    [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"; filename=\"zipai.png\"\r\n", @"customers[]"] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[@"Content-Type: application/octet-stream\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[NSData dataWithData:UIImagePNGRepresentation(delegate.textureManager.zipai)]];
    
    }
    NSMutableDictionary *form =[NSMutableDictionary dictionaryWithCapacity:10];
    
    [form setObject:uuid forKey:@"username"];
    //[form setObject:@"wataoios" forKey:@"order_number"];
    [form setObject:@"1" forKey:@"agree_post_to_market"];
    [form setObject:@"0.1" forKey:@"price"];
    [form setObject:pname.text forKey:@"name"];
    [form setObject:tel.text forKey:@"phone"];
    [form setObject:home.text forKey:@"address"];
    [form setObject:@"未支付" forKey:@"order_flag"];
    [form setObject:ex.text forKey:@"remark"];
    [form setObject:shape forKey:@"pottery_shape"];

    
    for (NSString*key in [form allKeys]) {
        NSLog(@"%@ - %@",key,[form objectForKey:key]);
        NSString *value = [form objectForKey:key];
        [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n%@",key, value] dataUsingEncoding:NSUTF8StringEncoding]];
    }
    
    [body appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [request setHTTPBody:body];
    NSURLConnection *save_order_Connection = [NSURLConnection connectionWithRequest:request delegate:self];
    [save_order_Connection start];
    
    
}


- (void)connection:(NSURLConnection *)urlConnection didFailWithError:(NSError *)error
{
    UIAlertView * alertV = [[UIAlertView alloc] initWithTitle:@"网络连接失败" message:[NSString  stringWithFormat:@"%@",error] delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alertV show];
}
- (void)connection:(NSURLConnection *)urlConnection didReceiveData:(NSData *)data
{
    //这里我们终于拿到了网络返回的 JSON 数据 data
    //delegate.mydata = data;
    NSString *result = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSLog([[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
    state ++;
    if (state == 1) [self save_order];
    else if (state == 2){
        NSArray *split = [result componentsSeparatedByString:@"order_number"];
        NSString *order = [[[split objectAtIndex:1] componentsSeparatedByCharactersInSet:[[NSCharacterSet characterSetWithCharactersInString:@"0123456789"] invertedSet]] componentsJoinedByString:@""];
        NSLog(order);
        delegate.order_number=order;
    }else{
        
    }
    
}

/*
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    if (([self.view window] == nil)) {
        //transform the model world according to gravity
    }
    // Dispose of any resources that can be recreated.
}*/


@end