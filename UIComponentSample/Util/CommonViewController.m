//
//  CommonViewController.m
//  UIComponentSample
//
//  Created by ibank on 2018. 10. 17..
//  Copyright © 2018년 ibank. All rights reserved.
//

#import "CommonViewController.h"

@interface CommonViewController ()

@property (strong, nonatomic) UIScrollView *scrollView;
@end

@implementation CommonViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.navigationItem setTitle:NSStringFromClass([self class])];
    
    for (UIView *view in self.view.subviews) {
        if ([view isKindOfClass:UIScrollView.class]) {
            [self setScrollView:(UIScrollView *)view];
            
        } else if ([view isKindOfClass:UIWebView.class]) {
            [self setScrollView:((UIWebView *)view).scrollView];
            
        }
    }
    
    if (self.scrollView) {
        [self.scrollView setDelegate:self];
        [self.scrollView setBounces:NO];
        
        [self.scrollView.panGestureRecognizer addTarget:self action:@selector(scrollPanGesture:)];
    }
}

- (void)reloadData {
}

- (void)setPullToRefresh {
    
    [self.scrollView setBounces:YES];
    // pull to refresh
//    __weak CommonViewController *weakSelf = self;
    
    // weak -> strong
//    if (self.scrollView) {
//        [self.scrollView addPullToRefreshWithActionHandler:^{
//            [weakSelf reloadData];
//        }];
//    }
}

// Pull To Refresh Stop
//- (void)refreshEnd {
//    if (self.scrollView) {
//        [self.scrollView.pullToRefreshView stopAnimating];
//    }
//}

// 하위 CommonView를 상속받는 모든 뷰들을 reload
//- (void)reloadSubViews:(NSArray *)views {
//    for (UIView *view in views) {
//        if ([view isKindOfClass:[CommonView class]]) {
//            // recursive
//            [self reloadSubViews:views];
//
//            [((CommonView *)view) reloadData];
//        }
//    }
//}

- (void) setNavigationTitle:(NSString *)title{
    self.title = title;
//    [self.inniNavigationBar.labelTitle setText:title];
}

#pragma mark - Status Bar Frame Changed Selector
- (void)statusBarFrameWillChange:(NSNotification*)notification {
    NSValue* rectValue = [[notification userInfo] valueForKey:UIApplicationStatusBarFrameUserInfoKey];
    CGRect newFrame;
    [rectValue getValue:&newFrame];
}

- (void)statusBarFrameChanged:(NSNotification*)notification {
    NSValue* rectValue = [[notification userInfo] valueForKey:UIApplicationStatusBarFrameUserInfoKey];
    CGRect oldFrame;
    [rectValue getValue:&oldFrame];
}

#pragma mark UIScrollViewDelegate
- (void)scrollPanGesture:(UIPanGestureRecognizer *)recognizer {
    CGFloat velocityY = [recognizer velocityInView:_scrollView].y;
    if (velocityY < 0) {
//        [[AppInteraction sharedInstance] hideTabbar];
        
    } else if (velocityY > 0) {
//        [[AppInteraction sharedInstance] showTabbar];
        
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
