//
//  AlertPopView.m
//  ShopingBasketExercise
//
//  Created by Manasa Parida on 17/11/15.
//  Copyright © 2015 DigitasLBi UK. All rights reserved.
//

#import "AlertPopView.h"
#import "BasketConstant.h"


@implementation AlertPopView

+(instancetype)sharedInstance {
    
    static dispatch_once_t pred = 0;
    static AlertPopView *sharedInstance = nil;
    
    dispatch_once(&pred, ^{
        
        sharedInstance = [[AlertPopView alloc] init];
    });
    return sharedInstance;
}

// We can aslo customized more in this method to pass extra information to display

-(void)showAlertToUserWithView:(UIViewController *)view WithAlertMessage:(NSString *)message
{
    UIAlertController * alertView=   [UIAlertController alertControllerWithTitle:kAlertTitle
                                                                         message:message
                                                                  preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* yesButton = [UIAlertAction actionWithTitle:kAlertAction
                                                        style:UIAlertActionStyleDefault
                                                      handler:^(UIAlertAction * action) {
                                                          
                                                          [alertView dismissViewControllerAnimated:YES completion:nil];
                                                          
                                                      }];
    // Add Alert Action to the Alert Controller
    [alertView addAction:yesButton];
    
    // Now time to show the Alert with aleart action on top of the view
    [view presentViewController:alertView animated:YES completion:nil];
}


@end
