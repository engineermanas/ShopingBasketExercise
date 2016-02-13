//
//  ShopBasketCacheManager.m
//  ShopingBasketExercise
//
//  Created by Manasa Parida on 17/11/15.
//  Copyright © 2015 DigitasLBi UK. All rights reserved.
//

#import "ShopBasketCacheManager.h"
#include "BasketConstant.h"


@implementation ShopBasketCacheManager


#pragma mark - Singleton Object
#pragma mark

+(instancetype)sharedInstance {
    
    static dispatch_once_t pred = 0;
    static ShopBasketCacheManager *sharedInstance = nil;
    
    dispatch_once(&pred, ^{
        
        sharedInstance = [[ShopBasketCacheManager alloc] init];
    });
    return sharedInstance;
}


#pragma mark - AutoSyncOn Settter and Getter
#pragma mark

// Setter method for auto sync
-(void)setAutoSyncOn:(BOOL)syncOn
{
    [[NSUserDefaults standardUserDefaults] setBool:syncOn forKey:kAutoSyncOnOffKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    // When user turn to autosync on , app will persisit all the temporary data into local storage
    [self addTemporaryDataIntoDB];
}

// Getter method for auto sync

-(BOOL)isAutoSyncOn
{
    return [[NSUserDefaults standardUserDefaults] boolForKey:kAutoSyncOnOffKey];
}

#pragma mark
#pragma mark - Invalidate Storage

// Setter method for Invalidate Storage
-(void)setInvalidate:(BOOL)invalidate
{
    [[NSUserDefaults standardUserDefaults] setBool:invalidate forKey:kInvalidateOnOffKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    // When user turn to autosync on , app will persisit all the temporary data into local storage
    [self addTemporaryDataIntoDB];
}

// Getter method for Invalidate Storage

-(BOOL)isInvalidate
{
    return [[NSUserDefaults standardUserDefaults] boolForKey:kInvalidateOnOffKey];
}

// Invalidate Storage Permanently
-(void)invalidateDataFromLocalStorage
{
    
    if ([self isAutoSyncOn])
    {
        [self deleteAllDataFromDB];
    }
    else
    {
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:kTemporaryObjectKey];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

#pragma mark
#pragma mark - Temporary - Storage - Save - Retrieve

// Save Temporary Data
-(void)setTemporaryData:(NSMutableDictionary *)selectedData
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    NSMutableArray *tempArray = [NSMutableArray new];
    
    if ([self getTemporaryData]) {
        
        // Hold the old data into tempArray
        tempArray = [[self getTemporaryData] mutableCopy];
    }
    // Add the newly selected data to temparray
    [tempArray addObject:selectedData];
    
    // Finaly Save the merged tempArray data
    [userDefaults setObject:tempArray forKey:kTemporaryObjectKey];
    [userDefaults synchronize];
}

// Retrieve Temporary Data
-(NSArray *)getTemporaryData
{
    return [[NSUserDefaults standardUserDefaults] valueForKey:kTemporaryObjectKey];
}

// App will persisit all the temporary data into local storage
-(void)addTemporaryDataIntoDB
{
    // Get Temporary Data
    NSArray *readTempArray = [self getTemporaryData];
    
    if (readTempArray != nil)
    {
        for (NSDictionary *localDictionary in readTempArray)
        {
            NSMutableDictionary *innnerDict = [NSMutableDictionary new];
            
            // For Product Image
            if(![[localDictionary valueForKey:kProductImage] isKindOfClass:[NSNull class]]) {
                
                [innnerDict setValue:[localDictionary valueForKey:kProductImage] forKey:kProductImage];
                
            }else {
                
                [innnerDict setValue:kNillString forKey:kProductImage];
            }
            
            // For Product Name
            if(![[localDictionary valueForKey:kProductName] isKindOfClass:[NSNull class]]) {
                
                [innnerDict setValue:[localDictionary valueForKey:kProductName] forKey:kProductName];
                
            }else {
                
                [innnerDict setValue:kNillString forKey:kProductName];
            }
            
            // For Product Price
            if(![[localDictionary valueForKey:kProductPrice] isKindOfClass:[NSNull class]]) {
                
                [innnerDict setValue:[localDictionary valueForKey:kProductPrice] forKey:kProductPrice];
                
            }else {
                
                [innnerDict setValue:kNillString forKey:kProductPrice];
            }
            
            // For Product Default Rating
            if(![[localDictionary valueForKey:kDefaultRating] isKindOfClass:[NSNull class]]) {
                
                [innnerDict setValue:[localDictionary valueForKey:kDefaultRating] forKey:kDefaultRating];
                
            }else {
                
                [innnerDict setValue:kNillString forKey:kDefaultRating];
            }
            
            // For Product Rating
            if(![[localDictionary valueForKey:kProductRating] isKindOfClass:[NSNull class]]) {
                
                [innnerDict setValue:[localDictionary valueForKey:kProductRating] forKey:kProductRating];
                
            }else {
                
                [innnerDict setValue:kNillString forKey:kProductRating];
            }
            
            // Add the Dictionary into DB
            [self saveBasketDataIntoDB:innnerDict];
        }
        
        // Once Temporary Data Added Into DB !! Remove All the Cached Temporary Data
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:kTemporaryObjectKey];
        [[NSUserDefaults standardUserDefaults] synchronize];

    }

}

#pragma mark
#pragma mark - Sqlite - Create - Save - Retrieve

// Create Basket DB and Basket Table
-(void)createDBForBasket
{
    // Get the documents directory Path
    NSArray *dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);

    NSString *docsDir = [dirPaths objectAtIndex:0];
    
    // Build the path to the database file
    databasePath = [[NSString alloc] initWithString: [docsDir stringByAppendingPathComponent:kBasketDBName]];
    
    NSFileManager *filemgr = [NSFileManager defaultManager];
    
    if ([filemgr fileExistsAtPath: databasePath ] == NO) {
        
        const char *dbpath = [databasePath UTF8String];
        
        if (sqlite3_open(dbpath, &basketDB) == SQLITE_OK) {
            
            char *errMsg;
            const char *sql_stmt = kTableCreationQuery;
            
            if (sqlite3_exec(basketDB, sql_stmt, NULL, NULL, &errMsg) != SQLITE_OK) {
                
                NSLog(@"Fail To Create Table in Basket.db");
            }
            sqlite3_close(basketDB);
        }
        else {
                NSLog(@"Fail to Create Basket.db ");        }
    }
}

