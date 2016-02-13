//
//  ShopBasketCacheManager.h
//  ShopingBasketExercise
//
//  Created by Manasa Parida on 17/11/15.
//  Copyright © 2015 DigitasLBi UK. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>
#import "RowDataModel.h"


@interface ShopBasketCacheManager : NSObject
{
    NSString *databasePath;
    sqlite3 *basketDB;
    sqlite3_stmt *statement;
}

+(instancetype)sharedInstance;

#pragma mark
#pragma mark - Sqlite - Create - Save - Retrieve

-(void)createDBForBasket;
-(void)saveBasketDataIntoDB:(NSMutableDictionary *)basketDictData;
-(NSMutableArray *)getDataFromDB;


#pragma mark
#pragma mark - Temporary - Storage - Save - Retrieve

-(void)setTemporaryData:(NSMutableDictionary *)selectedData;
-(NSArray *)getTemporaryData;


#pragma mark
#pragma mark - Common Helper For DB and Temporary Storage

// Common helper function for selectedData both DB and TemporaryStorage
-(void)dataToStoreInLocalStorage:(RowDataModel *)selectedData;
-(void)dataToRemoveFromLocalStorage:(RowDataModel *)selectedData withIndex:(NSInteger)indexRow;


#pragma mark
#pragma mark - AutoSync - Setter - Getter

-(BOOL)isAutoSyncOn;
-(void)setAutoSyncOn:(BOOL)syncOn;

#pragma mark
#pragma mark - Invalidate Storage

-(void)setInvalidate:(BOOL)invalidate;
-(BOOL)isInvalidate;
-(void)invalidateDataFromLocalStorage;

#pragma mark
#pragma mark - Static Data From Plist

-(NSMutableArray *)feedDataIntoTableFromPlist:(NSString *)fileName;
-(NSMutableArray *)feedDataIntoTableFromLocalStorage;


@end
