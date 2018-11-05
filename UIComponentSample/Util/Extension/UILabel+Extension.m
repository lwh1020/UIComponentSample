//
//  UILabel+Extension.m
//  UIComponentSample
//
//  Created by ibank on 2018. 10. 19..
//  Copyright © 2018년 ibank. All rights reserved.
//

#import "UILabel+Extension.h"

@implementation UILabel (Extension)

#pragma mark UI(IBInspectable)
@dynamic localizingText;
- (void)setLocalizingText:(NSString *)localizingText {

    NSString *localizing;
    
    if(localizingText && ![localizingText isEqualToString:@""]) {
        localizing = [AppUtility textLocalizing:localizingText];
    }
    
    NSAttributedString *attrText = [self attributedText];
    
    if(attrText) {
        NSMutableAttributedString *makeAttr = [[NSMutableAttributedString alloc] initWithAttributedString:attrText];
        
        [makeAttr.mutableString setString:localizing];
        [self setAttributedText:makeAttr];
        
    } else {
        [self setText:localizing];
    }
}

@end
