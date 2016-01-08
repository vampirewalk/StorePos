//
//  Order.h
//  StorePOS
//
//  Created by KevinShen on 2016/1/8.
//  Copyright © 2016年 mocacube. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Order : NSObject
@property (copy, nonatomic) NSString *uuid;
@property (copy, nonatomic) NSString *customerName;
@property (copy, nonatomic) NSString *shippingMethod;
@property (copy, nonatomic) NSString *tableName;
@property (assign, nonatomic) NSUInteger tableSize;

- (id)initWithUUID:(NSString *) anUUID customerName:(NSString *) aCustomerName shippingMethod:(NSString *) aShippingMethod tableName:(NSString *) aTableName tableSize:(NSUInteger) aTableSize;

@end
