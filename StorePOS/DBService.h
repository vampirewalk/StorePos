//
//  DBService.h
//  StorePOS
//
//  Created by KevinShen on 2016/1/8.
//  Copyright © 2016年 mocacube. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Order.h"

typedef enum : NSUInteger {
    Created,
} SortCriteria;

@interface DBService : NSObject
- (instancetype)initWithPersistentMode;
- (instancetype)initWithInMemoryMode;
- (Order *)queryOrderByUUID:(NSString *) uuid;
- (NSArray<Order *> *)queryAllOrdersBySortCriteria:(SortCriteria) criteria;
- (void)addOrder:(Order *) order;
- (BOOL)removeOrderByUUID:(NSString *) uuid;
- (BOOL)updateOrder:(Order *) order;
@end
