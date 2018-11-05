//
//  RoundProgressView.h
//  Example
//
//  Created by Ryan Kim on 2017. 3. 16..
//  Copyright © 2017년 Digitalworks. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RoundProgressView : UIView


@property (nonatomic,readwrite) CGPoint drawPoint;
@property (nonatomic,readwrite) CGFloat startDegree;
@property (nonatomic,readwrite) CGFloat endDegree;
@property (nonatomic,readwrite) IBInspectable CGFloat radius;
@property (nonatomic,readwrite) IBInspectable CGFloat lineWidth;
@property (nonatomic,readwrite) CGFloat spacing;
@property (nonatomic,readwrite,retain) IBInspectable UIColor *barColor;
@property (nonatomic,readwrite,retain) IBInspectable UIColor *progressColor;

-(void)setProgress:(NSInteger)progress;

@end
