//
//  CommonViewController.h
//  UIComponentSample
//
//  Created by ibank on 2018. 10. 17..
//  Copyright © 2018년 ibank. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CommonViewController : UIViewController <UIScrollViewDelegate>

@property (nonatomic) NSArray<NSString *> *attributes;
@property (nonatomic) NSDictionary *properties;
@property (nonatomic) UIViewController *rootViewController;
@property (nonatomic) BOOL finishDrawView;

- (void)reloadData;
- (void)setPullToRefresh;
- (void)refreshEnd;
- (void)reloadSubViews:(NSArray *)views;
- (void)setNavigationTitle:(NSString *)title;

@end

NS_ASSUME_NONNULL_END
