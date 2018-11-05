//
//  LaunchScreenViewController.m
//  UIComponentSample
//
//  Created by ibank on 2018. 10. 31..
//  Copyright © 2018년 ibank. All rights reserved.
//

#import "LaunchScreenViewController.h"
#import "AppDelegate.h"


#define DEFAULT_IMAGE_INTRO @[ \
                            @"bg_splash_a", \
                            @"bg_splash_b", \
                            @"bg_splash_c" \
                            ]

@interface LaunchScreenViewController ()

@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet UIImageView *imageView;
@property (strong, nonatomic) NSTimer *loadingTimer;

@end

@implementation LaunchScreenViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self splashLaunchImage];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self imageScroll];
}

- (void)splashLaunchImage {
    
    NSArray *introImages = DEFAULT_IMAGE_INTRO;
    UIImage *image = nil;
    
    if (introImages && introImages.count != 0 && [introImages isKindOfClass:NSArray.class]) {
        
        int randomNumber = arc4random() % introImages.count;
        image = [UIImage imageNamed:DEFAULT_IMAGE_INTRO[randomNumber]];
        [self.imageView setImage:image];
    }
    
    self.loadingTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(finishLoading) userInfo:nil repeats:NO];
}

- (void)imageScroll {
    
    float endOffset = self.scrollView.contentSize.width - self.view.frame.size.width;
    
    __weak typeof (self) weakSelf = self;
    
    [UIView animateWithDuration:6.0f delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
        [weakSelf.scrollView setContentOffset:CGPointMake(endOffset, 0)];
    } completion:^(BOOL finished) {
        
        [UIView animateWithDuration:6.0f delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
            [weakSelf.scrollView setContentOffset:CGPointMake(0, 0)];
        } completion:^(BOOL finished) {
            [weakSelf imageScroll];
        }];
    }];
}

- (void)finishLoading {
    
    if(self.loadingTimer) {
        [self.loadingTimer invalidate];
        self.loadingTimer = nil;
    }
    
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    NetworkStatus status = appDelegate.networkReach.currentReachabilityStatus;

    if (status == NotReachable) {

        self.loadingTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(finishLoading) userInfo:nil repeats:NO];
    } else {
        [self goToNextViewController];
    }
    
}

- (void)goToNextViewController {
    
    UINavigationController *navigation = [self.storyboard instantiateViewControllerWithIdentifier:@"contentController"];
    
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    __weak typeof (appDelegate) weakAppDelegate = appDelegate;
    
    [UIView transitionWithView:appDelegate.window duration:0.5f options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
        
        weakAppDelegate.window.rootViewController = navigation;
        [weakAppDelegate.window makeKeyAndVisible];
        
    } completion:^(BOOL finished) {
        
    }];
}

- (IBAction)onClickScreen:(UIButton *)sender {
    [self finishLoading];
}

@end
