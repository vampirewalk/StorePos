//
//  EditOrderViewController.h
//  StorePOS
//
//  Created by vampirewalk on 2016/1/10.
//  Copyright © 2016年 mocacube. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Order;

@interface EditOrderViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *customerName;
@property (weak, nonatomic) IBOutlet UITextField *shippingMethod;
@property (weak, nonatomic) IBOutlet UITextField *tableName;
@property (weak, nonatomic) IBOutlet UITextField *tableSize;
@property (strong, nonatomic) Order *order;
@end
