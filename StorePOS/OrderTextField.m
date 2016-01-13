//
//  OrderTextField.m
//  StorePOS
//
//  Created by KevinShen on 2016/1/11.
//  Copyright © 2016年 mocacube. All rights reserved.
//

#import "OrderTextField.h"

@implementation OrderTextField

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.lineDisabledColor = [UIColor cyanColor];
        self.lineNormalColor = [UIColor grayColor];
        self.lineSelectedColor = [UIColor whiteColor];
        self.inputTextColor = [UIColor whiteColor];
        self.inputPlaceHolderColor = [UIColor greenColor];
        self.font = [UIFont systemFontOfSize:22.0f];
        [self setInputFont:[UIFont systemFontOfSize:26.0f]];
    }
    return self;
}
@end
