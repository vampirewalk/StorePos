//
//  OrderSpec.m
//  StorePOS
//
//  Created by vampirewalk on 2016/1/9.
//  Copyright 2016年 mocacube. All rights reserved.
//

#import <Specta/Specta.h>
#define EXP_SHORTHAND
#import <Expecta/Expecta.h>
#import "Order.h"


SpecBegin(Order)

describe(@"Order", ^{
    
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
    });
    
    it(@"output JSON", ^{
        NSString *expetedJSON = [NSString stringWithFormat:@"{\"uuid\":\"%@\",\"customerName\":\"Kevin\",\"created\":\"%@\",\"shippingMethod\":\"DHL\",\"tableSize\":-1}", uuid, dateString];
        NSString *output = [order toJSONString];
        expect(output).to.equal(expetedJSON);
    });
    
    it(@"init with JSON", ^{
        NSString *JSON = @"{\"uuid\":\"E1CF0738-9400-4335-98AD-F882096C23C1\",\"customerName\":\"Kevin\",\"created\":\"2016-01-09T22:41:37+0800\",\"shippingMethod\":\"DHL\",\"tableSize\":-1}";
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        formatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
        formatter.dateFormat = @"yyyy-MM-dd'T'HH:mm:ssZ";
        NSDate *dateInJSON = [formatter dateFromString:@"2016-01-09T22:41:37+0800"];
        
        Order *orderWithJSON = [Order orderWithJSONString:JSON];
        expect(orderWithJSON.uuid).to.equal(@"E1CF0738-9400-4335-98AD-F882096C23C1");
        expect(orderWithJSON.customerName).to.equal(@"Kevin");
        expect(orderWithJSON.shippingMethod).to.equal(@"DHL");
        expect(orderWithJSON.tableSize).to.equal(-1);
        expect(orderWithJSON.created).to.equal(dateInJSON);
    });
    
    afterEach(^{
        order = nil;
        uuid = nil;
        dateString = nil;
    });
    
    afterAll(^{

    });
});

SpecEnd
