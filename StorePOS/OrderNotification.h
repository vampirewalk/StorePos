//
//  OrderNotification.h
//  StorePOS
//
//  Created by vampirewalk on 2016/1/9.
//  Copyright © 2016年 mocacube. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Order.h"

typedef enum : NSUInteger {
    Create,
    Update,
    Remove,
} Operation;

@interface OrderNotification : NSObject
@property (assign, nonatomic) Operation operation;
@property (strong, nonatomic) Order *order;

+ (instancetype)orderNotificationWithJSON:(NSString *) JSON;
- (instancetype)initWithOperation:(Operation)anOperation order:(Order*)anOrder;
- (NSString *)toJSONString;
@end