// Save Data Into Basket DB
-(void)saveBasketDataIntoDB:(NSMutableDictionary *)basketDictData
{
    const char *dbpath = [databasePath UTF8String];
    
    if (sqlite3_open(dbpath, &basketDB) == SQLITE_OK)
    {
        NSString *insertSQL = [NSString stringWithFormat: kTableDataInsertQuery, [basketDictData valueForKey:kProductName], [basketDictData valueForKey:kProductPrice], [basketDictData valueForKey:kProductImage], [basketDictData valueForKey:kDefaultRating],[basketDictData valueForKey:kProductRating]];
        
        const char *insert_stmt = [insertSQL UTF8String];
        
        sqlite3_prepare_v2(basketDB, insert_stmt, -1, &statement, NULL);
        
        sqlite3_bind_text(statement, 1, [insertSQL UTF8String], -1, SQLITE_TRANSIENT);
        
        if (sqlite3_step(statement) == SQLITE_DONE)
        {
            NSLog(@"New Data Added Succesfully into Basket Table");
            
        } else {
            
            NSLog(@"Fail to Add New Data into BasketTable");
        }
        sqlite3_finalize(statement);
        sqlite3_close(basketDB);
    }
}

// Delete Selcted data From DB
-(void)deleteDataFromDBWithUniqueID:(NSString *)dataToDelete
{
    const char *dbpath = [databasePath UTF8String];
    
    if (sqlite3_open(dbpath, &basketDB) == SQLITE_OK)
    {
        NSString *deleteSQLQuery = [NSString stringWithFormat:kSelectedDataToDelete,dataToDelete];
        
        const char *delete_stmt = [deleteSQLQuery UTF8String];
        
        sqlite3_prepare_v2(basketDB, delete_stmt,-1, &statement, NULL);
        if (sqlite3_step(statement) == SQLITE_DONE)
        {
            NSLog(@"Record Deleted ");
            
        } else {
            
            NSLog(@"Failed to Delete Record");
        }
        sqlite3_finalize(statement);
        sqlite3_close(basketDB);
    }
}

