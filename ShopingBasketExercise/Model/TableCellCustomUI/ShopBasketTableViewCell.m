//
//  ShopBasketTableViewCell.m
//  ShopingBasketExercise
//
//  Created by Manasa Parida on 17/11/15.
//  Copyright © 2015 DigitasLBi UK. All rights reserved.
//

#import "ShopBasketTableViewCell.h"
#import "BasketConstant.h"


@implementation ShopBasketTableViewCell


@synthesize name,price,imageView,defaultRating,prodRatingValue,addToBasket;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        // Initialization code
        
        imageView = [[UIImageView alloc]init];

        name = [[UILabel alloc]init];
        name.font = [UIFont fontWithName:kFontNameHelveticaBold size:15];
        name.lineBreakMode = NSLineBreakByWordWrapping;
        name.textAlignment = NSTextAlignmentLeft;
        name.textColor = [UIColor blackColor];
        
        price = [[UILabel alloc]init];
        price.font = [UIFont fontWithName:kFontNameHelvetica size:12];
        price.lineBreakMode = NSLineBreakByWordWrapping;
        price.textAlignment = NSTextAlignmentLeft;
        price.textColor = [UIColor blackColor];
        
        defaultRating = [[UILabel alloc]init];
        defaultRating.font = [UIFont fontWithName:kFontNameHelvetica size:25];
        defaultRating.font = [UIFont boldSystemFontOfSize:25];
        defaultRating.textAlignment = NSTextAlignmentLeft;
        defaultRating.textColor = kProductRatingColor;
        defaultRating.backgroundColor = [UIColor clearColor];
        
        prodRatingValue = [[UILabel alloc]init];
        prodRatingValue.font = [UIFont fontWithName:kFontNameHelvetica size:25];
        prodRatingValue.font = [UIFont boldSystemFontOfSize:25];
        prodRatingValue.textAlignment = NSTextAlignmentLeft;
        prodRatingValue.textColor = [UIColor orangeColor];
        prodRatingValue.backgroundColor = [UIColor clearColor];
        
        addToBasket = [[UIButton alloc]init];
        CALayer *customButtonLayer = addToBasket.layer;
        customButtonLayer.cornerRadius = 5.0;
        [addToBasket setImage:[UIImage imageNamed:kAddToCartImageName] forState:UIControlStateNormal];

        
        [self.contentView addSubview:imageView];
        [self.contentView addSubview:name];
        [self.contentView addSubview:price];
        [self.contentView addSubview:defaultRating];
        [self.contentView addSubview:prodRatingValue];
        [self.contentView addSubview:addToBasket];

    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGRect contentRect = self.contentView.bounds;
    CGFloat boundsX = contentRect.origin.x;
    CGRect frame;
    
    frame = CGRectMake(kProductImageFrame);
    imageView.frame = frame;
    
    frame = CGRectMake(kProductNameFrame);
    name.frame = frame;
    
    frame = CGRectMake(kProductPriceFrame);
    price.frame = frame;

    frame = CGRectMake(kDefaultRatingFrame);
    defaultRating.frame = frame;

    frame = CGRectMake(kProductRatingFrame);
    prodRatingValue.frame = frame;
    
    frame = CGRectMake(kAddToBasketFrame);
    addToBasket.frame = frame;


}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
