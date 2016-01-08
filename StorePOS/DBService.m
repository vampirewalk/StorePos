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

- (void)addOrder:(Order *) order
{
    NSAssert(order != nil, @"order can't be nil");
    OrderStore *store = [[OrderStore alloc] initWithOrder:order];
    
    RLMRealm *realm = [self realm];
    [realm beginWriteTransaction];
    [OrderStore createInRealm:realm withValue:store];
    [realm commitWriteTransaction];
}

- (Order *)queryOrderByUUID:(NSString *) uuid
{
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"uuid = %@", uuid];
    RLMResults *results = [OrderStore objectsInRealm:[self realm] withPredicate:pred];
    OrderStore *store = results.firstObject;
    return store.order;
}

@end
