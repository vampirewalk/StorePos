//
//  DBService.m
//  StorePOS
//
//  Created by KevinShen on 2016/1/8.
//  Copyright © 2016年 mocacube. All rights reserved.
//

#import "DBService.h"
#import <Realm/Realm.h>
#import "OrderStore.h"

static NSString *dbName = @"POSDatabase.realm";

@interface DBService ()
@property (nonatomic, assign) BOOL isInMemoryRealm;
@end

@implementation DBService

+ (NSString *)dbPath
{
    NSString *docPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *dbPath = [docPath stringByAppendingPathComponent:dbName];
    return dbPath;
}

- (instancetype)initWithPersistentMode
{
    self = [super init];
    if (self) {
        _isInMemoryRealm = NO;
    }
    return self;
}

- (instancetype)initWithInMemoryMode
{
    self = [super init];
    if (self) {
        _isInMemoryRealm = YES;
    }
    return self;
}

- (RLMRealm *)realm
{
    if (_isInMemoryRealm) {
        RLMRealmConfiguration *config = [RLMRealmConfiguration defaultConfiguration];
        config.inMemoryIdentifier = @"MyInMemoryRealm";
        return [RLMRealm realmWithConfiguration:config error:nil];
    }
    return [RLMRealm realmWithPath:[DBService dbPath]];
}

- (Order *)queryOrderByUUID:(NSString *) uuid
{
    RLMRealm *realm = [self realm];
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"uuid = %@", uuid];
    RLMResults *results = [OrderStore objectsInRealm:realm withPredicate:pred];
    if (results.count > 0) {
        OrderStore *store = results.firstObject;
        
        return store.order;
    }
    else {
        return nil;
    }
}

- (NSArray<Order *> *)queryAllOrdersBySortCriteria:(SortCriteria) criteria
{
    NSMutableArray *orders = [NSMutableArray array];
    RLMRealm *realm = [self realm];
    RLMResults<OrderStore *> *orderStores = [OrderStore allObjectsInRealm:realm];
    [orderStores sortedResultsUsingProperty:@"created" ascending:YES];
    for (OrderStore *store in orderStores) {
        [orders addObject:store.order];
    }
    return [orders copy];
}

- (void)addOrder:(Order *) order
{
    NSAssert(order != nil, @"order can't be nil");
    OrderStore *store = [[OrderStore alloc] initWithOrder:order];
    
    RLMRealm *realm = [self realm];
    [realm beginWriteTransaction];
    [OrderStore createInRealm:realm withValue:store];
    [realm commitWriteTransaction];
}

- (BOOL)removeOrderByUUID:(NSString *) uuid
{
    NSAssert(uuid != nil, @"uuid can't be nil");
    RLMRealm *realm = [self realm];
    
    OrderStore *store = [OrderStore objectInRealm:realm forPrimaryKey:uuid];
    if (store != nil) {
        [realm beginWriteTransaction];
        [realm deleteObject:store];
        [realm commitWriteTransaction];
        return YES;
    }
    else {
        return NO;
    }
}

- (BOOL)updateOrder:(Order *) order
{
    NSAssert(order != nil, @"order can't be nil");
    RLMRealm *realm = [self realm];
    OrderStore *store = [OrderStore objectInRealm:realm forPrimaryKey:order.uuid];
    if (store != nil) {
        [realm beginWriteTransaction];
        store.customerName = order.customerName;
        store.shippingMethod = order.shippingMethod;
        store.tableName = order.tableName;
        store.tableSize = order.tableSize;
        [OrderStore createOrUpdateInRealm:realm withValue:store];
        [realm commitWriteTransaction];
        return YES;
    }
    else {
        return NO;
    }
}

@end
