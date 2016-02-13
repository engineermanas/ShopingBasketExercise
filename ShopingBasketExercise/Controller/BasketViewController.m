//
//  SecondViewController.m
//  ShopingBasketExercise
//
//  Created by Manasa Parida on 17/11/15.
//  Copyright © 2015 DigitasLBi UK. All rights reserved.
//

#import "BasketViewController.h"
#import "ShopBasketTableViewCell.h"
#import "BasketConstant.h"
#import "RowDataModel.h"
#import "ShopBasketCacheManager.h"
#import "AlertPopView.h"

@interface BasketViewController () <UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,weak) IBOutlet UITableView *basketTableView;
@property (nonatomic,strong) ShopBasketCacheManager *cachManager;
@property (nonatomic,strong) NSMutableArray *basketProductArray;

@end

@implementation BasketViewController

#pragma mark
#pragma mark - View Conrtoller Life Cycle


- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.basketProductArray = [NSMutableArray new];
    self.cachManager = [[ShopBasketCacheManager alloc] init];
    
    // Just add one observer to keep tracking when app Entered Foreground
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(applicationEnteredForeground:)
                                                 name:UIApplicationWillEnterForegroundNotification
                                               object:nil];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    // Call this method to populate the products in the table
    
    [self dataToLoadIntoBasketTable];
}

// This method will call when your app entered foreground
-(void)applicationEnteredForeground:(id)sender
{
    // Call this method to populate the products in the table
    [self dataToLoadIntoBasketTable];
}


-(void)dataToLoadIntoBasketTable
{
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH,  0ul);
    dispatch_async(queue, ^{
        
        // Get all the available product array in the background thread
        self.basketProductArray = [[ShopBasketCacheManager sharedInstance] feedDataIntoTableFromLocalStorage];
        
        // Once done call the main queue to populate the data on the tableview
        dispatch_sync(dispatch_get_main_queue(), ^{
            
            // Validation for the basket
            if (![self.basketProductArray count] && ![[ShopBasketCacheManager sharedInstance] isAutoSyncOn])
            {
                [[AlertPopView sharedInstance] showAlertToUserWithView:self WithAlertMessage:kOfflineBasketAlert];
            }
            else if (![self.basketProductArray count])
            {
                [[AlertPopView sharedInstance] showAlertToUserWithView:self WithAlertMessage:kOnlineBasketAlert];
            }
            
            // Reload the table in Main Thread
            [self.basketTableView reloadData];
        });
    });
}
#pragma mark
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return kTableCellHeight;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    
    return [self.basketProductArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    // Cell indentifie Instance
    static NSString *CellIdentifier = kTableCell;
    
    // Customizable Cell Instance which is going to use as ReusableCell
    ShopBasketTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    // Cell object validation
    if (cell == nil) {
        
        cell = [[ShopBasketTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        // Cell background color
        cell.backgroundColor = kCellBackgroundColor;
    }
    
    // Get the RowDataModel instnce to set the Cell Index All Value
    RowDataModel *rowDataFeed = [self.basketProductArray objectAtIndex:indexPath.row];
    cell.imageView.image = [UIImage imageNamed:rowDataFeed.productImageIcon];
    cell.name.text = rowDataFeed.productName;
    cell.price.text = rowDataFeed.productPrice;
    cell.defaultRating.text = rowDataFeed.defaultRating;
    cell.prodRatingValue.text = rowDataFeed.productRating;
    cell.addToBasket.hidden = YES;
    
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        // First keep the object which was going to be deleted
        RowDataModel *dataModelHelper = [self.basketProductArray objectAtIndex:indexPath.row];

        // Remove the deleted object from local storage.
        [[ShopBasketCacheManager sharedInstance] dataToRemoveFromLocalStorage:dataModelHelper withIndex:indexPath.row];

        // If your source is an NSMutableArray do this
        [self.basketProductArray removeObjectAtIndex:indexPath.row];

        // tell table to refresh now
        [tableView reloadData];
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
