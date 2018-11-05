//
//  SwipeViewController.m
//  Swipe
//
//  Created by Ryan Kim on 2017. 1. 4..
//  Copyright © 2017년 Digitalworks. All rights reserved.
//

#import "SwipePageView.h"
#import "IndicatorView.h"

@interface SwipePageView ()<UIScrollViewDelegate> {
    float prevOffsetX;
}

@property(nonatomic,strong) UIScrollView *mScrollView;
@property(nonatomic,strong) NSMutableDictionary *reuseingViews;
@property(nonatomic) NSInteger pageIndex;
@property(nonatomic) BOOL hasContentLeftSide;
@property(nonatomic,strong) IndicatorView *indicatorView;
@property(nonatomic,strong) NSLock *lock;
@end

@implementation SwipePageView

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if ((self = [super initWithCoder:aDecoder]))
    {

        [self initializeWithFrame:self.bounds];
    }
    return self;
}

-(instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    
    if(self) {
        
        
        [self initializeWithFrame:frame];

    }
    return self;
}
-(void)initializeWithFrame:(CGRect)frame {
    
    
    frame.origin.x = 0;
    frame.origin.y = 0;
    
    self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.mScrollView = [[UIScrollView alloc] initWithFrame:frame];
    self.mScrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.mScrollView.delegate = self;
    
    [self addSubview:self.mScrollView];
    
    [self scrollDirection:SwipePageScrollDirectionHorizontal];
    
    self.hasContentLeftSide = NO;
    
    [self.mScrollView setContentSize:CGSizeMake(self.mScrollView.frame.size.width*2, self.mScrollView.frame.size.height)];
    
    self.pageIndex = 0;
    
    self.reuseingViews = [[NSMutableDictionary alloc] init];
    
    self.lock = [[NSLock alloc] init];
    
    self.mScrollView.pagingEnabled = YES;
    
    self.mScrollView.showsHorizontalScrollIndicator = NO;
    
    if(self.dataSource) {
        
        [self reloadData];
    }
}
-(void)reloadData {

    [self layoutIfNeeded];

    [self.mScrollView setContentSize:CGSizeMake(self.mScrollView.frame.size.width*2, self.mScrollView.frame.size.height)];
    [self reloadScrollViewContents:SwipeDirectionRight];
}
-(void)scrollDirection:(SwipePageScrollDirection)direction {
    
    switch (direction) {
        case SwipePageScrollDirectionVertical:
            self.mScrollView.alwaysBounceHorizontal = NO;
            self.mScrollView.alwaysBounceVertical = YES;
            break;
            
        default:
            self.mScrollView.alwaysBounceHorizontal = YES;
            self.mScrollView.alwaysBounceVertical = NO;
            break;
    }
}
-(void)setPage:(int)index {
    
    self.pageIndex = index;
    
    [self reloadScrollViewContents:SwipeDirectionRight];
}
-(void)jumpPageAt:(int)index {

    if(index >= 0 && index < [self.dataSource numberOfItemsInSwipePageView:self]) {
        
        
        NSTimeInterval duration = 0.7;
        
        SwipeDirection direction = [self calculateDirection:index];
        
        if(direction == SwipeDirectionRight) {
            
            [self nextPageWithAnimation:duration delay:0 completion:^(BOOL finished) {
                
                [self jumpPageAt:index duration:duration direction:direction];
            }];
        }
        else if(direction == SwipeDirectionLeft) {
            
            [self prePageWithAnimation:duration delay:0 completion:^(BOOL finished) {
                
                [self jumpPageAt:index duration:duration direction:direction];
            }];
        }
        
    }
    else {
        NSString *reasson = [NSString stringWithFormat:@"Out of range page index"];
        
        @throw [NSException exceptionWithName:@"Incorrect input data"
                                       reason:reasson
                                     userInfo:nil];
    }
    
}

-(UIScrollView *)scrollView {
    return self.mScrollView;
}

- (NSInteger)currentIndex {
    
    return self.pageIndex;
}

