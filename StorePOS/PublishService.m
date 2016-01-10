//
//  PublishService.m
//  StorePOS
//
//  Created by vampirewalk on 2016/1/10.
//  Copyright © 2016年 mocacube. All rights reserved.
//

#import "PublishService.h"
#import "Constant.h"

@interface PublishService ()<NSNetServiceDelegate>
@property (strong, nonatomic) NSNetService *netService;
@end

@implementation PublishService

- (void)startWithName:(NSString *) serviceName
{
    if (_netService) {
        [_netService stop];
        _netService = nil;
    }
    _netService = [[NSNetService alloc] initWithDomain:@"local." type:POSBonjourServiceType name:serviceName port:80];
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

- (void)stop
{
    if (_netService) {
        [_netService stop];
    }
}

#pragma mark - NSNetServiceDelegate

- (void)netServiceWillPublish:(NSNetService *)sender
{
    
}

- (void)netServiceDidPublish:(NSNetService *)sender
{
    if (_delegate && [_delegate respondsToSelector:@selector(serviceDidPublish)]) {
        [_delegate serviceDidPublish];
    }
}

- (void)netService:(NSNetService *)sender didNotPublish:(NSDictionary *)errorDict
{
    if (_delegate && [_delegate respondsToSelector:@selector(serviceDidNotPublish)]) {
        [_delegate serviceDidNotPublish];
    }
}


@end
