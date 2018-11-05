//
//  AppUtility.h
//  UIComponentSample
//
//  Created by ibank on 2018. 10. 19..
//  Copyright © 2018년 ibank. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AppUtility : NSObject

+ (NSString *)textLocalizing:(NSString *)text;

+ (UIViewController *)getRootTopMostViewController;

@end
