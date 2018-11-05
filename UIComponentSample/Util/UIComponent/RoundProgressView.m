//
//  RoundProgressView.m
//  Example
//
//  Created by Ryan Kim on 2017. 3. 16..
//  Copyright © 2017년 Digitalworks. All rights reserved.
//

#import "RoundProgressView.h"

#define degreesToRadians(x) ((x) * M_PI / 180.0)

@interface RoundProgressView()


@end

@implementation RoundProgressView

-(instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    
    if(self) {
        
        [self initialize];
    }
    return self;
}
-(instancetype)initWithCoder:(NSCoder *)aDecoder {
    
    self = [super initWithCoder:aDecoder];
    
    if(self) {
        
        [self initialize];
    }
    return self;
}
-(void)initialize {
    
    _drawPoint = CGPointMake(self.frame.size.height / 2, self.frame.size.width / 2);
    _startDegree = -230;
    _endDegree = (-270 - self.startDegree) + 90;
    _lineWidth = 20;
    _spacing = 0;
    _radius = self.frame.size.width / 2 - self.lineWidth - self.spacing;
    _barColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.2];
    _progressColor = [UIColor redColor];
    
}
-(void)setStartDegree:(CGFloat)startDegree {
    
    _startDegree = startDegree;
    _endDegree = (-270 - self.startDegree) + 90;
}
- (void)drawRect:(CGRect)rect {
    
    UIBezierPath *bezierPath = [UIBezierPath bezierPath];
    
    [bezierPath addArcWithCenter:self.drawPoint radius:self.radius startAngle:degreesToRadians(self.startDegree) endAngle:degreesToRadians(self.endDegree) clockwise:YES];
    
    [[UIColor clearColor] setFill];
    [self.barColor setStroke];
    
    bezierPath.lineWidth = self.lineWidth;
    bezierPath.lineCapStyle = kCGLineCapRound;
    [bezierPath fill];
    [bezierPath stroke];
}
-(void)setProgress:(NSInteger)progress {
    
    for (CALayer *layer in self.layer.sublayers) {
        [layer removeFromSuperlayer];
    }
    int i = fabs(self.startDegree) + self.endDegree;
    
    float value = self.startDegree + (progress * abs(i)/100);
    
    UIBezierPath *bezierPath2 = [UIBezierPath bezierPath];
    
    [bezierPath2 addArcWithCenter:self.drawPoint radius:self.radius startAngle:degreesToRadians(self.startDegree) endAngle:degreesToRadians(value) clockwise:YES];
    
    bezierPath2.lineWidth = self.lineWidth;
    bezierPath2.lineCapStyle = kCGLineCapRound;
    bezierPath2.lineJoinStyle = kCGLineCapRound;
    
    CAShapeLayer *circleLayer = [CAShapeLayer layer];
    [circleLayer setPath:bezierPath2.CGPath];
    
    [circleLayer setStrokeColor:self.progressColor.CGColor];
    [circleLayer setFillColor:[UIColor clearColor].CGColor];
    [circleLayer setLineWidth:self.lineWidth];
    [circleLayer setStrokeStart:0.0];
    [circleLayer setStrokeEnd:1.0];
    [circleLayer setLineCap:kCALineCapRound];
    [circleLayer setLineJoin:kCALineCapRound];
    
    [self.layer addSublayer:circleLayer];
    
    CABasicAnimation *animateStrokEnd = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    animateStrokEnd.duration = 1;
    animateStrokEnd.fromValue = [NSNumber numberWithFloat:0.0];
    animateStrokEnd.toValue = [NSNumber numberWithFloat:1.0];
    [circleLayer addAnimation:animateStrokEnd forKey:nil];
    
}



@end
