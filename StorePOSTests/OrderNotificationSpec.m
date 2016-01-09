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
        
        notification = [[OrderNotification alloc] initWithOperation:Create order:order];
    });
    
    it(@"output JSON", ^{
        Operation operation = Create;
        NSString *expetedJSON = [NSString stringWithFormat:@"{\"operation\":%lu,\"order\":{\"uuid\":\"%@\",\"customerName\":\"Kevin\",\"created\":\"%@\",\"shippingMethod\":\"DHL\",\"tableSize\":-1}}", (unsigned long)operation, uuid, dateString];
        NSString *output = [notification toJSONString];
        expect(output).to.equal(expetedJSON);
    });  
    
    it(@"init with JSON", ^{
        NSString *JSON = @"{\"operation\":0,\"order\":{\"uuid\":\"4E97A130-C151-42A1-B6BE-247059539BC8\",\"customerName\":\"Kevin\",\"created\":\"2016-01-09T23:15:34+0800\",\"shippingMethod\":\"DHL\",\"tableSize\":-1}}";
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        formatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
        formatter.dateFormat = @"yyyy-MM-dd'T'HH:mm:ssZ";
        NSDate *dateInJSON = [formatter dateFromString:@"2016-01-09T23:15:34+0800"];
        
        OrderNotification *orderNotificationWithJSON = [OrderNotification orderNotificationWithJSON:JSON];
        expect(orderNotificationWithJSON.operation).to.equal(Create);
        Order *orderWithJSON = orderNotificationWithJSON.order;
        expect(orderWithJSON.uuid).to.equal(@"4E97A130-C151-42A1-B6BE-247059539BC8");
        expect(orderWithJSON.customerName).to.equal(@"Kevin");
        expect(orderWithJSON.shippingMethod).to.equal(@"DHL");
        expect(orderWithJSON.tableSize).to.equal(-1);
        expect(orderWithJSON.created).to.equal(dateInJSON);
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
