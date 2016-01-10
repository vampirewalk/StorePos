//
//  OrderListTableViewControllerCell.m
//  StorePOS
//
//  Created by vampirewalk on 2016/1/10.
//  Copyright © 2016年 mocacube. All rights reserved.
//

#import "OrderListTableViewControllerCell.h"
#import <PureLayout/PureLayout.h>

@interface OrderListTableViewControllerCell ()

@end

@implementation OrderListTableViewControllerCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)layoutSubviews
{
    self.customerName = [UILabel newAutoLayoutView];
    self.shippingMethod = [UILabel newAutoLayoutView];
    self.tableName = [UILabel newAutoLayoutView];
    self.tableSize = [UILabel newAutoLayoutView];
    
    [self.contentView addSubview:_customerName];
    [self.contentView addSubview:_shippingMethod];
    [self.contentView addSubview:_tableName];
    [self.contentView addSubview:_tableSize];
    
    [@[_customerName, _shippingMethod, _tableName, _tableSize] autoDistributeViewsAlongAxis:ALAxisVertical alignedTo:ALAttributeLeft withFixedSize:60 insetSpacing:YES];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
