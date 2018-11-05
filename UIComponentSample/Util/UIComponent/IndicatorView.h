//
//  IndicatorView.h
//  Swipe
//
//  Created by Ryan Kim on 2017. 1. 6..
//  Copyright © 2017년 Digitalworks. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, StartPoint) {
    StartPointLeft = 0,
    StartPointRight,
};

@interface IndicatorView : UIView

@property (nonatomic) int count;

-(instancetype)initWithFrame:(CGRect)frame withCount:(int)count;

-(void)drawIndicatorWithSize:(CGSize)size withDistance:(CGFloat)distance withOnImage:(UIImage *)onImage withOffImage:(UIImage *)offImage startPoint:(StartPoint)startPoint;
- (void)setIndex:(int)index;

@end
