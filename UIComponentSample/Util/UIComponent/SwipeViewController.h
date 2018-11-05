//
//  SwipeViewController.h
//  DWorks
//
//  Created by Ryan Kim on 2017. 2. 17..
//  Copyright © 2017년 Digitalworks. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SwipeViewControllerDelegate;

@interface SwipeViewController : UIViewController

@property(nonatomic, weak) IBOutlet id<SwipeViewControllerDelegate> delegate;
@property  BOOL isAnimating;
@property (nonatomic) NSInteger indexOfViewControllers;

- (void)setViewControllers:(NSArray *)viewControllers;
- (BOOL)jumpToIndex:(NSInteger)index;
- (BOOL)jumpToIndex:(NSInteger)index withAnimation:(BOOL)anim;

- (NSInteger)indexOfCurrentViewController:(UIViewController *)controller;

// 스와이프 기능 온오프
- (void)setEnableSwipe:(BOOL)enable;
@end

@protocol SwipeViewControllerDelegate<NSObject>

@optional
- (void)swipeViewController:(SwipeViewController *)swipeViewController didPagingWithIndex:(NSInteger)pageIndex;
- (void)swipeViewController:(SwipeViewController *)swipeViewController didChangedPageIndex:(NSInteger)pageIndex;


@end
