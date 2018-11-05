//
//  UITextField+Extension.m
//  UIComponentSample
//
//  Created by ibank on 2018. 10. 19..
//  Copyright © 2018년 ibank. All rights reserved.
//

#import "UITextField+Extension.h"

@implementation UITextField (Extension)

#pragma mark UI(IBInspectable)
@dynamic localizingText;
- (void)setLocalizingText:(NSString *)localizingText {
    
    NSString *localizing;
    
    if(localizingText && ![localizingText isEqualToString:@""]) {
        localizing = [AppUtility textLocalizing:localizingText];
    }
    
    [self setPlaceholder:localizing];
}

@end
