//
//  SwipeViewController.m
//  DWorks
//
//  Created by Ryan Kim on 2017. 2. 17..
//  Copyright © 2017년 Digitalworks. All rights reserved.
//

#import "SwipeViewController.h"

@interface SwipeViewController ()<UIPageViewControllerDelegate,UIGestureRecognizerDelegate, UIPageViewControllerDataSource>

@property (strong, nonatomic) UIPageViewController *pageController;
@property (strong, nonatomic) NSArray *viewControllerItems;
@property (nonatomic) NSInteger numberOfViewControllers;
@property (nonatomic, strong) dispatch_queue_t serialQueue;
@property (nonatomic, strong) UIScrollView *scrollView;

@end

@implementation SwipeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.serialQueue = dispatch_queue_create("animaitionQueue", DISPATCH_QUEUE_SERIAL);
}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    // Disable iOS 7 back gesture
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
        self.navigationController.interactivePopGestureRecognizer.delegate = self;
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    // Enable iOS 7 back gesture
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = YES;
        self.navigationController.interactivePopGestureRecognizer.delegate = nil;
    }
}

- (UIScrollView *)scrollView {
    
    UIScrollView *scrollView ;
    for (UIView *v in self.pageController.view.subviews) {
        if([v isKindOfClass:UIScrollView.class]) {
            scrollView = (UIScrollView *)v;
            break;
        }
    }
    
    return scrollView;
}

#pragma mark - UIGestureRecognizerDelegate
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    return NO;
}
#pragma mark - UIPageViewControllerDelegate
- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController {
    
    NSUInteger index = [self.viewControllerItems indexOfObject:viewController];
    
    if ((index == 0) || (index == NSNotFound)) {
        index = self.numberOfViewControllers;
    }
    
    index--;
    
    UIViewController *vc = [self.viewControllerItems objectAtIndex:index];
    
    return vc;
    
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController {
    
    NSUInteger index = self.indexOfViewControllers;
    
    index++;
    
    if (index == self.numberOfViewControllers) {
        index = 0;
    }
    
    UIViewController *vc = [self.viewControllerItems objectAtIndex:index];
    
    return vc;
    
}

- (void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray<UIViewController *> *)previousViewControllers transitionCompleted:(BOOL)completed {
    
    self.indexOfViewControllers = [self indexOfCurrentViewController:[pageViewController.viewControllers firstObject]];
    
    if ([self.delegate conformsToProtocol:@protocol(SwipeViewControllerDelegate)] && [self.delegate respondsToSelector:@selector(swipeViewController:didPagingWithIndex:)]) {
        [self.delegate swipeViewController:self didPagingWithIndex:self.indexOfViewControllers];
    }
}

#pragma mark - Public Mehtod
- (BOOL)jumpToIndex:(NSInteger)index {
    return [self jumpToIndex:index withAnimation:YES];
}

//- (BOOL)jumpToIndex:(NSInteger)index withAnimation:(BOOL)anim {
//
//    if (self.scrollView == nil || self.isAnimating || self.scrollView.isDragging) {
//        return NO;
//    }
//
//    UIPageViewControllerNavigationDirection direction;
//
//    if (self.indexOfViewControllers > index) {
//        direction = UIPageViewControllerNavigationDirectionReverse;
//    } else if (self.indexOfViewControllers < index) {
//        direction = UIPageViewControllerNavigationDirectionForward;
//    } else {
//        return NO;
//    }
//    self.indexOfViewControllers = index;
//
//    UIViewController *controller = [self.viewControllerItems objectAtIndex:index];
//
//    __weak typeof (self) weakSelf = self;
//
//    dispatch_async(dispatch_get_main_queue(), ^{
//        [weakSelf.view setUserInteractionEnabled:NO];
//        [weakSelf.pageController setViewControllers:@[controller]
//                                      direction:direction
//                                       animated:YES
//                                     completion:^(BOOL finished) {
//                                         [weakSelf.view setUserInteractionEnabled:YES];
//                                     }];
//    });
//    return YES;
//}

- (BOOL)jumpToIndex:(NSInteger)index withAnimation:(BOOL)anim {

    if (self.scrollView == nil || self.isAnimating || self.scrollView.isDragging) {
        return NO;
    }

    dispatch_async(self.serialQueue, ^{
        [self serializedAnimation:index];
    });

    return YES;
}

- (void)setEnableSwipe:(BOOL)enable {
    for (UIScrollView *view in self.pageController.view.subviews) {
        
        if ([view isKindOfClass:[UIScrollView class]]) {
            
            view.scrollEnabled = enable;
        }
    }
}

- (NSInteger)indexOfCurrentViewController:(UIViewController *)controller {
    
    return [self.viewControllerItems indexOfObject:controller];
    
}

- (void)setViewControllers:(NSArray *)viewControllerItems {
    [self.view layoutIfNeeded];
    
    self.viewControllerItems = viewControllerItems;
    self.numberOfViewControllers = [self.viewControllerItems count];
    
    self.pageController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:nil];
    
    self.pageController.dataSource = self;
    self.pageController.delegate = self;
    
    CGFloat pageControllerOriginY = 0;
    
    id nav = [UIApplication sharedApplication].keyWindow.rootViewController;
    
    if ([nav isKindOfClass:[UINavigationController class]]) {
        UINavigationController *navc = (UINavigationController *) nav;
        if(!navc.navigationBarHidden) {
            pageControllerOriginY += self.navigationController.navigationBar.frame.size.height;
        }
    }
    
    CGRect pageControllerFrame = CGRectMake(0, pageControllerOriginY, self.view.bounds.size.width, self.view.bounds.size.height - pageControllerOriginY);
    
    [[self.pageController view] setFrame:pageControllerFrame];
    
    self.pageController.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    NSArray *initialViewControllers = [NSArray arrayWithObject:[self.viewControllerItems firstObject]];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.pageController setViewControllers:initialViewControllers direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
    });

    [self addChildViewController:self.pageController];
    [[self view] addSubview:[self.pageController view]];
    [self.pageController didMoveToParentViewController:self];
}

