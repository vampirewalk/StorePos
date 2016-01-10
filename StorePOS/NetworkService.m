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
#import <PocketSocket/PSWebSocket.h>
#import <PocketSocket/PSWebSocketServer.h>

@interface NetworkService ()<DiscoveryServiceDelegate, PublishServiceDelegate, PSWebSocketDelegate, PSWebSocketServerDelegate>
@property (strong, nonatomic) DiscoveryService *discoveryService;
@property (strong, nonatomic) PublishService *publishService;
@property (strong, nonatomic) PSWebSocket *socket;
@property (strong, nonatomic) PSWebSocketServer *server;
@property (strong, nonatomic) NSMutableArray *slaveSockets;
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
        _slaveSockets = [NSMutableArray array];
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
    [self connectToServerWithURL:URL];
}

- (void)didDisconnectFromMasterWithHostname:(NSString *)hostName port:(NSInteger)port
{
    
}

#pragma mark - PublishServiceDelegate

- (void)serviceDidPublishWithHostname:(NSString *)hosname port:(NSInteger)port
{
    [self startServerWithHostname:hosname port:port];
}

- (void)serviceDidNotPublish
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
//    [webSocket send:@"Hello world!"];
}
- (void)webSocket:(PSWebSocket *)webSocket didReceiveMessage:(id)message {
    NSLog(@"The websocket received a message: %@", message);
}
- (void)webSocket:(PSWebSocket *)webSocket didFailWithError:(NSError *)error {
    NSLog(@"The websocket handshake/connection failed with an error: %@", error);
}
- (void)webSocket:(PSWebSocket *)webSocket didCloseWithCode:(NSInteger)code reason:(NSString *)reason wasClean:(BOOL)wasClean {
    NSLog(@"The websocket closed with code: %@, reason: %@, wasClean: %@", @(code), reason, (wasClean) ? @"YES" : @"NO");
}

#pragma mark - Master

- (void)startServerWithHostname:(NSString *)hosname port:(NSInteger)port
{
    _server = [PSWebSocketServer serverWithHost:hosname port:port];
    _server.delegate = self;
    [_server start];
}

- (void)stopServer
{
    [_server stop];
}

- (void)broadcastMessage:(NSString *) message exceptSocket:(PSWebSocket *) exceptSocket
{
    if (_slaveSockets.count > 0) {
        for (PSWebSocket *socket in _slaveSockets) {
            if ([socket isEqual:exceptSocket]) {
                continue;
            }
            [socket send:message];
        }
    }
}

#pragma mark PSWebSocketServerDelegate

- (void)serverDidStart:(PSWebSocketServer *)server {
    NSLog(@"Server did start…");
}
- (void)serverDidStop:(PSWebSocketServer *)server {
    NSLog(@"Server did stop…");
}
- (BOOL)server:(PSWebSocketServer *)server acceptWebSocketWithRequest:(NSURLRequest *)request {
    NSLog(@"Server should accept request: %@", request);
    return YES;
}

- (void)server:(PSWebSocketServer *)server webSocketDidOpen:(PSWebSocket *)webSocket {
    NSLog(@"Server websocket did open");
    [_slaveSockets addObject:webSocket];
}

- (void)server:(PSWebSocketServer *)server webSocket:(PSWebSocket *)webSocket didReceiveMessage:(id)message {
    NSLog(@"Server websocket did receive message: %@", message);
    [self broadcastMessage:message exceptSocket:webSocket];
}

- (void)server:(PSWebSocketServer *)server webSocket:(PSWebSocket *)webSocket didCloseWithCode:(NSInteger)code reason:(NSString *)reason wasClean:(BOOL)wasClean {
    NSLog(@"Server websocket did close with code: %@, reason: %@, wasClean: %@", @(code), reason, @(wasClean));
    [_slaveSockets removeObject:webSocket];
}
- (void)server:(PSWebSocketServer *)server webSocket:(PSWebSocket *)webSocket didFailWithError:(NSError *)error {
    NSLog(@"Server websocket did fail with error: %@", error);
    [_slaveSockets removeObject:webSocket];
}

@end
