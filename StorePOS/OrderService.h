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
#import "Instancing.h"

@class DBService, NetworkService;

@interface OrderService : NSObject

@property (strong, nonatomic,readonly) NSMutableArray<Order *> *orders;

- (instancetype)initWithDBService:(DBService *) dbService instance:(id<Instancing>) instance;

- (AnyPromise *)addOrder:(Order *) order byReceivingMessage:(BOOL) byReceivingMessage;
- (AnyPromise *)removeOrderByUUID:(NSString *) uuid byReceivingMessage:(BOOL) byReceivingMessage;
- (AnyPromise *)updateOrderByUUID:(NSString *) uuid withNewOrder:(Order *) newOrder byReceivingMessage:(BOOL) byReceivingMessage;

@end
