//
//  NetworkService.m
//  StorePOS
//
//  Created by vampirewalk on 2016/1/9.
//  Copyright © 2016年 mocacube. All rights reserved.
//

#import "NetworkService.h"
#import "DiscoveryService.h"
#import "PublishService.h"
#import "Constant.h"

@interface NetworkService ()<DiscoveryServiceDelegate, PublishServiceDelegate>
@property (strong, nonatomic) DiscoveryService *discoveryService;
@property (strong, nonatomic) PublishService *publishService;
@end

@implementation NetworkService

- (instancetype)initWithDiscoveryService:(DiscoveryService *) discoveryService
{
    self = [super init];
    if (self) {
        _discoveryService = discoveryService;
        _discoveryService.delegate = self;
        [_discoveryService autoConnectToBonjourServiceNamed:POSServiceName];
    }
    return self;
}

- (instancetype)initWithPublishService:(PublishService *) publishService
{
    self = [super init];
    if (self) {
        _publishService = publishService;
        _publishService.delegate = self;
        [_publishService startWithName:POSServiceName];
    }
    return self;
}

#pragma mark - DiscoveryServiceDelegate

- (void)didConnectToMasterWithHostname:(NSString *)hostName port:(NSInteger)port
{
    NSURL *URL = [NSURL URLWithString:[NSString stringWithFormat:@"ws://%@:%ld/device", hostName, (long) port]];
}

- (void)didDisconnectFromMasterWithHostname:(NSString *)hostName port:(NSInteger)port
{
    
}

#pragma mark - PublishServiceDelegate

- (void)serviceDidPublish
{
    
}

- (void)serviceDidNotPublish
{
    
}

- (void)connectToURL:(NSURL *)url;
{
    NSLog(@"Connecting to %@", url);
    
}

@end
