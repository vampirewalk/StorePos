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

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"orders" : [Order class]};
}

+ (instancetype)orderNotificationWithJSON:(NSString *) JSON
{
    return [OrderNotification yy_modelWithJSON:JSON];
}

- (id)initWithOperation:(Operation)anOperation orders:(NSArray *) orders
{
    self = [super init];
    if (self) {
        _operation = anOperation;
        _orders = orders;
    }
    return self;
}

- (NSString *)toJSONString
{
    return [self yy_modelToJSONString];
}

@end
