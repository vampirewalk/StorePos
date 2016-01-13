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
#import <OCMock/OCMock.h>
#import "DBService.h"
#import "Instancing.h"

@interface OrderService ()
- (NSInteger)indexOfOrderByUUID:(NSString *) uuid;
- (Order *)orderByUUID:(NSString *) uuid;
- (NSUInteger)countOfOrders;
@end

SpecBegin(OrderService)

describe(@"OrderService", ^{
    
    __block OrderService *orderService = nil;
    __block Order *newOrder = nil;
    __block id dbServiceMock;
    __block id instanceMock;
    
    beforeAll(^{

    });
    
    beforeEach(^{
        dbServiceMock = OCMClassMock([DBService class]);
        instanceMock = OCMProtocolMock(@protocol(Instancing));
        orderService = [[OrderService alloc] initWithDBService:dbServiceMock instance:instanceMock];
        newOrder = [[Order alloc] initWithUUID:[NSUUID UUID].UUIDString customerName:@"Kevin" shippingMethod:@"DHL" tableName:nil tableSize:-1 created:[NSDate date]];
    });
    
    it(@"add a new order", ^{
        OCMExpect([(DBService *)dbServiceMock addOrder:[OCMArg isNotNil]]);
        OCMExpect([instanceMock sendMessage:[OCMArg isNotNil]]);
        waitUntil(^(DoneCallback done) {
            [orderService addOrder:newOrder byReceivingMessage:NO].finally(^{
                expect([orderService countOfOrders]).to.equal(1);
                OCMVerify([(DBService *)dbServiceMock addOrder:[OCMArg isNotNil]]);
                OCMVerify([instanceMock sendMessage:[OCMArg isNotNil]]);
                done();
            });
        });
    });
    
    it(@"remove an order by uuid", ^{
        OCMExpect([(DBService *)dbServiceMock removeOrderByUUID:[OCMArg isNotNil]]);
        OCMExpect([instanceMock sendMessage:[OCMArg isNotNil]]);
        waitUntil(^(DoneCallback done) {
            [orderService addOrder:newOrder byReceivingMessage:NO].finally(^{
                [orderService removeOrderByUUID:newOrder.uuid byReceivingMessage:NO]
                .finally(^{
                    expect([orderService countOfOrders]).to.equal(0);
                    OCMVerify([(DBService *)dbServiceMock removeOrderByUUID:[OCMArg isNotNil]]);
                    OCMVerify([instanceMock sendMessage:[OCMArg isNotNil]]);
                    done();
                });
            });
        });
    });
    
    it(@"update an order by uuid", ^{
        OCMExpect([(DBService *)dbServiceMock updateOrder:[OCMArg isNotNil]]);
        OCMExpect([instanceMock sendMessage:[OCMArg isNotNil]]);
        waitUntil(^(DoneCallback done) {
            [orderService addOrder:newOrder byReceivingMessage:NO].finally(^{
                newOrder.shippingMethod = @"Fedex";
                [orderService updateOrderByUUID:newOrder.uuid withNewOrder:newOrder byReceivingMessage:NO]
                .finally(^{
                    expect([orderService countOfOrders]).to.equal(1);
                    expect([orderService orderByUUID:newOrder.uuid].shippingMethod).to.equal(@"Fedex");
                    OCMVerify([(DBService *)dbServiceMock updateOrder:[OCMArg isNotNil]]);
                    OCMVerify([instanceMock sendMessage:[OCMArg isNotNil]]);
                    done();
                });
            });
        });
    });
    
    afterEach(^{
        orderService = nil;
        newOrder = nil;
    });
    
    afterAll(^{

    });
});

SpecEnd
