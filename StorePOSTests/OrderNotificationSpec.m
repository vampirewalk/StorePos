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
