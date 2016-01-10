//
//  SlaveInstance.h
//  StorePOS
//
//  Created by vampirewalk on 2016/1/10.
//  Copyright © 2016年 mocacube. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Instancing.h"

@class DiscoveryService;

@interface SlaveInstance : NSObject<Instancing>
@property (assign, nonatomic) id<InstanceDelegate> delegate;
- (instancetype)initWithDiscoveryService:(DiscoveryService *) discoveryService;
-(void)sendMessage:(NSString *) message;
@end
