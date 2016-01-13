//
//  OrderListTableViewControllerCell.h
//  StorePOS
//
//  Created by vampirewalk on 2016/1/10.
//  Copyright © 2016年 mocacube. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OrderListTableViewCell : UITableViewCell
@property (strong, nonatomic) UILabel *customerName;
@property (strong, nonatomic) UILabel *shippingMethod;
@property (strong, nonatomic) UILabel *tableName;
@property (strong, nonatomic) UILabel *tableSize;
@end
