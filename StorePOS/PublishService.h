//
//  PublishService.h
//  StorePOS
//
//  Created by vampirewalk on 2016/1/10.
//  Copyright © 2016年 mocacube. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol PublishServiceDelegate <NSObject>

- (void)serviceDidPublish;
- (void)serviceDidNotPublish;

@end

@interface PublishService : NSObject
@property (assign, nonatomic) id<PublishServiceDelegate> delegate;
- (void)startWithName:(NSString *) serviceName;
- (void)stop;
@end
