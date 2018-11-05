//
//  SwipePageViewItem.m
//  UIComponentSample
//
//  Created by 이원희ibk on 2018. 10. 24..
//  Copyright © 2018년 ibank. All rights reserved.
//

#import "SwipePageViewItem.h"

@implementation SwipePageViewItem

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
