//
//  MasterInstance.m
//  StorePOS
//
//  Created by vampirewalk on 2016/1/10.
//  Copyright © 2016年 mocacube. All rights reserved.
//

#import "MasterInstance.h"
#import "PublishService.h"
#import "Constant.h"
#import <PocketSocket/PSWebSocketServer.h>

@interface MasterInstance ()<PublishServiceDelegate, PSWebSocketServerDelegate>
@property (strong, nonatomic) PublishService *publishService;
@property (strong, nonatomic) PSWebSocketServer *server;
@property (strong, nonatomic) NSMutableArray *slaveSockets;
@end

@implementation MasterInstance
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


#pragma mark - PublishServiceDelegate

- (void)serviceDidPublishWithHostname:(NSString *)hosname port:(NSInteger)port
{
    [self startServerWithHostname:hosname port:port];
}

- (void)serviceDidNotPublish
{
    
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

- (void)sendMessage:(NSString *)message
{
    [self broadcastMessage:message exceptSocket:nil];
}

- (void)broadcastMessage:(NSString *) message exceptSocket:(PSWebSocket *) exceptSocket
{
    if (_slaveSockets.count > 0) {
        for (PSWebSocket *socket in _slaveSockets) {
            if (exceptSocket != nil && [socket isEqual:exceptSocket]) {
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
    if (_delegate && [_delegate respondsToSelector:@selector(didReceiveMessage:)]) {
        [_delegate didReceiveMessage:message];
    }
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
