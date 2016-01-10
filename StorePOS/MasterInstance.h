//
//  MasterInstance.h
//  StorePOS
//
//  Created by vampirewalk on 2016/1/10.
//  Copyright © 2016年 mocacube. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Instancing.h"

@class PublishService;

@interface MasterInstance : NSObject<Instancing>
@property (assign, nonatomic) id<InstanceDelegate> delegate;

- (instancetype)initWithPublishService:(PublishService *) publishService;
-(void)sendMessage:(NSString *) message;

@end