// Delete All Rows From DB
-(void)deleteAllDataFromDB
{
    const char *dbpath = [databasePath UTF8String];
    
    if (sqlite3_open(dbpath, &basketDB) == SQLITE_OK)
    {
        NSString *deleteSQLQuery = [NSString stringWithFormat:kDeleteAllDataFromDB];
        
        const char *delete_stmt = [deleteSQLQuery UTF8String];
        
        sqlite3_prepare_v2(basketDB, delete_stmt,-1, &statement, NULL);
        if (sqlite3_step(statement) == SQLITE_DONE)
        {
            NSLog(@"All Record Deleted ");
            
        } else {
            
            NSLog(@"Failed to Delete All Record");
        }
        sqlite3_finalize(statement);
        sqlite3_close(basketDB);
    }
}

// Retrieve Data From Basket DB
-(NSMutableArray *)getDataFromDB
{
    NSMutableArray *basketDataArray = [NSMutableArray new];
    // Remove all the old data from Array
    [basketDataArray removeAllObjects];
    
    const char *dbpath = [databasePath UTF8String];
    
    if (sqlite3_open(dbpath, &basketDB) == SQLITE_OK)
    {
        sqlite3_prepare_v2(basketDB, kTableDataRetrieveQuery, -1, &statement, nil);
        while(sqlite3_step(statement) == SQLITE_ROW)
        {
            // Temp dictionary to hold the internal data
            NSMutableDictionary *tempDict = [NSMutableDictionary new];
            
            // UniqueID
            char *pID = (char *) sqlite3_column_text(statement,0);
            NSString *uniqueID = pID ? [[NSString alloc]initWithUTF8String:pID] : kNillString;
            [tempDict setValue:uniqueID forKey:kProductUniqueID];
            
            // Name
            char *pName = (char *) sqlite3_column_text(statement,1);
            NSString *name = pName ? [[NSString alloc]initWithUTF8String:pName] : kNillString;
            [tempDict setValue:name forKey:kProductName];

            // Price
            char *pPrice = (char *) sqlite3_column_text(statement,2);
            NSString *price = pPrice ? [[NSString alloc]initWithUTF8String:pPrice] : kNillString;
            [tempDict setValue:price forKey:kProductPrice];

            // Image
            char *pImage = (char *) sqlite3_column_text(statement,3);
            NSString *image = pImage ? [[NSString alloc]initWithUTF8String:pImage] : kNillString;
            [tempDict setValue:image forKey:kProductImage];

            // Default Rating
            char *pDRating = (char *) sqlite3_column_text(statement,4);
            NSString *defaultrating = pDRating ? [[NSString alloc]initWithUTF8String:pDRating] : kNillString;
            [tempDict setValue:defaultrating forKey:kDefaultRating];

            // Rating
            char *pRating = (char *) sqlite3_column_text(statement,5);
            NSString *rating = pRating ? [[NSString alloc]initWithUTF8String:pRating] : kNillString;
            [tempDict setValue:rating forKey:kProductRating];
            
            // Add one by one into array
            [basketDataArray addObject:tempDict];
        }
        
        sqlite3_finalize(statement);
        sqlite3_close(basketDB);
    }
        return basketDataArray;
}

#pragma mark - Common Local Cache Helper Function
#pragma mark

-(void)dataToStoreInLocalStorage:(RowDataModel *)selectedData
{
 
    // To hold the selected product as dictionary format
    NSMutableDictionary *tempictionary = [NSMutableDictionary new];
    
    // For product name
    BOOL hasProductName = [RowDataModel dataObjectIsNilwithObject:selectedData.productName];
    if (!hasProductName)
    {
        [tempictionary setValue:selectedData.productName forKey:kProductName];
    }
    
    // For product price
    BOOL hasPriceName = [RowDataModel dataObjectIsNilwithObject:selectedData.productPrice];
    
    if (!hasPriceName)
    {
        [tempictionary setValue:selectedData.productPrice forKey:kProductPrice];
    }
    
    // For product image
    BOOL hasProductImageIconr = [RowDataModel dataObjectIsNilwithObject:selectedData.productImageIcon];
    
    if (!hasProductImageIconr)
    {
        [tempictionary setValue:selectedData.productImageIcon forKey:kProductImage];
    }
    
    // For default rating
    BOOL hasDefaultRating = [RowDataModel dataObjectIsNilwithObject:selectedData.defaultRating];
    
    if (!hasDefaultRating)
    {
        [tempictionary setValue:selectedData.defaultRating forKey:kDefaultRating];
    }
    
    // For product rating
    BOOL hasProductRating = [RowDataModel dataObjectIsNilwithObject:selectedData.productRating];
    
    if (!hasProductRating)
    {
        [tempictionary setValue:selectedData.productRating forKey:kProductRating];
    }
    
    // Auto Sync Logical Check
    if ([self isAutoSyncOn])
    {
        // If Auto Sync Yes Store Directly Into DB
       [self saveBasketDataIntoDB:tempictionary];
    }
    else
    {
        // If Auto Sync No Save the Data as Temporary storage
        [self setTemporaryData:tempictionary];
    }
}

