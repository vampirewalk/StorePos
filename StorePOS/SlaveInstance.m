//
//  SlaveInstance.m
//  StorePOS
//
//  Created by vampirewalk on 2016/1/10.
//  Copyright © 2016年 mocacube. All rights reserved.
//

#import "SlaveInstance.h"
#import "DiscoveryService.h"
#import "Constant.h"
#import <PocketSocket/PSWebSocket.h>

@interface SlaveInstance ()<DiscoveryServiceDelegate, PSWebSocketDelegate>
@property (strong, nonatomic) DiscoveryService *discoveryService;
@property (strong, nonatomic) PSWebSocket *socket;

@end

@implementation SlaveInstance

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


#pragma mark - DiscoveryServiceDelegate

- (void)didConnectToMasterWithHostname:(NSString *)hostName port:(NSInteger)port
{
    NSURL *URL = [NSURL URLWithString:[NSString stringWithFormat:@"ws://%@:%ld/device", hostName, (long) port]];
    [self connectToServerWithURL:URL];
}

- (void)didDisconnectFromMasterWithHostname:(NSString *)hostName port:(NSInteger)port
{
    
}

#pragma mark - Slave

- (void)connectToServerWithURL:(NSURL *) url
{
    NSLog(@"Connecting to %@", url);
    // create the socket and assign delegate
    self.socket = [PSWebSocket clientSocketWithRequest:[NSURLRequest requestWithURL:url]];
    self.socket.delegate = self;
    
    // open socket
    [self.socket open];
}

- (void)disconnectFromServer
{
    [self.socket close];
}

- (void)sendMessage:(NSString *) message
{
    [_socket send:message];
}

#pragma mark PSWebSocketDelegate

- (void)webSocketDidOpen:(PSWebSocket *)webSocket {
    NSLog(@"The websocket handshake completed and is now open!");
}
- (void)webSocket:(PSWebSocket *)webSocket didReceiveMessage:(id)message {
    NSLog(@"The websocket received a message: %@", message);
    if (_delegate && [_delegate respondsToSelector:@selector(didReceiveMessage:)]) {
        [_delegate didReceiveMessage:message];
    }
}
- (void)webSocket:(PSWebSocket *)webSocket didFailWithError:(NSError *)error {
    NSLog(@"The websocket handshake/connection failed with an error: %@", error);
}
- (void)webSocket:(PSWebSocket *)webSocket didCloseWithCode:(NSInteger)code reason:(NSString *)reason wasClean:(BOOL)wasClean {
    NSLog(@"The websocket closed with code: %@, reason: %@, wasClean: %@", @(code), reason, (wasClean) ? @"YES" : @"NO");
}

@end
