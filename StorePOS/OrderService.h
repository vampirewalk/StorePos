//
//  OrderService.h
//  StorePOS
//
//  Created by KevinShen on 2016/1/8.
//  Copyright © 2016年 mocacube. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Order.h"
#import <PromiseKit/PromiseKit.h>

@class DBService, NetworkService;

@interface OrderService : NSObject

- (AnyPromise *)addOrder:(Order *) order;
- (void)removeOrderAtIndex:(NSUInteger) index;
- (NSUInteger)countOfOrders;
- (Order *)objectInOrdersAtIndex:(NSUInteger)idx;

- (instancetype)initWithDBService:(DBService *) dbService networkService:(NetworkService *) networkService;
@end