// Remove Data From Local Storage which has been deleted by the user from basket
-(void)dataToRemoveFromLocalStorage:(RowDataModel *)selectedData withIndex:(NSInteger)indexRow
{
    if ([self isAutoSyncOn])
    {
        [self deleteDataFromDBWithUniqueID:selectedData.productID];
    }
    else
    {
        // Get all the Temporary Data as Mutable Copy
        NSMutableArray *tempArray = [(NSMutableArray *)[self getTemporaryData] mutableCopy];
        
        // Removed the Index which user has been deleted from basket
        [tempArray removeObjectAtIndex:indexRow];
        
        // Now update the latest Temporary array data
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        [userDefaults setObject:tempArray forKey:kTemporaryObjectKey];
        [userDefaults synchronize];
    }
}


#pragma mark - Data Provider to tableView from Plist
#pragma mark

-(NSMutableArray *)feedDataIntoTableFromPlist:(NSString *)fileName
{
    NSMutableArray *feedDataInTableArray = [NSMutableArray new];
    // Get the Product list array from Plist
    NSArray *tempArray = [self getDataFromPlist:fileName];
    
    for (NSDictionary *localDictionary in tempArray) {
        
        RowDataModel *dataModel = [[RowDataModel alloc] init];
        
        // For Product Image
        if(![[localDictionary valueForKey:kProductImage] isKindOfClass:[NSNull class]]) {
            
            dataModel.productImageIcon = [localDictionary valueForKey:kProductImage];
            
        }else {
            
            dataModel.productImageIcon = kNillString;
        }
        
        // For Product Name
        if(![[localDictionary valueForKey:kProductName] isKindOfClass:[NSNull class]]) {
            
            dataModel.productName = [localDictionary valueForKey:kProductName];
            
        }else {
            
            dataModel.productName = kNillString;
        }
        
        // For Product Price
        if(![[localDictionary valueForKey:kProductPrice] isKindOfClass:[NSNull class]]) {
            
            dataModel.productPrice = [localDictionary valueForKey:kProductPrice];
            
        }else {
            
            dataModel.productPrice = kNillString;
        }
        
        // For Product Default Rating
        if(![[localDictionary valueForKey:kDefaultRating] isKindOfClass:[NSNull class]]) {
            
            dataModel.defaultRating = [localDictionary valueForKey:kDefaultRating];
            
        }else {
            
            dataModel.defaultRating = kNillString;
        }
        
        // For Product Rating
        if(![[localDictionary valueForKey:kProductRating] isKindOfClass:[NSNull class]]) {
            
            dataModel.productRating = [localDictionary valueForKey:kProductRating];
            
        }else {
            
            dataModel.productRating = kNillString;
        }

        [feedDataInTableArray addObject:dataModel];
    }
    
    return feedDataInTableArray;
}

#pragma mark - Data Provider to tableView from LocalStorage
#pragma mark


