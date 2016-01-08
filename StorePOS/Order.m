//
//  Order.m
//  StorePOS
//
//  Created by KevinShen on 2016/1/8.
//  Copyright © 2016年 mocacube. All rights reserved.
//

#import "Order.h"

@implementation Order

- (id)initWithUUID:(NSString *) anUUID customerName:(NSString *) aCustomerName shippingMethod:(NSString *) aShippingMethod tableName:(NSString *) aTableName tableSize:(NSInteger) aTableSize
{
    if ((self = [super init])) {
        _uuid = [anUUID copy];
        _customerName = [aCustomerName copy];
        _shippingMethod = [aShippingMethod copy];
        _tableName = [aTableName copy];
        _tableSize = aTableSize;
    }
    return self;
}

@end
