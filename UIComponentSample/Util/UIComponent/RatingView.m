//
//  RatingView.m
//  Innisfree_Global
//
//  Created by 박해진 on 2017. 2. 22..
//  Copyright © 2017년 Innisfree Co., Ltd. All rights reserved.
//

#import "RatingView.h"

#define DEFAULT_MAX_RATING      5

@implementation RatingView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    if (self) {
//        [self setMaxRating:5];
//        [self setMargin:0];
        [self setupRatingView];
    }
    
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    
    if (self) {
//        [self setMaxRating:5];
//        [self setMargin:0];
        [self setupRatingView];
    }
    
    return self;
}

- (void)setupRatingView {
    NSMutableArray<UIImage *> *images = [NSMutableArray new];
    
    for(int i=1; i<10; i++) {
        NSString *imageName = [@"common_icn_leaf_on" stringByAppendingFormat:@"%d", i];
        [images addObject:[UIImage imageNamed:imageName]];
    }
    [images addObject:[UIImage imageNamed:@"common_icn_leaf_on"]];
    
    [self setMarkImages:images];
    [self setUnmarkImage:[UIImage imageNamed:@"common_icn_leaf_off"]];
    
    self.margin = 0;
    self.maxRating = 5;
    self.rating = 0;
}

- (void)draw {
    
    for (UIImageView *subView in self.subviews) {
        [subView removeFromSuperview];
    }
    
    float width = (self.frame.size.width + _margin * (_maxRating - 1)) / _maxRating;
    float height = self.frame.size.height;
    
    float posX = 0;
    
//    float rating = self.rating / self.maxRating * 100;
//    int quotient = floor(rating * self.maxRating / 100);
    
    
    int rating = self.rating * 10;
    
    
    for (int i=0; i<self.maxRating; i++) {
        UIImageView *imageView = nil;
        int value = rating - i * 10;
        
        if (value >= 10) {
            imageView = [[UIImageView alloc] initWithImage:self.markImages[9]];
        } else {
            value %= 10;
            if (value > 0) {
                imageView = [[UIImageView alloc] initWithImage:self.markImages[value-1]];
            } else {
                imageView = [[UIImageView alloc] initWithImage:self.unmarkImage];
            }
        }

        CGRect rect = imageView.frame;
        rect.origin.x = posX;
        rect.size.height = height;
        rect.size.width = width;
        imageView.frame = rect;
        
//        [imageView setLeft:posX];
//        [imageView setHeight:height];
//        [imageView setWidth:width];
        
        [self addSubview:imageView];
        posX += imageView.frame.size.width + self.margin;
    }
}


@end
