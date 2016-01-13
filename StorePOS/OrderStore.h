//
//  OrderStore.h
//  StorePOS
//
//  Created by KevinShen on 2016/1/8.
//  Copyright © 2016年 mocacube. All rights reserved.
//

#import <Realm/Realm.h>

@class Order;

@interface OrderStore : RLMObject
@property (copy, nonatomic) NSString *uuid;
@property (copy, nonatomic) NSString *customerName;
@property (copy, nonatomic) NSString *shippingMethod;
@property (copy, nonatomic) NSString *tableName;
@property (assign, nonatomic) NSInteger tableSize;
@property (strong, nonatomic) NSDate *created;

- (instancetype)initWithOrder:(Order *) order;
- (Order *)order;
@end
