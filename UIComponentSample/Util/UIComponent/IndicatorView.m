//
//  IndicatorView.m
//  Swipe
//
//  Created by Ryan Kim on 2017. 1. 6..
//  Copyright © 2017년 Digitalworks. All rights reserved.
//

#import "IndicatorView.h"



@interface IndicatorView()

@property(nonatomic,strong) NSMutableArray *indicators;
@property(nonatomic,strong) UIImage *onImage;
@property(nonatomic,strong) UIImage *offImage;

@end

@implementation IndicatorView

-(instancetype)initWithFrame:(CGRect)frame withCount:(int)count {
    
    self = [super initWithFrame:frame];
    
    if(self) {
        self.count = count;
    }
    
    return self;
}

-(instancetype)initWithCoder:(NSCoder *)aDecoder {
    
    self = [super initWithCoder:aDecoder];
    
    if(self) {
        
    }
    return self;
}
/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

-(void)drawIndicatorWithSize:(CGSize)size withDistance:(CGFloat)distance withOnImage:(UIImage *)onImage withOffImage:(UIImage *)offImage startPoint:(StartPoint)startPoint {
    
    for (UIView *subeView in self.subviews) {
        [subeView removeFromSuperview];
    }
    
    self.indicators = [NSMutableArray array];
    
    self.onImage = onImage;
    self.offImage = offImage;
    
    CGPoint centerPoint;
    centerPoint.x = startPoint == StartPointLeft ? 0 : self.frame.size.width - size.width * self.count - distance * (self.count - 1);
    centerPoint.y = (self.frame.size.height - size.height) / 2;
    
    for(int i = 0; i < self.count;i++) {
        UIImageView* imageViewIndicator = [[UIImageView alloc] init];
        
        [imageViewIndicator setFrame:CGRectMake(centerPoint.x + (distance + size.width)*i, centerPoint.y, size.width, size.height)];
        [imageViewIndicator setImage:offImage];
        
        [self.indicators addObject:imageViewIndicator];
        
        
    }
    
    for(UIImageView *view in self.indicators) {
        
        [self addSubview:view];
    }
    
    [self setIndex:0];
}
- (void)setIndex:(int)index {
    
    for(int i=0;i < [self.indicators count]; i++) {
        
        [self.indicators[i] setImage:self.offImage];
        
        if(i == index) {
            
            [self.indicators[i] setImage:self.onImage];
        }
    }
    
}

@end
