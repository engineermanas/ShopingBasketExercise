//
//  AlertPopView.h
//  ShopingBasketExercise
//
//  Created by Manasa Parida on 17/11/15.
//  Copyright © 2015 DigitasLBi UK. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AlertPopView : UIView

+(instancetype)sharedInstance;

// We can aslo customized more in this method to pass extra information to display
-(void)showAlertToUserWithView:(UIViewController *)view WithAlertMessage:(NSString *)message;

@end
