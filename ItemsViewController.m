//
//  ItemsViewController.m
//  Homepwner
//
//  Created by Fernando Castor on 27/01/15.
//  Copyright (c) 2015 UFPE. All rights reserved.
//

#import "ItemsViewController.h"
#import "ItemStore.h"
#import "BNRItem.h"
#import "DetailViewController.h"

@interface ItemsViewController()

@property (nonatomic, strong) IBOutlet UIView *headerView;

@end

// Don't forget that, even though ItemStore keeps the items,
// ItemsViewController is the actual data source of the
// UITableView.
@implementation ItemsViewController

- (instancetype)init {
    self = [super initWithStyle:UITableViewStylePlain];
     /*    if (self) {
        for (int i = 0; i < 5; i++) {
            [[ItemStore sharedStore] createItem];
        }
    }
    */
    if (self) {
        self.navigationItem.title = @"Homepwner";
    }
    
    UIBarButtonItem *bbi = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addNewItem:)];
    self.navigationItem.rightBarButtonItem = bbi;
    
 //   UIBarButtonItem *bbiEdit = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(toggleEditingMode:)];
    self.navigationItem.leftBarButtonItem = self.editButtonItem;
    
    return self;
}

- (instancetype)initWithStyle:(UITableViewStyle)style {
    return [self init];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.tableView reloadData];
}

- (IBAction)addNewItem:(id)sender {
    BNRItem *newItem = [[ItemStore sharedStore] createItem];
    NSInteger lastRow = [[[ItemStore sharedStore] allItems] indexOfObject:newItem];
    
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:lastRow inSection:0];
    
    [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationTop];
}
//
//- (IBAction)toggleEditingMode:(id)sender {
//    if (self.isEditing) {
//        [sender setTitle:@"Edit" forState:UIControlStateNormal];
//        [self setEditing:NO animated:YES];
//    }
//    else {
//        [sender setTitle:@"Done" forState:UIControlStateNormal];
//        [self setEditing:YES animated:YES];
//    }
//    
//}
//
//- (UIView *)headerView {
//    if (!_headerView) {
//        [[NSBundle mainBundle] loadNibNamed:@"HeaderView" owner:self options:nil];
//    }
//    return _headerView;
//}
//

// Since we only have one section, the number of rows in this section is the overall
// number of items in the table.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[[ItemStore sharedStore] allItems] count] + 1; // One more to account for the @"No more items!" line.
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
   
 //The following line will create a new cell with reuse identifier @"UITableViewCell"
 //   UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"UITableViewCell"];
    
    // The following line, differently from the previous one, will first attempt to reuse a preexisting cell. If no
    // such cell exists, it creates a new one.
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell" forIndexPath:indexPath];
    if (indexPath.row == [self tableView:tableView numberOfRowsInSection:indexPath.section] - 1) {
        cell.textLabel.text = @"No more items!";
    } else {
        NSArray *items = [[ItemStore sharedStore] allItems];
        BNRItem *item = items[indexPath.row];
        cell.textLabel.text = [item description];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row < [self tableView:tableView numberOfRowsInSection:indexPath.section] - 1) {
        DetailViewController *detailControl = [[DetailViewController alloc] init];
        NSArray *theItems = [[ItemStore sharedStore] allItems];
        BNRItem *selectedItem = theItems[indexPath.row];
        detailControl.item = selectedItem;
        [self.navigationController pushViewController:detailControl animated:YES];
    }
}

// This method is the one that should be overridden in order to remove items from the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        ItemStore *items = [ItemStore sharedStore];
        BNRItem *item = items.allItems[indexPath.row];
        
        // First remove the item from the store and then...
        [items removeItem:item];
        
        // remove it from the table view as well.
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    BOOL result = YES;
    if (indexPath.row == [self tableView:tableView numberOfRowsInSection:indexPath.row] - 1) {
        result = NO;
    }
    return result;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    BOOL result = YES;
    if (indexPath.row == [self tableView:tableView numberOfRowsInSection:indexPath.row] - 1) {
        result = NO;
    }
    return result;
}

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath {
    if (destinationIndexPath.row < [self tableView:tableView numberOfRowsInSection:sourceIndexPath.section] - 1) {
        [[ItemStore sharedStore] moveItemAtIndex:sourceIndexPath.row ToIndex:destinationIndexPath.row];
    }
    else if (destinationIndexPath.row == [self tableView:tableView numberOfRowsInSection:sourceIndexPath.section] - 1){
        // Reload the data so as to ignore any modifications.
        [self.tableView reloadData];
    }
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIView *header = self.headerView;
    [self.tableView setTableHeaderView:header];
    
    // The following line is necessary for reuse identifier @"UITableViewCell" to be used.
    // In case it is ommitted, we will get an NSInternalConsistencyException at runtime
    // because no class will be associated wit the reuse identifier. For this example, class
    // UITableViewCell is associated with identifier @"UITableViewCell".
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"UITableViewCell"];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

@end
