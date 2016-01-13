//
//  Order.m
//  StorePOS
//
//  Created by KevinShen on 2016/1/8.
//  Copyright © 2016年 mocacube. All rights reserved.
//

#import "Order.h"
#import <YYModel/YYModel.h>

@implementation Order

+ (instancetype)orderWithJSONString:(NSString *) JSON
{
    return [Order yy_modelWithJSON:JSON];
}

- (instancetype)initWithUUID:(NSString *) anUUID customerName:(NSString *) aCustomerName shippingMethod:(NSString *) aShippingMethod tableName:(NSString *) aTableName tableSize:(NSInteger) aTableSize created:(NSDate *) aCreated
{
    if ((self = [super init])) {
        _uuid = [anUUID copy];
        _customerName = [aCustomerName copy];
        _shippingMethod = [aShippingMethod copy];
        _tableName = [aTableName copy];
        _tableSize = aTableSize;
        _created = aCreated;
    }
    return self;
}

- (NSString *)toJSONString
{
    return [self yy_modelToJSONString];
}

@end
