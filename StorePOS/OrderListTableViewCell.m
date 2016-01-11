//
//  OrderListTableViewControllerCell.m
//  StorePOS
//
//  Created by vampirewalk on 2016/1/10.
//  Copyright © 2016年 mocacube. All rights reserved.
//

#import "OrderListTableViewCell.h"
#import <PureLayout/PureLayout.h>

@interface OrderListTableViewCell ()

@end

@implementation OrderListTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.customerName = [UILabel newAutoLayoutView];
        _customerName.textColor = [UIColor whiteColor];
        self.shippingMethod = [UILabel newAutoLayoutView];
        _shippingMethod.textColor = [UIColor whiteColor];
        self.tableName = [UILabel newAutoLayoutView];
        _tableName.textColor = [UIColor whiteColor];
        self.tableSize = [UILabel newAutoLayoutView];
        _tableSize.textColor = [UIColor whiteColor];
        
        [self.contentView addSubview:_customerName];
        [self.contentView addSubview:_shippingMethod];
        [self.contentView addSubview:_tableName];
        [self.contentView addSubview:_tableSize];
        
        [@[_customerName, _shippingMethod, _tableName, _tableSize] autoDistributeViewsAlongAxis:ALAxisVertical alignedTo:ALAttributeLeft withFixedSpacing:15.0f insetSpacing:YES];
        [_customerName autoPinEdgeToSuperviewMargin:ALEdgeLeft];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    // Make sure the contentView does a layout pass here so that its subviews have their frames set, which we
    // need to use to set the preferredMaxLayoutWidth below.
    [self.contentView setNeedsLayout];
    [self.contentView layoutIfNeeded];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
