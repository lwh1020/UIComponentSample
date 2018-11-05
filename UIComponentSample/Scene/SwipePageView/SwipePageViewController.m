//
//  SwipePageViewController.m
//  UIComponentSample
//
//  Created by ibank on 2018. 10. 17..
//  Copyright © 2018년 ibank. All rights reserved.
//

#import "SwipePageViewController.h"
#import "SwipePageView.h"
#import "SwipePageViewItem.h"

@interface SwipePageViewController () <SwipePageViewDelegate, SwipePageViewDataSource, ConnectionManagerDelegate>

@property (strong, nonatomic) ConnectionManager *connection;

@property (strong, nonatomic) IBOutlet SwipePageView *swipePageView;
@property (strong, nonatomic) IBOutlet UIPageControl *pageControl;
@property (strong, nonatomic) NSMutableArray *swipeItem;
@property (nonatomic) BOOL isAnimating;

@property (strong, nonatomic) NSArray *dataArray;
@end

@implementation SwipePageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.connection = [ConnectionManager new];
    [self.connection setDelegate:self];
    
    [self.swipePageView setDelegate:self];
    [self.swipePageView setDataSource:self];
    
    self.swipeItem = [[NSMutableArray alloc] initWithObjects:@"SG_D_1_L005", @"SG_D_2_L005", @"SG_D_3_L005", nil];
    [self.pageControl setNumberOfPages:self.swipeItem.count];
    [self.pageControl setCurrentPage:0];
//    [self.swipePageView reloadData];
    
    [self reloadData];
}

- (void)reloadData {
    [self.connection requestToServer:@"http://www.innisfree.com/sg/en/app/main.json" withParam:@{} requestCode:0];
}

- (void)didFinishedServerResponse:(NSURLResponse *)response json:(id)JSON requestCode:(NSInteger)reqCode {
    
    NSString *resultCode = JSON[@"result_code"];
    if(![resultCode isEqualToString:@"00"]) {
        return;
    }
    
    if(reqCode == 0) {
        
        self.dataArray = [[NSArray alloc] initWithArray:JSON[@"bannerMain"]];
    }
    [self.swipePageView reloadData];
}

- (NSInteger)numberOfItemsInSwipePageView:(SwipePageView *)swipePageView {
    return self.swipeItem.count;
}

- (UIView *)swipePageView:(SwipePageView *)swipePageView viewForItemAtIndex:(NSInteger)index reusingView:(UIView *)view {
    
    SwipePageViewItem *itemView;
    
    if(!view) {
        itemView = [[SwipePageViewItem alloc] initWithFrame:view.bounds];
        
    } else {
        itemView = (SwipePageViewItem *)view;
    }
    
    if (!self.dataArray) {
        return itemView;
    }
    
    NSString *imageUrlStr = [@"http://www.innisfree.com/sg/en/" stringByAppendingString:[self.dataArray[index] objectForKey:@"image"]];
    NSURL *imageUrl = [NSURL URLWithString:imageUrlStr];
    [[ImageDownloader new] downloadImageFromUrl:imageUrl completionBlock:^(UIImage *downloadedImage, NSString *urlString, NSError *error) {
        
        if(downloadedImage && !error) {
            [itemView.imageView setImage:downloadedImage];
        } else {
            [itemView.imageView setImage:[UIImage imageNamed:@"product_nodata"]];
        }
    }];
    
//    [itemView.imageView setImage:[UIImage imageNamed:self.swipeItem[index]]];
    [itemView.label setText:self.swipeItem[index]];
    
    return itemView;
}

- (void)swipePageViewDidEndDecelerating:(SwipePageView *)swipePageView {
    [self.pageControl setCurrentPage:[self calculateSwipeCurrentPageIndex:swipePageView.currentIndex]];
}

- (IBAction)onClickLeftButton:(UIButton *)sender {
    
    if(!self.isAnimating && self.swipeItem.count > 1) {
        
        self.isAnimating = YES;
        
        [self.swipePageView animateWithDuration:0.3 delay:0 direction:SwipeDirectionRight completion:^(BOOL finished) {
            [self.pageControl setCurrentPage:[self calculateSwipeCurrentPageIndex:self.pageControl.currentPage - 1]];
            self.isAnimating = NO;
        }];
    }
}

- (IBAction)onClickRightButton:(UIButton *)sender {
    
    if(!self.isAnimating && self.swipeItem.count > 1) {
        
        self.isAnimating = YES;
        
        [self.swipePageView animateWithDuration:0.3 delay:0 direction:SwipeDirectionLeft completion:^(BOOL finished) {
            [self.pageControl setCurrentPage:[self calculateSwipeCurrentPageIndex:self.pageControl.currentPage + 1]];
            self.isAnimating = NO;
        }];
        
    }
}

- (NSInteger)calculateSwipeCurrentPageIndex:(NSInteger)currentPage {
    
    NSInteger calculateCurrentPage = 0;
    if (currentPage >= self.swipeItem.count) {
        
        calculateCurrentPage = 0;
    } else if (currentPage < 0) {
        
        calculateCurrentPage = self.swipeItem.count;
    } else {
        calculateCurrentPage = currentPage;
        
    }
    
    return calculateCurrentPage;
}

@end
