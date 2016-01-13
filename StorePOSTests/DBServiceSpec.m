//
//  DBServiceSpec.m
//  StorePOS
//
//  Created by KevinShen on 2016/1/8.
//  Copyright 2016年 mocacube. All rights reserved.
//

#import "Specta.h"
#define EXP_SHORTHAND
#import "Expecta.h"
#import "DBService.h"
#import "OrderStore.h"
#import <Realm/Realm.h>

@interface DBService ()
- (RLMRealm *)realm;
@end


SpecBegin(DBService)

describe(@"DBService", ^{
    
    __block DBService *service = nil;
    __block Order *order = nil;
    __block Order *order2 = nil;
    __block RLMRealm *realm = nil;
    
    beforeAll(^{

    });
    
    beforeEach(^{
        service = [[DBService alloc] initWithInMemoryMode];
        realm = [service realm];
        order = [[Order alloc] initWithUUID:[NSUUID UUID].UUIDString customerName:@"Kevin" shippingMethod:@"DHL" tableName:nil tableSize:-1 created:[NSDate date]];
        order2 = [[Order alloc] initWithUUID:[NSUUID UUID].UUIDString customerName:@"Jushy" shippingMethod:@"Fedex" tableName:nil tableSize:-1 created:[NSDate date]];
    });
    
    it(@"adds order", ^{
        [service addOrder:order];
        Order *orderFromDB = [service queryOrderByUUID:order.uuid];
        expect(orderFromDB.uuid).to.equal(order.uuid);
        expect(orderFromDB.customerName).to.equal(@"Kevin");
    });
    
    it(@"removes order", ^{
        [service addOrder:order];
        [service removeOrderByUUID:order.uuid];
        Order *orderFromDB = [service queryOrderByUUID:order.uuid];
        expect(orderFromDB).to.beNil();
    });
    
    it(@"updates order", ^{
        [service addOrder:order];
        order.customerName = @"Jushy";
        [service updateOrder:order];
        Order *orderFromDB = [service queryOrderByUUID:order.uuid];
        expect(orderFromDB).toNot.beNil();
        expect(orderFromDB.customerName).to.equal(@"Jushy");
    });
    
    it(@"query all orders", ^{
        [service addOrder:order];
        [service addOrder:order2];
        NSArray *orders = [service queryAllOrdersBySortCriteria:Created];
        expect(orders.count).to.equal(2);
        Order *order = orders[0];
        expect(order.customerName).to.equal(@"Kevin");
        Order *order2 = orders[1];
        expect(order2.customerName).to.equal(@"Jushy");
    });
    
    afterEach(^{
        RLMRealm *realm = [service realm];
        [realm beginWriteTransaction];
        [realm deleteAllObjects];
        [realm commitWriteTransaction];
        service = nil;
        order = nil;
    });
    
    afterAll(^{

    });
});

SpecEnd