- (void)showIndicatorWidthSize:(CGSize)size withDistance:(CGFloat)distance withOnImage:(UIImage *)onImage withOffImage:(UIImage *)offImage {
    CGRect indicatorFrame = self.bounds;
    
    indicatorFrame.size.height = 20.f;
    
    indicatorFrame.size.width = ([self.dataSource numberOfItemsInSwipePageView:self] * 11);
    
    float centerX = self.center.x;
    
    float indicatorX = centerX - (indicatorFrame.size.width / 2);
    
    indicatorFrame.origin.x = indicatorX;
    
    indicatorFrame.origin.y = self.bounds.size.height - (indicatorFrame.size.height + 10.f);
    
    
    
    [self.indicatorView setIndex:(int)self.pageIndex];
}
- (void)setIndicatorHidden:(BOOL)hidden {
    
    if(self.indicatorView) {
        
        [self.indicatorView setHidden:hidden];
    }
}
#pragma mark - UIScrollView Delegate
-(void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    float offsetX = [scrollView contentOffset].x;

    if(offsetX < 0) {
        
        if(self.hasContentLeftSide)
            [self decreasePageIndex];
        
        [self reloadScrollViewContents:SwipeDirectionLeft];
        [self decreasePageIndex];
        self.hasContentLeftSide = NO;
    }
    else if(offsetX > self.mScrollView.frame.size.width / 2 && offsetX > prevOffsetX && prevOffsetX > 0) {
        NSInteger pageCount = [self.dataSource numberOfItemsInSwipePageView:self];
        
        [self notifyToDelegate:(self.pageIndex + 1) % (int)pageCount];
        
        prevOffsetX = 0;
    }
    
    if([scrollView contentOffset].y > 0)
        [scrollView setContentOffset:CGPointMake([scrollView contentOffset].x, 0)];
    
    if([self.delegate respondsToSelector:@selector(swipePageViewDidScroll:)]) {
        
        [self.delegate swipePageViewDidScroll:self];
    }
    
    prevOffsetX = offsetX;
}
- (void)scrollViewWillBeginDragging:(__unused UIScrollView *)scrollView
{
    if([self.delegate respondsToSelector:@selector(swipePageViewWillBeginDragging:)]) {
        
        [self.delegate swipePageViewWillBeginDragging:self];
    }
    
}
- (void)scrollViewWillBeginDecelerating:(__unused UIScrollView *)scrollView
{
    if([self.delegate respondsToSelector:@selector(swipePageViewWillBeginDecelerating:)]) {
        
        [self.delegate swipePageViewWillBeginDecelerating:self];
    }
    
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    
    float offsetX = [scrollView contentOffset].x;

    if(offsetX != 0 || offsetX != self.mScrollView.frame.size.width) {
        
        if(offsetX >=  self.mScrollView.frame.size.width /2) {
            offsetX = self.mScrollView.frame.size.width;
        }
        else {
            offsetX = 0;
        }

        [self.mScrollView setContentOffset:CGPointMake(offsetX, 0)];
    }

    if(offsetX == 0 && self.hasContentLeftSide) {
        
        [self decreasePageIndex];
        self.hasContentLeftSide = NO;
    }
    else if(offsetX == self.mScrollView.frame.size.width && !self.hasContentLeftSide) {
        
        [self increasePageIndex];
        [self reloadScrollViewContents:SwipeDirectionRight];
    }
    
    if([self.delegate respondsToSelector:@selector(swipePageViewDidEndDecelerating:)]) {
        
        [self.delegate swipePageViewDidEndDecelerating:self];
    }
    
}
- (void)scrollViewDidEndDragging:(__unused UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    
    if([self.delegate respondsToSelector:@selector(swipePageViewDidEndDragging:willDecelerate:)]) {
        
        [self.delegate swipePageViewDidEndDragging:self willDecelerate:decelerate];
    }
}

#pragma SwipePageView Animation
-(void)nextPageWithAnimation:(NSTimeInterval)duration delay:(NSTimeInterval)delay completion: (void (^ __nullable)(BOOL finished))completion {
    
    
    [UIView animateWithDuration:duration delay:delay
                        options:UIViewAnimationOptionBeginFromCurrentState
                     animations:^{
                         
                         [self increasePageIndex];
                         [self.mScrollView setContentOffset:CGPointMake(self.mScrollView.frame.size.width*1, 0)];
                         
                     } completion:^(BOOL finished) {
                         
                         [self reloadScrollViewContents:SwipeDirectionRight];
                         if (completion) {
                             completion(finished);
                         }
                         
                     }];
}