- (void)serializedAnimation:(NSInteger) index {
    
    UIPageViewControllerNavigationDirection direction;
    if (self.indexOfViewControllers > index) {
        
        direction = UIPageViewControllerNavigationDirectionReverse;
    } else if (self.indexOfViewControllers < index) {
        
        direction = UIPageViewControllerNavigationDirectionForward;
    } else {
        return;
    }
    
    self.indexOfViewControllers = index;
    UIViewController *controller = [self.viewControllerItems objectAtIndex:index];
    __weak typeof (self) weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{

        if (weakSelf.scrollView == nil) {
            return;
        }
        
        UIView *target = controller.view;
        
        CGFloat x = 0;
        if (direction == UIPageViewControllerNavigationDirectionForward) {
            x = weakSelf.pageController.view.frame.size.width * 2;
        }
        
        [target setFrame:CGRectMake(x,0,weakSelf.pageController.view.frame.size.width,weakSelf.pageController.view.frame.size.height)];
        [self.scrollView addSubview:target];
        
        self.isAnimating = YES;
        [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
            
            self.scrollView.contentOffset = CGPointMake(x,0);
        } completion:^(BOOL finished){
            
            weakSelf.isAnimating = NO;
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [target removeFromSuperview];
                [weakSelf.pageController setViewControllers:@[controller] direction:direction animated:NO completion:^(BOOL finished){}];
                if ([weakSelf.delegate conformsToProtocol:@protocol(SwipeViewControllerDelegate)] && [self.delegate respondsToSelector:@selector(swipeViewController:didChangedPageIndex:)]) {
                    [weakSelf.delegate swipeViewController:weakSelf didChangedPageIndex:weakSelf.indexOfViewControllers];
                }

            });
        }];
    });
}

@end