-(NSMutableArray *)feedDataIntoTableFromLocalStorage
{
    // Hold updated array data which return to tableview
    NSMutableArray *feedDataInTableArray = [NSMutableArray new];
    
    NSMutableArray *tempDataToIterate = [NSMutableArray new];
    
    // Auto Sync Logical Check

    if ([self isAutoSyncOn])
    {
        tempDataToIterate =  [self getDataFromDB];
    }
    else
    {
       tempDataToIterate = (NSMutableArray *)[self getTemporaryData];
    }
    
    // Use the temp array Data To Iterate in dictionary to create datamodel
    for (NSDictionary *localDictionary in tempDataToIterate) {

        RowDataModel *dataModel = [[RowDataModel alloc] init];
        
        // Product UniqueID
        if(![[localDictionary valueForKey:kProductUniqueID] isKindOfClass:[NSNull class]]) {
            
            dataModel.productID = [localDictionary valueForKey:kProductUniqueID];
            
        }else {
            
            dataModel.productID = kNillString;
        }

        // For Product Image
        if(![[localDictionary valueForKey:kProductImage] isKindOfClass:[NSNull class]]) {
            
            dataModel.productImageIcon = [localDictionary valueForKey:kProductImage];
            
        }else {
            
            dataModel.productImageIcon = kNillString;
        }
        
        // For Product Name
        if(![[localDictionary valueForKey:kProductName] isKindOfClass:[NSNull class]]) {
            
            dataModel.productName = [localDictionary valueForKey:kProductName];
            
        }else {
            
            dataModel.productName = kNillString;
        }
        
        // For Product Price
        if(![[localDictionary valueForKey:kProductPrice] isKindOfClass:[NSNull class]]) {
            
            dataModel.productPrice = [localDictionary valueForKey:kProductPrice];
            
        }else {
            
            dataModel.productPrice = kNillString;
        }
        
        // For Product Default Rating
        if(![[localDictionary valueForKey:kDefaultRating] isKindOfClass:[NSNull class]]) {
            
            dataModel.defaultRating = [localDictionary valueForKey:kDefaultRating];
            
        }else {
            
            dataModel.defaultRating = kNillString;
        }
        
        // For Product Rating
        if(![[localDictionary valueForKey:kProductRating] isKindOfClass:[NSNull class]]) {
            
            dataModel.productRating = [localDictionary valueForKey:kProductRating];
            
        }else {
            
            dataModel.productRating = kNillString;
        }
        
        [feedDataInTableArray addObject:dataModel];
    }
    
    return feedDataInTableArray;
}

#pragma mark - Data Reader From Plist
#pragma mark

-(NSArray *)getDataFromPlist:(NSString *)plistFileName
{
    // Get the plist document directory
    NSString *plistPath = [self getPlistFromDocumentDirectory:plistFileName];
    
    // Get the raw data from plist
    NSArray *plistArrayData = [NSArray arrayWithContentsOfFile:plistPath];
    
    return plistArrayData;
}

#pragma mark - NSSearchPathForDirectoriesInDomains (NSDocumentDirectory)
#pragma mark - fileExistsAtPath copyItem AtPath toPath

-(NSString *)getPlistFromDocumentDirectory:(NSString *)fileName
{
    // Validate the errors
    
    NSError *errorDesc = nil;
    
    // Get paths from root direcory
    NSArray *paths = NSSearchPathForDirectoriesInDomains (NSDocumentDirectory, NSUserDomainMask, YES);
    
    // Get documents directory path
    NSString *documentsPath = [paths objectAtIndex:0];
    
    // Get the plist path from DocumentDirectory File Path
    NSString *plistDocumentDirectoryPath = [documentsPath stringByAppendingPathComponent:kPlistFileNameWithExt(fileName)];
    
    NSString *plistFromNSMainBundle = [[NSBundle mainBundle] pathForResource:kPlistFileName(fileName) ofType:kFileType];
    // check if file exist or not
    if ([[NSFileManager defaultManager] fileExistsAtPath:plistDocumentDirectoryPath])
    {
        // **************************** Skip iCloud Backup **************************************
        //[self addSkipBackupAttributeToItemAtURL:[NSURL fileURLWithPath:plistDocumentDirectoryPath]];
    }
    else
    {
        // If no copy from NSMainBundle then put into document directory
        [[NSFileManager defaultManager]copyItemAtPath:plistFromNSMainBundle toPath:plistDocumentDirectoryPath error:&errorDesc];
        
        // When copy from NSMainBundle to document directory if any errors highlight below
        if (errorDesc)
        {
            NSLog(@"CacheManager copyFrom %@  || toPath %@ || error%@",plistFromNSMainBundle,plistDocumentDirectoryPath,errorDesc.localizedDescription);
            
            // If error when copying read from NSMainBundle
            plistDocumentDirectoryPath = plistFromNSMainBundle;
        }
    }
    
    return plistDocumentDirectoryPath;
}

#pragma mark - SkipBackupAttribute
#pragma mark

// Also ensures that skipbackup attribute is set for each file

- (BOOL)addSkipBackupAttributeToItemAtURL:(NSURL *)URL
{
    if(NO == [[NSFileManager defaultManager] fileExistsAtPath: [URL path]] )
    {
        return NO;
    }
    
    NSError *error = nil;
    BOOL success = [URL setResourceValue:[NSNumber numberWithBool: YES]
                                  forKey: NSURLIsExcludedFromBackupKey error: &error];
    if(!success){
        NSLog(@"#### Error excluding %@ from backup %@", [URL lastPathComponent], error);
    }
    else
    {
        NSLog(@"NSURLIsExcludedFromBackupKey set for %@",URL);
    }
    return success;
}

@end