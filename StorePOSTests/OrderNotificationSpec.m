//
//  OrderNotificationSpec.m
//  StorePOS
//
//  Created by vampirewalk on 2016/1/9.
//  Copyright 2016年 mocacube. All rights reserved.
//

#import <Specta/Specta.h>
#define EXP_SHORTHAND
#import <Expecta/Expecta.h>
#import "OrderNotification.h"


SpecBegin(OrderNotification)

describe(@"OrderNotification", ^{
    
    __block OrderNotification *notification = nil;
    __block Order *order = nil;
    __block NSString *uuid = nil;
    __block NSString *dateString = nil;
    
    beforeAll(^{

    });
    
    beforeEach(^{
        uuid = [NSUUID UUID].UUIDString;
        NSDate *now = [NSDate date];
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        formatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
        formatter.dateFormat = @"yyyy-MM-dd'T'HH:mm:ssZ";
        dateString = [formatter stringFromDate:now];
        order = [[Order alloc] initWithUUID:uuid customerName:@"Kevin" shippingMethod:@"DHL" tableName:nil tableSize:-1 created:now];
        
        notification = [[OrderNotification alloc] initWithOperation:Create orders:@[order]];
    });
    
    it(@"output JSON", ^{
        Operation operation = Create;
        NSString *expetedJSON = [NSString stringWithFormat:@"{\"operation\":%lu,\"orders\":[{\"uuid\":\"%@\",\"customerName\":\"Kevin\",\"created\":\"%@\",\"shippingMethod\":\"DHL\",\"tableSize\":-1}]}", (unsigned long)operation, uuid, dateString];
        NSString *output = [notification toJSONString];
        expect(output).to.equal(expetedJSON);
    });  
    
    it(@"init with JSON", ^{
        NSString *JSON = @"{\"operation\":0,\"orders\":[{\"uuid\":\"9437C8F5-D742-46CB-9847-737C5809392C\",\"customerName\":\"Kevin\",\"created\":\"2016-01-12T21:35:16+0800\",\"shippingMethod\":\"DHL\",\"tableSize\":-1},{\"uuid\":\"E1CF0738-9400-4335-98AD-F882096C23C1\",\"customerName\":\"Kevin\",\"created\":\"2016-01-09T22:41:37+0800\",\"shippingMethod\":\"DHL\",\"tableSize\":-1}]}";
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        formatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
        formatter.dateFormat = @"yyyy-MM-dd'T'HH:mm:ssZ";
        NSDate *dateInJSON = [formatter dateFromString:@"2016-01-12T21:35:16+0800"];
        NSDate *dateInJSON2 = [formatter dateFromString:@"2016-01-09T22:41:37+0800"];
        
        OrderNotification *orderNotificationWithJSON = [OrderNotification orderNotificationWithJSON:JSON];
        expect(orderNotificationWithJSON.operation).to.equal(Create);
        NSArray *orders = orderNotificationWithJSON.orders;
        
        Order *orderWithJSON = orders.firstObject;
        expect(orderWithJSON.uuid).to.equal(@"9437C8F5-D742-46CB-9847-737C5809392C");
        expect(orderWithJSON.customerName).to.equal(@"Kevin");
        expect(orderWithJSON.shippingMethod).to.equal(@"DHL");
        expect(orderWithJSON.tableSize).to.equal(-1);
        expect(orderWithJSON.created).to.equal(dateInJSON);
        
        Order *orderWithJSON2 = orders[1];
        expect(orderWithJSON2.uuid).to.equal(@"E1CF0738-9400-4335-98AD-F882096C23C1");
        expect(orderWithJSON2.customerName).to.equal(@"Kevin");
        expect(orderWithJSON2.shippingMethod).to.equal(@"DHL");
        expect(orderWithJSON2.tableSize).to.equal(-1);
        expect(orderWithJSON2.created).to.equal(dateInJSON2);
    });
    
    afterEach(^{
        uuid = nil;
        dateString = nil;
        order = nil;
        notification = nil;
    });
    
    afterAll(^{

    });
});

SpecEnd
