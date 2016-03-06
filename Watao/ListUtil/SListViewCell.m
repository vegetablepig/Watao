//
//  SListViewCell.m
//  Watao
//
//  Created by 连 承亮 on 14-5-10.
//  Copyright (c) 2014年 连 承亮. All rights reserved.
//

#import "SListViewCell.h"

@implementation SListViewCell
@synthesize separatorView = _separatorView1;
@synthesize reuseIdentifier;

- (id)initWithReuseIdentifier:(NSString *)thereuseIdentifier {
    self = [super init];
    if (self) {
        // Initialization code
        self.reuseIdentifier = thereuseIdentifier;
        _separatorView1 = [[UIView alloc] init];
        [self addSubview:_separatorView1];
    }
    return self;
}

@end

