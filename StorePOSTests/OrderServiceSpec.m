//
//  OrderServiceSpec.m
//  StorePOS
//
//  Created by KevinShen on 2016/1/8.
//  Copyright 2016年 mocacube. All rights reserved.
//

#import "Specta.h"
#define EXP_SHORTHAND
#import "Expecta.h"
#import "OrderService.h"


SpecBegin(OrderService)

describe(@"OrderService", ^{
    
    __block OrderService *orderService = nil;
    __block Order *newOrder = nil;
    
    beforeAll(^{

    });
    
    beforeEach(^{
        orderService = [[OrderService alloc] init];
        newOrder = [[Order alloc] initWithUUID:[NSUUID UUID].UUIDString customerName:@"Kevin" shippingMethod:@"DHL" tableName:nil tableSize:NSNotFound];
    });
    
    it(@"add a new order", ^{
        [orderService addOrder:newOrder];
        expect([orderService countOfOrders]).to.equal(1);
    });
    
    it(@"remove an order at index", ^{
        [orderService addOrder:newOrder];
        [orderService removeOrderAtIndex:0];
        expect([orderService countOfOrders]).to.equal(0);
    });
    
    afterEach(^{
        orderService = nil;
        newOrder = nil;
    });
    
    afterAll(^{

    });
});

SpecEnd