-(void)prePageWithAnimation:(NSTimeInterval)duration delay:(NSTimeInterval)delay completion: (void (^ __nullable)(BOOL finished))completion{

    [self reloadScrollViewContents:SwipeDirectionLeft];
    
    [UIView animateWithDuration:duration delay:delay
                        options:UIViewAnimationOptionBeginFromCurrentState
                     animations:^{
                         
                         [self.mScrollView setContentOffset:CGPointMake(0, 0)];
                     } completion:^(BOOL finished) {
                         
                         [self decreasePageIndex];
                         if (completion) {
                             completion(finished);
                         }
                         
                     }];
}

-(void)animateWithDuration:(NSTimeInterval)duration delay:(NSTimeInterval)delay direction:(SwipeDirection)direction completion:(void (^ __nullable)(BOOL finished))completion {
    
    [self.lock lock];
    
    if(direction == SwipeDirectionLeft) {
        [self nextPageWithAnimation:duration delay:delay completion:completion];
    }
    else {
        [self prePageWithAnimation:duration delay:delay completion:completion];
    }
    
    [self.lock unlock];
}

- (void)notifyToDelegate:(int)index {
    
    if(self.indicatorView) {
        [self.indicatorView setIndex:index];
    }
    if([self.delegate respondsToSelector:@selector(swipePageViewCurrentPageIndexDidChange:)]) {
        
        [self.delegate swipePageViewCurrentPageIndexDidChange:index];
    }
}

