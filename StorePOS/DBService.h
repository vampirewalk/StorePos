//
//  DBService.h
//  StorePOS
//
//  Created by KevinShen on 2016/1/8.
//  Copyright © 2016年 mocacube. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Order.h"

@interface DBService : NSObject
- (instancetype)initWithPersistentMode;
- (instancetype)initWithInMemoryMode;
- (void)addOrder:(Order *) order;
- (Order *)queryOrderByUUID:(NSString *) uuid;
- (BOOL)removeOrderByUUID:(NSString *) uuid;
- (BOOL)updateOrder:(Order *) order;
@end
