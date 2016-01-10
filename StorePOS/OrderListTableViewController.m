//
//  OrderListTableViewController.m
//  StorePOS
//
//  Created by vampirewalk on 2016/1/10.
//  Copyright © 2016年 mocacube. All rights reserved.
//

#import "OrderListTableViewController.h"
#import <KVOController/FBKVOController.h>
#import "AppDelegate.h"
#import <libextobjc/EXTKeyPathCoding.h>
#import "EditOrderViewController.h"
#import "OrderListTableViewControllerCell.h"

static NSString *const OrderListTableViewControllerCellIdentifier = @"OrderListTableViewControllerCellIdentifier";

@interface OrderListTableViewController ()
@property (strong, nonatomic) OrderService *service;
@end

@implementation OrderListTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.estimatedRowHeight = 120;
    self.tableView.rowHeight = UITableViewAutomaticDimension;

    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addOrder)];
    
    FBKVOController *KVOController = [[FBKVOController alloc] initWithObserver:self retainObserved:NO];
    self.KVOController = KVOController;
    
    AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
    self.service = appDelegate.orderService;
}

- (void)viewWillAppear:(BOOL)animated
{
    [self observeServer];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [self unobserveServer];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)addOrder
{
    EditOrderViewController *editOrderViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"EditOrderViewController"];
    [self.navigationController pushViewController:editOrderViewController animated:YES];
}

#pragma mark - KVO

- (void)observeServer
{
    [self.KVOController observe:_service keyPath:@keypath(_service, orders) options:NSKeyValueObservingOptionInitial | NSKeyValueObservingOptionNew block:^(OrderListTableViewController *observer, OrderService *service, NSDictionary *change) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [observer.tableView reloadData];
        });
    }];
}

- (void)unobserveServer
{
    [self.KVOController unobserve:_service keyPath:@keypath(_service, orders)];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _service.orders.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    OrderListTableViewControllerCell *cell = [tableView dequeueReusableCellWithIdentifier:OrderListTableViewControllerCellIdentifier forIndexPath:indexPath];
    Order *order = [_service objectInOrdersAtIndex:indexPath.row];
    cell.customerName.text = order.customerName;
    cell.shippingMethod.text = order.shippingMethod;
    cell.tableName.text = order.tableName;
    cell.tableSize.text = [@(order.tableSize) stringValue];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 120.0f;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
