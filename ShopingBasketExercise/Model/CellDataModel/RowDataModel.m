//
//  RowDataModel.m
//  ShopingBasketExercise
//
//  Created by Manasa Parida on 17/11/15.
//  Copyright © 2015 DigitasLBi UK. All rights reserved.
//

#import "RowDataModel.h"

@implementation RowDataModel


- (id)init
{
    self = [super init];
    
    if (self) {
        
        // Initialization code here.
        self.productID = nil;
        self.productImageIcon = nil;
        self.productName = nil;
        self.productPrice = nil;
        self.defaultRating = nil;
        self.productRating = nil;
    }
    
    return self;
}

+ (BOOL)dataObjectIsNilwithObject:(id)object
{
    BOOL objectIsNil;
    NSString *objectAsString;
    
    if ([object isKindOfClass:[NSString class]]) {
        
        objectAsString = (NSString *)object;
        
        if (objectAsString == nil || [objectAsString isEqualToString:@""] || objectAsString == (id)[NSNull null]) {
            objectIsNil = YES;
            return objectIsNil;
        }
        else {
            objectIsNil = NO;
            return objectIsNil;
        }
    }
    else {
        if (object != nil) {
            objectIsNil = NO;
            return objectIsNil;
        }
        else {
            objectIsNil = YES;
            return objectIsNil;
        }
    }
}
@end
