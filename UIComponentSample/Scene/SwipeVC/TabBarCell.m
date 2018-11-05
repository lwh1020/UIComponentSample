//
//  TabBarCell.m
//  UIComponentSample
//
//  Created by ibank on 2018. 10. 31..
//  Copyright © 2018년 ibank. All rights reserved.
//

#import "TabBarCell.h"

#define SELECTED_COLOR UIColorFromRGBA(0x0433FF, 0.52)

@implementation TabBarCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected {
    [super setSelected:selected];
    
    if(selected) {
        [self.tabLabel setTextColor:SELECTED_COLOR];
        [self.lineView setBackgroundColor:SELECTED_COLOR];
    } else {
        [self.tabLabel setTextColor:[UIColor blackColor]];
        [self.lineView setBackgroundColor:[UIColor whiteColor]];
    }
}

@end
