//
//  SwipeController.h
//  UIComponentSample
//
//  Created by ibank on 2018. 10. 18..
//  Copyright © 2018년 ibank. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SwipeViewController.h"

@interface SwipeController : UIViewController <SwipeViewControllerDelegate>

@property (strong, nonatomic) SwipeViewController *swipeContent;

@end
