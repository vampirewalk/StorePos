//
//  NetworkService.h
//  StorePOS
//
//  Created by vampirewalk on 2016/1/9.
//  Copyright © 2016年 mocacube. All rights reserved.
//

#import <Foundation/Foundation.h>

@class DiscoveryService, PublishService;

@interface NetworkService : NSObject
- (instancetype)initWithDiscoveryService:(DiscoveryService *) discoveryService;
- (instancetype)initWithPublishService:(PublishService *) publishService;
@end
