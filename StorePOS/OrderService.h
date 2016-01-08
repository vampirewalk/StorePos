//
//  OrderService.h
//  StorePOS
//
//  Created by KevinShen on 2016/1/8.
//  Copyright © 2016年 mocacube. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Order.h"

@interface OrderService : NSObject

- (void)addOrder:(Order *) order;
- (void)removeOrderAtIndex:(NSUInteger) index;
- (NSUInteger)countOfOrders;
- (Order *)objectInOrdersAtIndex:(NSUInteger)idx;
@end
