//
//  NetworkService.h
//  StorePOS
//
//  Created by vampirewalk on 2016/1/9.
//  Copyright © 2016年 mocacube. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum : NSUInteger {
    Master,
    Slave,
} Configuration;

@interface NetworkService : NSObject

@end
