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
#import "NetworkService.h"

SpecBegin(OrderService)

describe(@"OrderService", ^{
    
    __block OrderService *orderService = nil;
    __block Order *newOrder = nil;
    __block id dbServiceMock;
    __block id networkServiceMock;
    
    beforeAll(^{

    });
    
    beforeEach(^{
        dbServiceMock = OCMClassMock([DBService class]);
        networkServiceMock = OCMClassMock([NetworkService class]);
        orderService = [[OrderService alloc] initWithDBService:dbServiceMock networkService:networkServiceMock];
        newOrder = [[Order alloc] initWithUUID:[NSUUID UUID].UUIDString customerName:@"Kevin" shippingMethod:@"DHL" tableName:nil tableSize:-1 created:[NSDate date]];
    });
    
    it(@"add a new order", ^{
        OCMExpect([(DBService *)dbServiceMock addOrder:[OCMArg any]]);
        waitUntil(^(DoneCallback done) {
            [orderService addOrder:newOrder].finally(^{
                expect([orderService countOfOrders]).to.equal(1);
                OCMVerify([(DBService *)dbServiceMock addOrder:[OCMArg any]]);
                done();
            });
        });
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
