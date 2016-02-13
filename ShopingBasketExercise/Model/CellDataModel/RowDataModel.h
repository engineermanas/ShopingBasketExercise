//
//  RowDataModel.h
//  ShopingBasketExercise
//
//  Created by Manasa Parida on 17/11/15.
//  Copyright © 2015 DigitasLBi UK. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RowDataModel : NSObject

@property (nonatomic,strong) NSString *productID;
@property (nonatomic,strong) NSString *productImageIcon;
@property (nonatomic,strong) NSString *productName;
@property (nonatomic,strong) NSString *productPrice;
@property (nonatomic,strong) NSString *defaultRating;
@property (nonatomic,strong) NSString *productRating;

+ (BOOL)dataObjectIsNilwithObject:(id)object;

@end
