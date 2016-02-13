//
//  FirstViewController.m
//  ShopingBasketExercise
//
//  Created by Manasa Parida on 17/11/15.
//  Copyright © 2015 DigitasLBi UK. All rights reserved.
//

#import "HomeViewController.h"
#import "ShopBasketTableViewCell.h"
#import "BasketConstant.h"
#import "RowDataModel.h"
#import "ShopBasketCacheManager.h"
#import "AlertPopView.h"

@interface HomeViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic,weak) IBOutlet UITableView *homeTableView;
@property (nonatomic,strong) NSMutableArray *productArray;

@end

@implementation HomeViewController


#pragma mark
#pragma mark - ViewController LifeCycle

- (void)viewDidLoad {
    
    [super viewDidLoad];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH,  0ul);
    dispatch_async(queue, ^{
        
        // Get all the available product array in the background thread
        self.productArray = [[ShopBasketCacheManager sharedInstance] feedDataIntoTableFromPlist:kProductCatalogPlistFileName];
        
        // Once done call the main queue to populate the data on the tableview
        dispatch_sync(dispatch_get_main_queue(), ^{
            
            // Reload the table in Main Thread
            [self.homeTableView reloadData];
        });
    });
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    return [self.productArray count];
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

    // Get the RowsClass instnce to set the Cell Index All Value

    RowDataModel *rowDataFeed = [self.productArray objectAtIndex:indexPath.row];
    cell.imageView.image = [UIImage imageNamed:rowDataFeed.productImageIcon];
    cell.name.text = rowDataFeed.productName;
    cell.price.text = rowDataFeed.productPrice;
    cell.defaultRating.text = rowDataFeed.defaultRating;
    cell.prodRatingValue.text = rowDataFeed.productRating;
    cell.addToBasket.tag = indexPath.row;
    [cell.addToBasket addTarget:self action:@selector(addToBasketClicked:) forControlEvents:UIControlEventTouchUpInside];

    return cell;
}


#pragma mark
#pragma mark - Selected Data as AddToBasket

-(void)addToBasketClicked:(UIButton*)sender
{
    if ([[ShopBasketCacheManager sharedInstance] isInvalidate])
    {
        [[AlertPopView sharedInstance] showAlertToUserWithView:self WithAlertMessage:kInvalidateStorage];
        return;
    }
    
    // Catching the selectd data to show in Basket
    [[ShopBasketCacheManager sharedInstance] dataToStoreInLocalStorage:[self.productArray objectAtIndex:sender.tag]];
    
    // Show a pop-up to confirm the user, product has been Successfully added to basket
    [[AlertPopView sharedInstance] showAlertToUserWithView:self WithAlertMessage:kAlertSuccessfully];
}

@end
