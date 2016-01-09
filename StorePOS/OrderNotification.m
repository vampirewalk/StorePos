//
//  OrderNotification.m
//  StorePOS
//
//  Created by vampirewalk on 2016/1/9.
//  Copyright © 2016年 mocacube. All rights reserved.
//

#import "OrderNotification.h"
#import <YYModel/YYModel.h>

@implementation OrderNotification

- (id)initWithOperation:(Operation)anOperation order:(Order*)anOrder
{
    self = [super init];
    if (self) {
        _operation = anOperation;
        _order = anOrder;
    }
    return self;
}

- (NSString *)toJSONString
{
    return [self yy_modelToJSONString];
}

@end
