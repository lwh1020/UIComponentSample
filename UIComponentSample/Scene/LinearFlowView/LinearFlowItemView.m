//
//  LinearFlowItemView.m
//  UIComponentSample
//
//  Created by ibank on 2018. 10. 18..
//  Copyright © 2018년 ibank. All rights reserved.
//

#import "LinearFlowItemView.h"

@implementation LinearFlowItemView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    if (self) {
        NSString *className = NSStringFromClass([self class]);
        self.view = [[[NSBundle mainBundle] loadNibNamed:className owner:self options:nil] firstObject];
        self.view.frame = frame;
        
        [self addSubview:self.view];
        
        return self;
    }
    return nil;
}

@end
