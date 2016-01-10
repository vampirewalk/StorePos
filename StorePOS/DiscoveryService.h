//
//  DiscoveryService.h
//  StorePOS
//
//  Created by vampirewalk on 2016/1/10.
//  Copyright © 2016年 mocacube. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol DiscoveryServiceDelegate <NSObject>
- (void)didConnectToMasterWithHostname:(NSString *) hostName port:(NSInteger) port;
- (void)didDisconnectFromMasterWithHostname:(NSString *) hostName port:(NSInteger) port;
@end

@interface DiscoveryService : NSObject
@property (assign, nonatomic) id<DiscoveryServiceDelegate> delegate;
- (void)autoConnectToBonjourServiceNamed:(NSString*)serviceName;
- (void)disconnect;;
@end