-(void)increasePageIndex {
    
    NSInteger pageCount = [self.dataSource numberOfItemsInSwipePageView:self];
    
    if (pageCount == 0)
        return;
    
    self.pageIndex = (self.pageIndex + 1) % pageCount;
    
    [self notifyToDelegate:(int)self.pageIndex];
}
-(void)decreasePageIndex {
    self.pageIndex--;
    
    if(self.pageIndex < 0)
        self.pageIndex = [self.dataSource numberOfItemsInSwipePageView:self] - 1;
    
    [self notifyToDelegate:(int)self.pageIndex];
}
-(void)reloadScrollViewContents:(SwipeDirection)direction {
    
    BOOL isSingleItem = NO;
    
    if ([self.dataSource numberOfItemsInSwipePageView:self] == 0) {
        self.scrollView.scrollEnabled = NO;
        return;
    }
    else if([self.dataSource numberOfItemsInSwipePageView:self] == 1) {
        self.scrollView.scrollEnabled = NO;
        isSingleItem = YES;
    }
    else {
        self.scrollView.scrollEnabled = YES;
    }
    
    [self.mScrollView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    int firstViewPositionX = 0;
    int secondViewPositionX = 0;
    int directionIndex = 0;
    
    if(direction == SwipeDirectionLeft) {
        
        firstViewPositionX = self.mScrollView.frame.size.width * 1;
        directionIndex = -1;
        secondViewPositionX = self.mScrollView.frame.size.width * 0;
    }
    else {
        
        firstViewPositionX = self.mScrollView.frame.size.width * 0;
        directionIndex = 1;
        secondViewPositionX = self.mScrollView.frame.size.width * 1;
    }
    
    [self.mScrollView setContentOffset:CGPointMake(firstViewPositionX, 0)];
    
    CGRect currentViewRect = self.mScrollView.frame;
    
    currentViewRect.origin.x = firstViewPositionX;
    currentViewRect.origin.y = 0;
    
    UIView *reusingView = [self.reuseingViews objectForKey:[NSNumber numberWithInteger:self.pageIndex]];
    
    UIView *currentView = [self.dataSource swipePageView:self viewForItemAtIndex:self.pageIndex reusingView:reusingView];
    
    if(!currentView) {
        
        NSString *reasson = [NSString stringWithFormat:@"Swipe Page Content view is null at index %lu",(long)self.pageIndex];
        
        @throw [NSException exceptionWithName:@"View can't be null"
                                       reason:reasson
                                     userInfo:nil];
    }
    
    [self.reuseingViews setObject:currentView forKey:[NSNumber numberWithInteger:self.pageIndex]];
    
    [currentView setFrame:currentViewRect];
    [self.mScrollView addSubview:currentView];
    
    if(!isSingleItem) {
        NSInteger directionPageIndex = self.pageIndex + directionIndex;
        
        if(directionPageIndex < 0) {
            directionPageIndex = [self.dataSource numberOfItemsInSwipePageView:self] -1;
        }
        else if(directionPageIndex > [self.dataSource numberOfItemsInSwipePageView:self] -1) {
            directionPageIndex = 0;
        }
        
        reusingView = [self.reuseingViews objectForKey:[NSNumber numberWithInteger:directionPageIndex]];
        
        UIView *directionView = [self.dataSource swipePageView:self viewForItemAtIndex:directionPageIndex reusingView:reusingView];
        
        if(!directionView) {
            
            NSString *reasson = [NSString stringWithFormat:@"Swipe Page Content view is null at index %lu",(long)directionPageIndex];
            
            @throw [NSException exceptionWithName:@"View can't be null"
                                           reason:reasson
                                         userInfo:nil];
        }
        
        [self.reuseingViews setObject:directionView forKey:[NSNumber numberWithInteger:directionPageIndex]];
        
        
        CGRect directionViewRect = self.mScrollView.frame;
        
        directionViewRect.origin.x = secondViewPositionX;
        directionViewRect.origin.y = 0;
        
        [directionView setFrame:directionViewRect];
        
        [self.mScrollView addSubview:directionView];
    }
    
    if ([self.delegate respondsToSelector:@selector(swipePageViewDrawFinish)]) {
        
        [self.delegate swipePageViewDrawFinish];
    }
}

-(SwipeDirection)calculateDirection:(int)index {
    
    if(self.pageIndex > index) {
        
        int movePageIndex = (int)self.pageIndex - index;
        
        int moveIndex = [self calculateMovePageCount:index];
        
        
        if(moveIndex >= movePageIndex) {
            return SwipeDirectionLeft;
        }
        else {
            return SwipeDirectionRight;
        }
        
    }
    else if(self.pageIndex < index) {
        
        int movePageIndex = index - (int)self.pageIndex ;
        
        int moveIndex = [self calculateMovePageCount:index];
        
        if(moveIndex >= movePageIndex) {
            return SwipeDirectionRight;
        }
        else {
            return SwipeDirectionLeft;
        }
    }
    else {
        
        return SwipeDirectionNone;
    }
    
    return SwipeDirectionRight;
}
-(int)calculateMovePageCount:(int)index {
    
    
    int moveIndex = 0;
    int movePageIndex = 0;
    
    if(self.pageIndex > index) {
        
        movePageIndex = (int)self.pageIndex - index;
        
        int temp = (int)self.pageIndex;
        
        while(temp != index) {
            
            temp++;
            
            if(temp > (int)[self.dataSource numberOfItemsInSwipePageView:self] -1) {
                
                temp = 0;
            }
            moveIndex++;
        }
        
    }
    else if(self.pageIndex < index) {
        
        movePageIndex = index - (int)self.pageIndex ;
        
        int temp = (int)self.pageIndex;
        
        while(temp != index) {
            
            temp--;
            
            if(temp < 0 ) {
                
                temp = (int)[self.dataSource numberOfItemsInSwipePageView:self] -1;
            }
            moveIndex++;
        }
    }
    
    return moveIndex >= movePageIndex ? movePageIndex : moveIndex;
}
-(void)mScrollViewSizeArrange
{
    CGRect contentRect = CGRectZero;
    for (UIView *view in self.mScrollView.subviews) {
        contentRect = CGRectUnion(contentRect, view.frame);
    }
    self.mScrollView.contentSize = contentRect.size;
}
-(void)jumpPageAt:(int)index duration:(NSTimeInterval)duration direction:(SwipeDirection)direction {
    
    duration = duration - 0.1;
    
    if(duration < 0.2) {
        
        duration = 0.1;
    }
    if(index >= 0 && index < [self.dataSource numberOfItemsInSwipePageView:self] ) {
        
        if(index != self.pageIndex) {
            if(direction == SwipeDirectionRight) {
                
                [self nextPageWithAnimation:duration delay:0 completion:^(BOOL finished) {
                    
                    if(index != self.pageIndex) {
                        
                        [self jumpPageAt:index duration:duration direction:direction];
                        
                    }
                    
                }];
            }
            else if(direction == SwipeDirectionLeft) {
                
                [self prePageWithAnimation:duration delay:0 completion:^(BOOL finished) {
                    
                    [self jumpPageAt:index duration:duration direction:direction];
                    
                }];
            }
        }
    }
    else {
        NSString *reasson = [NSString stringWithFormat:@"Out of range page index"];
        
        @throw [NSException exceptionWithName:@"Incorrect input data"
                                       reason:reasson
                                     userInfo:nil];
    }
}
@end
