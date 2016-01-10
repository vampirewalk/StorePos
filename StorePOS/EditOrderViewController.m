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

@interface EditOrderViewController ()
@property (strong, nonatomic) OrderService *service;
@end

@implementation EditOrderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.customerName = [UITextField newAutoLayoutView];
    _customerName.placeholder = @"customName";
    _customerName.text = @"customName";
    
    self.shippingMethod = [UITextField newAutoLayoutView];
    _shippingMethod.placeholder = @"shippingMethod";
    _shippingMethod.text = @"shippingMethod";
    
    self.tableName = [UITextField newAutoLayoutView];
    _tableName.placeholder = @"tableName";
    _tableName.text = @"tableName";
    
    self.tableSize = [UITextField newAutoLayoutView];
    _tableSize.placeholder = @"tableSize";
    _tableSize.text = @"tableSize";
    
    [self.view addSubview:_customerName];
    [self.view addSubview:_shippingMethod];
    [self.view addSubview:_tableName];
    [self.view addSubview:_tableSize];
    
    [@[_customerName, _shippingMethod, _tableName, _tableSize] autoDistributeViewsAlongAxis:ALAxisVertical alignedTo:ALAttributeLeft withFixedSize:40 insetSpacing:YES];
    
    AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
    self.service = appDelegate.orderService;
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(addOrder)];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    [_service addOrder:newOrder];
    [self.navigationController popViewControllerAnimated:YES];
}

@end
