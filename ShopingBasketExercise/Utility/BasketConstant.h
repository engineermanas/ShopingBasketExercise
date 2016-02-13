//
//  Constant.h
//  ShopingBasket
//
//  Created by Manasa Parida on 17/11/15.
//  Copyright © 2015 DigitasLBi UK. All rights reserved.
//


#define  kCellBackgroundColor [UIColor colorWithRed:242.0f/255.0f green:242.0f/255.0f blue:242.0f/255.0f alpha:1.0f]
#define  kProductRatingColor  [UIColor colorWithRed:170.0/255.0 green:170.0/255.0 blue:170.0/255.0 alpha:1.0]

#define kTableCellHeight 69

// Custom Table Cell Frame

#define kProductImageFrame        boundsX + 5,10 ,50, 50
#define kProductNameFrame         boundsX + 65,10 ,340, 20
#define kProductPriceFrame        boundsX + 65,30 ,100, 20
#define kDefaultRatingFrame       boundsX + 65,50 ,100, 30
#define kProductRatingFrame       boundsX + 65,50 ,100, 30
#define kAddToBasketFrame         boundsX + 300,33 ,100,30

// MoreView Controler Switch and Label Layout Frames

#define kAutoSyncLabelFrame         CGRectMake(20, 100, 150, 20)
#define kAutoSyncSwitchFrame        CGRectMake(190, 100, 30, 20)
#define kInvalidateLabelFrame       CGRectMake(20, 200, 150, 20)
#define kInvalidateSwitchFrame      CGRectMake(190, 200, 30, 20)


// Plist File Name and File Extension

#define kFileType                        @"plist"
#define kProductCatalogPlistFileName     @"Product"
#define kPlistFileName(fileName)         [NSString stringWithFormat:@"%@",fileName]
#define kPlistFileNameWithExt(fileName)  [NSString stringWithFormat:@"%@.plist",fileName]
#define kAddToCartImageName              @"addtocartButton.png"

// Temporary Object Key

#define kTemporaryObjectKey       @"TemporaryData"

// Product data retrieve Key
#define kProductUniqueID          @"ProductUniqueID"
#define kProductKey               @"ProductData"
#define kProductName              @"ProductName"
#define kProductPrice             @"ProductPrice"
#define kProductImage             @"ProductImage"
#define kDefaultRating            @"DefaultRating"
#define kProductRating            @"ProductRating"

// FontStyle

#define  kFontNameHelveticaBold   @"Helvetica-Bold"
#define  kFontNameHelvetica       @"Helvetica"

// Defined Key

#define kNillString              @""
#define kRowKey                  @"rows"
#define kTitleKey                @"title"
#define kDescriptionKey          @"description"
#define kImageHrefKey            @"imageHref"

// ReusableCell Identifier

#define  kTableCell               @"Cell"

#define kAutoSyncLabelString      @"Auto Sync"
#define kInvalidateLabelString    @"Invalidate Storage"
#define kAutoSyncOnOffKey         @"AutoSyncOnOff"
#define kInvalidateOnOffKey       @"InvalidateOnOff"

// AlertView Relatd Macro

#define  kAlertTitle          @"Thank You"
#define  kAlertSuccessfully   @"Selected item successfully added to your basket."
#define  kAlertAction         @"Ok"
#define  kAutoSyncOnAlert     @"Your basket has been synced."
#define  kInvalidStorageAlert @"All the basket data has been deleted permanently."
#define  kInvalidateStorage   @"Turn off your Invalidate Storage"
#define  kOfflineBasketAlert  @"Basket might have already synced or Empty. Add new item to see your basket"
#define  kOnlineBasketAlert   @"Basket is empty try to ddd new item to see your basket"

// Sqlite (DB) Related Macro

#define kBasketDBName          @"Basket.db"

#define kTableCreationQuery    "CREATE TABLE IF NOT EXISTS BASKET (ID INTEGER PRIMARY KEY AUTOINCREMENT, NAME TEXT, PRICE TEXT, IMAGE TEXT, DEFAULTRATING TEXT, RATING TEXT)"

#define kTableDataInsertQuery  @"INSERT INTO BASKET (name, price, image, defaultrating, rating) VALUES (\"%@\", \"%@\", \"%@\", \"%@\", \"%@\")"

#define kTableDataRetrieveQuery "SELECT * FROM BASKET"

#define kSelectedDataToDelete   @"DELETE FROM BASKET WHERE ID=%@"
#define kDeleteAllDataFromDB    @"DELETE FROM BASKET"
