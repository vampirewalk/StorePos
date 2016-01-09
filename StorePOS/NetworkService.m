//
//  NetworkService.m
//  StorePOS
//
//  Created by vampirewalk on 2016/1/9.
//  Copyright © 2016年 mocacube. All rights reserved.
//

#import "NetworkService.h"

static NSString *const POSBonjourServiceType = @"_pos._tcp";

@interface NetworkService ()<NSNetServiceDelegate, NSNetServiceBrowserDelegate>
@property (strong, nonatomic) NSNetService *netService;
@property (strong, nonatomic) NSNetServiceBrowser *serviceBrowser;
@property (strong, nonatomic) NSMutableArray *bonjourServices;
@property (strong, nonatomic) NSNetService *currentService;
@property (copy, nonatomic) NSString *bonjourServiceName;
@end

@implementation NetworkService

- (instancetype)initWithConfiguration:(Configuration) configuration
{
    self = [super init];
    if (self) {
        if (configuration == Master) {
            
        }
        else {
            _bonjourServices = [NSMutableArray array];
            _serviceBrowser = [[NSNetServiceBrowser alloc] init];
            _serviceBrowser.delegate = self;
            [_serviceBrowser searchForServicesOfType:@"_posd._tcp." inDomain:@"local."];
            
        }
        
    }
    return self;
}

- (void)netServiceWillPublish:(NSNetService *)sender
{
    
}

- (void)netServiceDidPublish:(NSNetService *)sender
{
    
}

- (void)netService:(NSNetService *)sender didNotPublish:(NSDictionary *)errorDict
{
    
}

#pragma mark - NSNetServiceBrowserDelegate

- (void)netServiceBrowser:(NSNetServiceBrowser *) netServiceBrowser didFindService:(NSNetService *) service moreComing:(BOOL) moreComing;
{
    const NSStringCompareOptions compareOptions = NSCaseInsensitiveSearch | NSDiacriticInsensitiveSearch;
    if (_bonjourServiceName != nil && [_bonjourServiceName compare:service.name options:compareOptions] != NSOrderedSame) {
        return;
    }
    
    NSLog(@"Found posd bonjour service: %@", service);
    [_bonjourServices addObject:service];
    
    if (!_currentService) {
        [self resolveService:service];
    }
}

- (void)netServiceBrowser:(NSNetServiceBrowser *) netServiceBrowser didRemoveService:(NSNetService *) service moreComing:(BOOL)moreComing;
{
    if ([service isEqual:_currentService]) {
        [_currentService stop];
        _currentService.delegate = nil;
        _currentService = nil;
    }
    
    NSUInteger serviceIndex = [_bonjourServices indexOfObject:service];
    if (NSNotFound != serviceIndex) {
        [_bonjourServices removeObjectAtIndex:serviceIndex];
        NSLog(@"Removed posd bonjour service: %@", service);
        
        // Try next one
        if (!_currentService && _bonjourServices.count){
            NSNetService* nextService = [_bonjourServices objectAtIndex:(serviceIndex % _bonjourServices.count)];
            [self resolveService:nextService];
        }
    }
}

#pragma mark - Private

- (void)resolveService:(NSNetService*)service;
{
    NSLog(@"Resolving %@", service);
    _currentService = service;
    _currentService.delegate = self;
    [_currentService resolveWithTimeout:10.f];
}

#pragma mark - NSNetServiceDelegate

- (void)netService:(NSNetService *)service didNotResolve:(NSDictionary *)errorDict;
{
    NSAssert([service isEqual:_currentService], @"Did not resolve incorrect service!");
    _currentService.delegate = nil;
    _currentService = nil;
    
    // Try next one, we may retry the same one if there's only 1 service in _bonjourServices
    NSUInteger serviceIndex = [_bonjourServices indexOfObject:service];
    if (NSNotFound != serviceIndex) {
        if (_bonjourServices.count){
            NSNetService* nextService = [_bonjourServices objectAtIndex:((serviceIndex + 1) % _bonjourServices.count)];
            [self resolveService:nextService];
        }
    }
}


- (void)netServiceDidResolveAddress:(NSNetService *)service;
{
    NSAssert([service isEqual:_currentService], @"Resolved incorrect service!");
    
    [self connectToURL:[NSURL URLWithString:[NSString stringWithFormat:@"ws://%@:%ld/device", [service hostName], (long)[service port]]]];
}

#pragma mark - Connect / Disconnect

- (void)startService
{
    if (_netService) {
        [_netService stop];
        _netService = nil;
    }
    _netService = [[NSNetService alloc] initWithDomain:@"local." type:POSBonjourServiceType name:@"POSMaster"];
    if(_netService)
    {
        [_netService setDelegate:self];
        [_netService publish];
    }
    else
    {
        NSLog(@"An error occurred initializing the NSNetService object.");
    }
}

- (void)autoConnectToBonjourServiceNamed:(NSString*)serviceName;
{
    if (_serviceBrowser) {
        return;
    }
    
    _bonjourServiceName = serviceName;
    _bonjourServices = [NSMutableArray array];
    _serviceBrowser = [[NSNetServiceBrowser alloc] init];
    [_serviceBrowser setDelegate:self];
    
    if (_bonjourServiceName) {
        NSLog(@"Waiting for posd bonjour service '%@'...", _bonjourServiceName);
    } else {
        NSLog(@"Waiting for posd bonjour service...");
    }
    [_serviceBrowser searchForServicesOfType:POSBonjourServiceType inDomain:@"local."];
}

- (void)connectToURL:(NSURL *)url;
{
    NSLog(@"Connecting to %@", url);
    
}

- (void)disconnect;
{
    [_serviceBrowser stop];
    _serviceBrowser.delegate = nil;
    _serviceBrowser = nil;
    _bonjourServiceName = nil;
    _bonjourServices = nil;
    [_currentService stop];
    _currentService.delegate = nil;
    _currentService = nil;
    
//    [_socket close];
//    _socket.delegate = nil;
//    _socket = nil;
}

@end
