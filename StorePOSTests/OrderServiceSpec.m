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
    
    beforeAll(^{

    });
    
    beforeEach(^{
        orderService = [[OrderService alloc] init];
    });
    
    it(@"add a new order", ^{
        Order *newOrder = [[Order alloc] initWithUUID:[NSUUID UUID].UUIDString customerName:@"Kevin" shippingMethod:@"DHL" tableName:nil tableSize:NSNotFound];
        [orderService addOrder:newOrder];
        expect([orderService countOfOrders]).to.equal(1);
    });  
    
    afterEach(^{
        orderService = nil;
    });
    
    afterAll(^{

    });
});

SpecEnd
