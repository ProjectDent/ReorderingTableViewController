//
//  ViewController.m
//  Reordering
//
//  Created by Andrew Hart on 20/01/2015.
//  Copyright (c) 2015 Andrew Hart. All rights reserved.
//

#import "ViewController.h"
#import "ATSDragToReorderTableView.h"

@interface ViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) NSMutableArray *items;
@property (nonatomic, strong) ATSDragToReorderTableView *tableView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.items = [NSMutableArray new];
    NSUInteger numberOfItems = 20;
        
    self.items = [[NSMutableArray alloc] initWithCapacity:numberOfItems];
        
    for (NSUInteger i = 0; i < numberOfItems; ++i) {
        [self.items addObject:[NSString stringWithFormat:@"Item #%lu", i]];
    }
    
    self.tableView = [ATSDragToReorderTableView new];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.frame = self.view.bounds;
    self.tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self.view addSubview:self.tableView];
}

#pragma mark - UITableViewDataSource methods

// Customize the number of sections in the table view.
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return ceil(self.items.count / 5);
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return @"New section";
}

// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    /*
     Disable reordering if there's one or zero items.
     For this example, of course, this will always be YES.
     */
    [self.tableView setReorderingEnabled:self.items.count > 1];
    
    int startPoint = (int)section * 5;
    int remainder = MIN((int)self.items.count - startPoint, 5);
    
    return remainder;
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    cell.textLabel.text = [self.items objectAtIndex:(indexPath.section * 5) + indexPath.row];
    
    return cell;
}

// should be identical to cell returned in -tableView:cellForRowAtIndexPath:
- (UITableViewCell *)cellIdenticalToCellAtIndexPath:(NSIndexPath *)indexPath forDragTableView:(ATSDragToReorderTableView *)dragTableView {
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    cell.textLabel.text = [self.items objectAtIndex:(indexPath.section * 5) + indexPath.row];
    
    return cell;
}

/*
	Required for drag tableview
 */
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
    
    NSString *itemToMove = [self.items objectAtIndex:(fromIndexPath.section * 5) + fromIndexPath.row];
    [self.items removeObjectAtIndex:(fromIndexPath.section * 5) + fromIndexPath.row];
    [self.items insertObject:itemToMove atIndex:(toIndexPath.section * 5) + toIndexPath.row];
}

#pragma mark - UITableViewDelegate methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
