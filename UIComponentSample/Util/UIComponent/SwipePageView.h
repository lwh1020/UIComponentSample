//
//  swipePageViewController.h
//  Swipe
//
//  Created by Ryan Kim on 2017. 1. 4..
//  Copyright © 2017년 Digitalworks. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef NS_ENUM (NSUInteger, SwipePageScrollDirection) {
    
    SwipePageScrollDirectionVertical = 0,
    SwipePageScrollDirectionHorizontal
};
typedef NS_ENUM (NSUInteger, SwipeDirection) {
    SwipeDirectionNone = -1,
    SwipeDirectionLeft = 0,
    SwipeDirectionRight
};

@protocol SwipePageViewDelegate,SwipePageViewDataSource;

@interface SwipePageView : UIView

@property(nonatomic, weak) IBOutlet id<SwipePageViewDataSource> dataSource;
@property(nonatomic, weak) IBOutlet id<SwipePageViewDelegate> delegate;

-(instancetype)initWithFrame:(CGRect)frame;

-(void)reloadData;
-(void)setPage:(int)index;
-(void)jumpPageAt:(int)index;

-(UIScrollView *)scrollView;

-(void)scrollDirection:(SwipePageScrollDirection)direction;

-(void)animateWithDuration:(NSTimeInterval)duration delay:(NSTimeInterval)delay direction:(SwipeDirection)direction completion:(void (^)(BOOL finished))completion;

- (void)showIndicatorWidthSize:(CGSize)size withDistance:(CGFloat)distance withOnImage:(UIImage *)onImage withOffImage:(UIImage *)offImage;

- (void)setIndicatorHidden:(BOOL)hidden;

- (NSInteger)currentIndex;

@end

@protocol SwipePageViewDelegate <NSObject,UIScrollViewDelegate>

@optional
- (void)swipePageViewCurrentPageIndexDidChange:(int) index;
- (void)swipePageViewDidScroll:(SwipePageView *)swipeView;
- (void)swipePageViewWillBeginDragging:(SwipePageView *)swipePageView;
- (void)swipePageViewDidEndDragging:(SwipePageView *)swipePageView willDecelerate:(BOOL)decelerate;
- (void)swipePageViewWillBeginDecelerating:(SwipePageView *)swipePageView;
- (void)swipePageViewDidEndDecelerating:(SwipePageView *)swipePageView;
- (void)swipePageViewDidEndScrollingAnimation:(SwipePageView *)swipePageView;
- (void)swipePageViewDrawFinish;

@end

@protocol SwipePageViewDataSource <NSObject>

@required
- (NSInteger)numberOfItemsInSwipePageView:(SwipePageView *)swipePageView;
- (UIView *)swipePageView:(SwipePageView *)swipePageView viewForItemAtIndex:(NSInteger)index reusingView:(UIView *)view;

@end
