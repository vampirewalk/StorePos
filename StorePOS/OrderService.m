//
//  OrderService.m
//  StorePOS
//
//  Created by KevinShen on 2016/1/8.
//  Copyright © 2016年 mocacube. All rights reserved.
//

#import "OrderService.h"

@interface OrderService ()
@property (strong, nonatomic) NSMutableArray<Order *> *orders;
@end

@implementation OrderService

- (instancetype)init
{
    self = [super init];
    if (self) {
        _orders = [NSMutableArray array];
    }
    return self;
}

- (void)addOrder:(Order *) order
{
    [self insertObject:order inOrdersAtIndex:_orders.count];
}

- (void)removeOrderAtIndex:(NSUInteger) index
{
    if (_orders.count > 0) {
        [self removeObjectFromOrdersAtIndex:index];
    }
}

- (void)replaceOrderAtIndex:(NSUInteger) index withNewOrder:(Order *) newOrder
{
    [self replaceOrderAtIndex:index withNewOrder:newOrder];
}

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
