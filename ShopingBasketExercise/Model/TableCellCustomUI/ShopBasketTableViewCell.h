//
//  ShopBasketTableViewCell.h
//  ShopingBasketExercise
//
//  Created by Manasa Parida on 17/11/15.
//  Copyright © 2015 DigitasLBi UK. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShopBasketTableViewCell : UITableViewCell


@property (nonatomic,strong) UILabel *name;
@property (nonatomic,strong) UILabel *price;
@property (nonatomic,strong) UIImageView *imageView;
@property (nonatomic,strong) UILabel *defaultRating;
@property (nonatomic,strong) UILabel *prodRatingValue;
@property (nonatomic,strong) UIButton *addToBasket;



@end
