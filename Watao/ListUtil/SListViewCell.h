//
//  SListViewCell.h
//  Watao
//
//  Created by 连 承亮 on 14-5-10.
//  Copyright (c) 2014年 连 承亮. All rights reserved.
//
//

#import <UIKit/UIKit.h>
/// 参照 UITableViewCell
@interface SListViewCell : UITableViewCell

@property (nonatomic, copy) NSString * reuseIdentifier;
@property (nonatomic, readonly) UIView * separatorView;

- (id)initWithReuseIdentifier:(NSString *) reuseIdentifier;

@end
