//
//  MoreViewController.m
//  ShopingBasketExercise
//
//  Created by Manasa Parida on 17/11/15.
//  Copyright © 2015 DigitasLBi UK. All rights reserved.
//

#import "MoreViewController.h"
#import "BasketConstant.h"
#import "ShopBasketCacheManager.h"
#import "AlertPopView.h"


@interface MoreViewController ()

@property (nonatomic, strong) UISwitch *autoSyncSwitch;
@property (nonatomic, strong) UISwitch *invalidateSwitch;
@property (nonatomic, strong) UILabel *autoSyncLabel;
@property (nonatomic, strong) UILabel *invalidateLabel;


@end

@implementation MoreViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.autoSyncLabel = [[UILabel alloc]initWithFrame:kAutoSyncLabelFrame];
    self.autoSyncLabel.font = [UIFont fontWithName:kFontNameHelveticaBold size:15];
    self.autoSyncLabel.lineBreakMode = NSLineBreakByWordWrapping;
    self.autoSyncLabel.textAlignment = NSTextAlignmentLeft;
    self.autoSyncLabel.textColor = [UIColor blackColor];
    self.autoSyncLabel.text = kAutoSyncLabelString;
    [self.view addSubview:self.autoSyncLabel];

    
    self.autoSyncSwitch = [[UISwitch alloc] initWithFrame:kAutoSyncSwitchFrame];
    [self.autoSyncSwitch addTarget:self action:@selector(changeAutoSyncSwitch:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:self.autoSyncSwitch];
    
    
    self.invalidateLabel = [[UILabel alloc]initWithFrame:kInvalidateLabelFrame];
    self.invalidateLabel .font = [UIFont fontWithName:kFontNameHelveticaBold size:15];
    self.invalidateLabel .lineBreakMode = NSLineBreakByWordWrapping;
    self.invalidateLabel .textAlignment = NSTextAlignmentLeft;
    self.invalidateLabel .textColor = [UIColor blackColor];
    self.invalidateLabel.text = kInvalidateLabelString;
    [self.view addSubview:self.invalidateLabel];

    
    self.invalidateSwitch = [[UISwitch alloc] initWithFrame:kInvalidateSwitchFrame];
    [self.invalidateSwitch addTarget:self action:@selector(changeInvalidateSwitch:) forControlEvents:UIControlEventValueChanged];
    //[self.invalidateSwitch setOn:YES];
    [self.view addSubview:self.invalidateSwitch];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)changeAutoSyncSwitch:(UISwitch *)sender {
    
    if(sender.on){
        
        // Execute any code when the switch is ON        
        [[ShopBasketCacheManager sharedInstance] setAutoSyncOn:sender.on];
        
        // Notify to the user about AutoSync has been On
        [[AlertPopView sharedInstance] showAlertToUserWithView:self WithAlertMessage:kAutoSyncOnAlert];
        
    } else {
        
        // Execute any code when the switch is OFF
        [[ShopBasketCacheManager sharedInstance] setAutoSyncOn:sender.on];
    }
}

- (void)changeInvalidateSwitch:(UISwitch *)sender {
    
    if(sender.on){
        
        [[ShopBasketCacheManager sharedInstance] setInvalidate:sender.on];
        // Delete all the offline and temporary data from the App
        [[ShopBasketCacheManager sharedInstance] invalidateDataFromLocalStorage];
        
        // Notify about this to user 
        [[AlertPopView sharedInstance] showAlertToUserWithView:self WithAlertMessage:kInvalidStorageAlert];
    }
    else
    {
        [[ShopBasketCacheManager sharedInstance] setInvalidate:sender.on];
    }
    
}

@end
