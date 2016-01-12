//
//  OrderService.m
//  StorePOS
//
//  Created by KevinShen on 2016/1/8.
//  Copyright © 2016年 mocacube. All rights reserved.
//

#import "OrderService.h"
#import "DBService.h"
#import "OrderNotification.h"

@interface OrderService ()<InstanceDelegate>
@property (strong, nonatomic) NSMutableArray<Order *> *orders;
@property (strong, nonatomic) DBService *dbService;
@property (strong, nonatomic) id<Instancing> instance;
@property (strong, nonatomic) dispatch_semaphore_t semaphore; //ARC manage this
@end

@implementation OrderService

- (instancetype)initWithDBService:(DBService *) dbService instance:(id<Instancing>) instance
{
    self = [super init];
    if (self) {
        _orders = [NSMutableArray array];
        _dbService = dbService;
        [_orders addObjectsFromArray:[_dbService queryAllOrdersBySortCriteria:Created]];
        
        _instance = instance;
        _instance.delegate = self;
        
        self.semaphore = dispatch_semaphore_create(1);
        
    }
    return self;
}

- (AnyPromise *)addOrder:(Order *) order byReceivingMessage:(BOOL) byReceivingMessage
{
    /*
     dispatch_promise and thenInBackground dispatche the promise onto the default GCD queue.
     http://promisekit.org/dispatch-queues/
     Because orders may be accessed by multiple thread triggered by UI or network, so we use semaphore here to ensure thread safety.
     */
    return dispatch_promise(^{
        dispatch_semaphore_wait(_semaphore, DISPATCH_TIME_FOREVER);
        [self insertObject:order inOrdersAtIndex:_orders.count];
        dispatch_semaphore_signal(_semaphore);
    }).thenInBackground(^{
        return [_dbService addOrder:order];
    }).thenInBackground(^{
        if (!byReceivingMessage) {
            OrderNotification *notification = [[OrderNotification alloc] initWithOperation:Create order:order];
            [_instance sendMessage:[notification toJSONString]];
        }
    });
}

- (AnyPromise *)removeOrderByUUID:(NSString *) uuid byReceivingMessage:(BOOL) byReceivingMessage
{
    return dispatch_promise(^{
        dispatch_semaphore_wait(_semaphore, DISPATCH_TIME_FOREVER);
        if (_orders.count > 0) {
            NSInteger index = [self indexOfOrderByUUID:uuid];
            if (index != NSNotFound) {
                Order *order = _orders[index];
                [self removeObjectFromOrdersAtIndex:index];
                dispatch_semaphore_signal(_semaphore);
                return order;
            }
            else {
                dispatch_semaphore_signal(_semaphore);
                @throw [NSError cancelledError];
            }
        }
        else {
            dispatch_semaphore_signal(_semaphore);
            @throw [NSError cancelledError];
        }
    }).thenInBackground(^(Order *order){
        [_dbService removeOrderByUUID:uuid];
        return order;
    }).thenInBackground(^(Order *order){
        if (!byReceivingMessage) {
            OrderNotification *notification = [[OrderNotification alloc] initWithOperation:Remove order:order];
            [_instance sendMessage:[notification toJSONString]];
        }
    });
}

- (AnyPromise *)updateOrderByUUID:(NSString *) uuid withNewOrder:(Order *) newOrder byReceivingMessage:(BOOL) byReceivingMessage
{
    return dispatch_promise(^{
        dispatch_semaphore_wait(_semaphore, DISPATCH_TIME_FOREVER);
        NSInteger index = [self indexOfOrderByUUID:uuid];
        if (index != NSNotFound) {
            [self replaceObjectInOrdersAtIndex:index withObject:newOrder];
            dispatch_semaphore_signal(_semaphore);
        }
        else {
            dispatch_semaphore_signal(_semaphore);
            @throw [NSError cancelledError];
        }
    }).thenInBackground(^{
        return [_dbService updateOrder:newOrder];
    }).thenInBackground(^{
        if (!byReceivingMessage) {
            OrderNotification *notification = [[OrderNotification alloc] initWithOperation:Update order:newOrder];
            [_instance sendMessage:[notification toJSONString]];
        }
    });
}

- (NSInteger)indexOfOrderByUUID:(NSString *) uuid
{
    NSInteger index = NSNotFound;
    for (NSInteger index=0; index < _orders.count; index++) {
        if ([_orders[index].uuid isEqualToString:uuid]) {
            return index;
        }
    }
    
    return index;
}

- (Order *)orderByUUID:(NSString *) uuid
{
    NSInteger index = [self indexOfOrderByUUID:uuid];
    if (index != NSNotFound) {
        return _orders[index];
    }
    else {
        return nil;
    }
}

#pragma mark - InstanceDelegate

- (void)didReceiveMessage:(NSString *) message
{
    OrderNotification *notification = [OrderNotification orderNotificationWithJSON:message];
    Order *order = notification.order;
    NSString *uuid = order.uuid;
    switch (notification.operation) {
        case Create:
            [self addOrder:order byReceivingMessage:YES];
            break;
        case Update:
            [self updateOrderByUUID:uuid withNewOrder:order byReceivingMessage:YES];
            break;
        case Remove:
            [self removeOrderByUUID:uuid byReceivingMessage:YES];
            break;
            
        default:
            break;
    }
}

#pragma mark -

- (NSUInteger)countOfOrders
{
    return [[self orders] count];
}

- (void)getOrders:(id __unsafe_unretained []) buffer range:(NSRange) inRange
{
    [[self orders] getObjects:buffer range:inRange];
}

- (Order *)objectInOrdersAtIndex:(NSUInteger) idx
{
    return [[self orders] objectAtIndex:idx];
}

- (void)insertObject:(Order *) anObject inOrdersAtIndex:(NSUInteger) idx
{
    [[self orders] insertObject:anObject atIndex:idx];
}

- (void)insertOrders:(NSArray *) orderArray atIndexes:(NSIndexSet *) indexes
{
    [[self orders] insertObjects:orderArray atIndexes:indexes];
}

- (void)removeObjectFromOrdersAtIndex:(NSUInteger) idx
{
    [[self orders] removeObjectAtIndex:idx];
}

- (void)removeOrdersAtIndexes:(NSIndexSet *) indexes
{
    [[self orders] removeObjectsAtIndexes:indexes];
}

- (void)replaceObjectInOrdersAtIndex:(NSUInteger) idx withObject:(Order *) anObject
{
    [[self orders] replaceObjectAtIndex:idx withObject:anObject];
}

- (void)replaceOrdersAtIndexes:(NSIndexSet *) indexes withOrders:(NSArray *) orderArray
{
    [[self orders] replaceObjectsAtIndexes:indexes withObjects:orderArray];
}

@end
