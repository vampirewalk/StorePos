//
//  OrderStore.m
//  StorePOS
//
//  Created by KevinShen on 2016/1/8.
//  Copyright © 2016年 mocacube. All rights reserved.
//

#import "OrderStore.h"
#import "Order.h"

@implementation OrderStore

- (instancetype)initWithOrder:(Order *) order
{
    self = [super init];
    if (self) {
        _uuid = [order.uuid copy];
        _customerName = [order.customerName copy];
        _shippingMethod = [order.shippingMethod copy];
        _tableName = [order.tableName copy];
        _tableSize = order.tableSize;
        _created = order.created;
    }
    return self;
}

+ (NSString *)primaryKey {
    return @"uuid";
}

- (Order *)order
{
    Order *order = [[Order alloc] initWithUUID:self.uuid customerName:self.customerName shippingMethod:self.shippingMethod tableName:self.tableName tableSize:self.tableSize created:self.created];
    return order;
}

@end
