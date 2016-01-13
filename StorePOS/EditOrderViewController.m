//
//  EditOrderViewController.m
//  StorePOS
//
//  Created by vampirewalk on 2016/1/10.
//  Copyright © 2016年 mocacube. All rights reserved.
//

#import "EditOrderViewController.h"
#import <PureLayout/PureLayout.h>
#import "AppDelegate.h"
#import "OrderTextField.h"
#import <ChameleonFramework/Chameleon.h>

@interface EditOrderViewController ()
@property (strong, nonatomic) OrderService *service;
@end

@implementation EditOrderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor flatPurpleColor];
    
    [self setupTextFields];
    
    AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
    self.service = appDelegate.orderService;
    
    self.navigationItem.title = @"Add Order";
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self fillValue];
    if (_order != nil) {
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(updateOrder)];
    }
    else {
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(addOrder)];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setupTextFields
{
    _customerName.translatesAutoresizingMaskIntoConstraints = NO;
    _customerName.placeholder = @"customName";
    _customerName.text = @"Kevin";
    [_customerName becomeFirstResponder];
    
    _shippingMethod.translatesAutoresizingMaskIntoConstraints = NO;
    _shippingMethod.placeholder = @"shippingMethod";
    _shippingMethod.text = @"DHL";
    
    _tableName.translatesAutoresizingMaskIntoConstraints = NO;
    _tableName.placeholder = @"tableName";
    _tableName.text = @"";
    
    _tableSize.translatesAutoresizingMaskIntoConstraints = NO;
    _tableSize.placeholder = @"tableSize";
    _tableSize.text = @"-1";
    
    [self.view addSubview:_customerName];
    [self.view addSubview:_shippingMethod];
    [self.view addSubview:_tableName];
    [self.view addSubview:_tableSize];
    
    [@[_customerName, _shippingMethod, _tableName, _tableSize] autoDistributeViewsAlongAxis:ALAxisVertical alignedTo:ALAttributeLeft withFixedSize:88 insetSpacing:YES];
    [_customerName autoPinEdgeToSuperviewMargin:ALEdgeLeft];
    [_customerName autoPinEdgeToSuperviewMargin:ALEdgeRight];
    
    [_shippingMethod autoPinEdgeToSuperviewMargin:ALEdgeLeft];
    [_shippingMethod autoPinEdgeToSuperviewMargin:ALEdgeRight];
    
    [_tableName autoPinEdgeToSuperviewMargin:ALEdgeLeft];
    [_tableName autoPinEdgeToSuperviewMargin:ALEdgeRight];
    
    [_tableSize autoPinEdgeToSuperviewMargin:ALEdgeLeft];
    [_tableSize autoPinEdgeToSuperviewMargin:ALEdgeRight];
}

- (void)fillValue
{
    if (_order != nil) {
        _customerName.text = _order.customerName;
        _shippingMethod.text = _order.shippingMethod;
        _tableName.text = _order.tableName;
        _tableSize.text = [@(_order.tableSize) stringValue];
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)addOrder
{
    Order *newOrder = [[Order alloc] initWithUUID:[NSUUID UUID].UUIDString customerName:_customerName.text shippingMethod:_shippingMethod.text tableName:_tableName.text tableSize:[_tableSize.text integerValue] created:[NSDate date]];
    [_service addOrder:newOrder byReceivingMessage:NO];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)updateOrder
{
    _order.customerName = _customerName.text;
    _order.shippingMethod = _shippingMethod.text;
    _order.tableName = _tableName.text;
    _order.tableSize = [_tableSize.text integerValue];
    [_service updateOrderByUUID:_order.uuid withNewOrder:_order byReceivingMessage:NO];
    [self.navigationController popViewControllerAnimated:YES];
}

@end
