//
//  Instancing.h
//  StorePOS
//
//  Created by vampirewalk on 2016/1/10.
//  Copyright © 2016年 mocacube. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol InstanceDelegate <NSObject>

- (void)didReceiveMessage:(NSString *) message;

@end

@protocol Instancing <NSObject>
@property (assign, nonatomic) id<InstanceDelegate> delegate;
- (void)sendMessage:(NSString *) meessage;
@end
