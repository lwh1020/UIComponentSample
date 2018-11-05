//
//  UIButton+Extension.m
//  UIComponentSample
//
//  Created by ibank on 2018. 10. 19..
//  Copyright © 2018년 ibank. All rights reserved.
//

#import "UIButton+Extension.h"

@implementation UIButton (Extension)

#pragma mark UI(IBInspectable)
@dynamic localizingText;
- (void)setLocalizingText:(NSString *)localizingText {
    
    NSString *localizing;
    
    if(localizingText && ![localizingText isEqualToString:@""]) {
        localizing = [AppUtility textLocalizing:localizingText];
    }
    
    NSAttributedString *attrText = [self.titleLabel attributedText];
    
    if(attrText) {
        NSMutableAttributedString *makeAttr = [[NSMutableAttributedString alloc] initWithAttributedString:attrText];
        
        [makeAttr.mutableString setString:localizing];
        
        [self setAttributedTitle:makeAttr forState:UIControlStateNormal];
        [self setAttributedTitle:makeAttr forState:UIControlStateSelected];
        
    } else {
        [self setTitle:localizing forState:UIControlStateNormal];
        [self setTitle:localizing forState:UIControlStateSelected];
    }
}

@end
