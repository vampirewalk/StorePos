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
#import "OrderListTableViewCell.h"
#import <ChameleonFramework/Chameleon.h>

static NSString *const OrderListTableViewControllerCellIdentifier = @"OrderListTableViewControllerCellIdentifier";

@interface OrderListTableViewController ()
@property (strong, nonatomic) OrderService *service;
@property (copy, nonatomic) NSArray *cacheOrders;
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
    
    self.view.backgroundColor = [UIColor flatPurpleColor];
    
    self.navigationItem.leftBarButtonItem = self.editButtonItem;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addOrder)];
    
    FBKVOController *KVOController = [[FBKVOController alloc] initWithObserver:self retainObserved:NO];
    self.KVOController = KVOController;
    
    AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
    self.service = appDelegate.orderService;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self observeOrder];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [self unobserveOrder];
    [super viewWillDisappear:animated];
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

- (void)updateOrderWithIndexPath:(NSIndexPath *) indexPath
{
    EditOrderViewController *editOrderViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"EditOrderViewController"];
    Order *order = self.cacheOrders[indexPath.row];
    editOrderViewController.order = order;
    [self.navigationController pushViewController:editOrderViewController animated:YES];
}

#pragma mark - KVO

- (void)observeOrder
{
    [self.KVOController observe:_service keyPath:@keypath(_service, orders) options:NSKeyValueObservingOptionInitial | NSKeyValueObservingOptionNew block:^(OrderListTableViewController *observer, OrderService *service, NSDictionary *change) {
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            self.cacheOrders = _service.orders;
            [observer.tableView reloadData];
        }];
    }];
}

- (void)unobserveOrder
{
    [self.KVOController unobserve:_service keyPath:@keypath(_service, orders)];
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (!self.editing) {
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        [self updateOrderWithIndexPath:indexPath];
    }
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _service.orders.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    OrderListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:OrderListTableViewControllerCellIdentifier forIndexPath:indexPath];
    Order *order = self.cacheOrders[indexPath.row];
    cell.customerName.text = [NSString stringWithFormat:@"Customer name:    %@", order.customerName];
    cell.shippingMethod.text = [NSString stringWithFormat:@"Shipping method:    %@", order.shippingMethod];
    cell.tableName.text = [NSString stringWithFormat:@"Table name:  %@", order.tableName];
    cell.tableSize.text = [NSString stringWithFormat:@"Table size:  %@", [@(order.tableSize) stringValue]];
    
    UIView *bgColorView = [[UIView alloc] init];
    bgColorView.backgroundColor = [UIColor flatPinkColor];
    [cell setSelectedBackgroundView:bgColorView];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 160.0f;
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

#pragma mark - Edit

- (void)setEditing:(BOOL)editing animated:(BOOL)animated
{
    [super setEditing:editing animated:animated];
    self.tableView.allowsMultipleSelectionDuringEditing = editing;
    if (editing) {
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Delete" style:UIBarButtonItemStylePlain target:self action:@selector(removeSelectedOrder)];
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(finishEditing)];
    }
    else {
        self.navigationItem.leftBarButtonItem = self.editButtonItem;
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addOrder)];
    }
    
    [self.tableView reloadRowsAtIndexPaths:[self.tableView indexPathsForVisibleRows] withRowAnimation:UITableViewRowAnimationAutomatic];
}

- (void)finishEditing
{
    [self setEditing:NO animated:YES];
}

- (void)removeSelectedOrder
{
    NSMutableArray *uuids = [NSMutableArray array];
    NSArray *selectedCells = [self.tableView indexPathsForSelectedRows];
    for (NSInteger index=0; index < selectedCells.count; index++) {
        NSIndexPath *indexPath = selectedCells[index];
        Order *order = self.cacheOrders[indexPath.row];
        [uuids addObject:order.uuid];
    }
    
    for (NSString *uuid in uuids) {
        [_service removeOrderByUUID:uuid byReceivingMessage:NO];
    }
}

@end
