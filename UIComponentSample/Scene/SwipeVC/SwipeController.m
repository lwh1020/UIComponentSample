//
//  SwipeController.m
//  UIComponentSample
//
//  Created by ibank on 2018. 10. 18..
//  Copyright © 2018년 ibank. All rights reserved.
//

#import "SwipeController.h"
#import "TabBarView.h"

@interface SwipeController () <TabBarViewDelegate>

@property (strong, nonatomic) NSMutableArray<UIViewController *> *viewControllers;
@property (strong, nonatomic) UIViewController *contentViewController;
@property (nonatomic) NSArray *attributes;

@property (strong, nonatomic) IBOutlet TabBarView *tabBarView;

@end

@implementation SwipeController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.swipeContent = [SwipeViewController new];
    [self.swipeContent setDelegate:self];
    
    self.viewControllers = [NSMutableArray new];
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"SwipeVCItem" ofType:@"plist"];
    NSArray *menuArray = [[NSArray alloc] initWithContentsOfFile:path];
    
    for(NSDictionary *tabData in menuArray) {
        UIViewController *content = (UIViewController *)[self.storyboard instantiateViewControllerWithIdentifier:tabData[@"action"]];
        
        [self.viewControllers addObject:content];
    }
    [self.swipeContent setViewControllers:self.viewControllers];
    [self setContentViewController:self.swipeContent];
    
    [self.swipeContent jumpToIndex:0 withAnimation:NO];
    
    [self.tabBarView setDelegate:self];
    [self.tabBarView setDataFromArray:menuArray];
    [self.tabBarView reloadData];
}

- (void)setContentViewController:(UIViewController * _Nonnull)contentViewController {

    if(_contentViewController) {
        [_contentViewController removeFromParentViewController];
        [_contentViewController.view removeFromSuperview];
    }
//    CGRect contentRect = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    CGRect contentRect = contentViewController.view.frame;
    UIView *contentArea;

    for (UIView *view in self.view.subviews) {

        if([[view restorationIdentifier] isEqualToString:@"swipeView"]) {
            contentArea = view;
        }
    }
    
    [self addChildViewController:contentViewController];
    [contentViewController didMoveToParentViewController:self];

    if(!contentArea) {
        contentViewController.view.frame = contentRect;
        [self.view insertSubview:contentViewController.view atIndex:0];
    } else {
        contentViewController.view.frame = contentArea.bounds;
        
        CGRect frame = contentViewController.view.frame;
        frame.size.height -= STATUS_HEIGHT;
        [contentViewController.view setFrame:frame];

        [contentArea addSubview:contentViewController.view];
    }

    _contentViewController = contentViewController;
}

-(void)swipeViewController:(SwipeViewController *)swipeViewController didPagingWithIndex:(NSInteger)pageIndex {
    
    [self.tabBarView buttonStateChanged:pageIndex];
}

- (void)swipeViewController:(SwipeViewController *)swipeViewController didChangedPageIndex:(NSInteger)pageIndex {
}

- (void)jumpSwipePage:(NSInteger)pageIndex {
    [self.swipeContent jumpToIndex:pageIndex];
    [self.tabBarView buttonStateChanged:pageIndex];
}

@end
