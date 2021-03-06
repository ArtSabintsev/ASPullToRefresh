//
//  NumberTableViewManager.m
//  ExampleRefresh
//
//  Created by Arthur Ariel Sabintsev on 9/5/12.
//
//

#import "NumberTableViewManager.h"

@interface NumberTableViewManager ()

@property (strong, nonatomic) ASPullToRefreshTableViewController *refreshController;
@property (strong, nonatomic) NSMutableArray *arrayOfDataToRefresh;
@property (assign, nonatomic) NSUInteger currentNumber;

@end

@implementation NumberTableViewManager
@synthesize refreshController = _refreshController;
@synthesize arrayOfDataToRefresh = _arrayOfDataToRefresh;
@synthesize currentNumber;

#pragma mark - Initialization
- (id)initWithASPullToRefreshTableViewController:(ASPullToRefreshTableViewController*)refreshController
{
    
    if ( self = [super init] ) {
        
        // Reference ExampleTableViewManager as ExampleTableViewController's UITableViewDelegate
        self.refreshController = refreshController;
        
        // Reference ExampleTableViewManager as ExampleTableViewController's UITableViewDelegate
        self.refreshController.tableView.delegate = self;
        
        // Reference ExampleTableViewManager as ExampleTableViewController's UITableViewDataSource
        self.refreshController.tableView.dataSource = self;
        
        // Reference ExampleTableViewManager as ExampleTableViewController's ASPullToRefreshDelegate
        self.refreshController.refreshDelegate = self;
        
        // Basic initialization
        self.arrayOfDataToRefresh = [[NSMutableArray alloc] initWithObjects:@"How many times have you refreshed?", nil];
        self.refreshController.title = @"NUMBER";
        [self.refreshController.tableView reloadData];
        
    }
    
    return self;
}

#pragma mark - UITableViewDataSource Methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.arrayOfDataToRefresh count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *CellIdentifier = @"CellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    cell.textLabel.text = [self.arrayOfDataToRefresh objectAtIndex:indexPath.row];
    cell.textLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:14];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

/// THE METHODS BELOW ARE REQUIRED IN EVERY TABLE VIEW MANAGER
#pragma mark - ASPullToRefreshDelegate methods
- (void)dataToRefresh
{
    
    /*
     
     Perform refresh-based actions here (e.g., API Requests, Core Data Requests, etc...)
     These ccommands/actiosn can be placed in separate methods - jsut amke sure they're called in this method.
     
     As an exmaple, I increment the number each time a pull-to-refresh has occured.
     
     */
    
    self.currentNumber++;
    NSNumber *number = [NSNumber numberWithInt:currentNumber];
    [self.arrayOfDataToRefresh insertObject:[NSString stringWithFormat:@"%@", number] atIndex:0];
    
    // Refresh the table after your method have completed
    [self.refreshController.tableView reloadData];
    
    // Reset the 'refreshing' headerView as the every last step.
    [self.refreshController didFinishRefreshing];
    
}

#pragma mark - UIScrollViewDelegate Methods
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.refreshController scrollViewWillBeginDragging:scrollView];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self.refreshController scrollViewDidScroll:scrollView];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [self.refreshController scrollViewDidEndDragging:scrollView willDecelerate:decelerate];
}

@end