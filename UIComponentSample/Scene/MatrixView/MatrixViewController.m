//
//  MatrixViewController.m
//  UIComponentSample
//
//  Created by ibank on 2018. 10. 17..
//  Copyright © 2018년 ibank. All rights reserved.
//

#import "MatrixViewController.h"
#import "MatrixView.h"

#define IMAGE_CHECKIN_SEL   @"stmap_event_checkin_sel"
#define IMAGE_CHECKIN_N     @"stmap_event_checkin_n"
#define IMAGE_COUPON_SEL    @"stmap_event_coupon_sel"
#define IMAGE_COUPON_N      @"stmap_event_coupon_n"

#define DATA_COUNT      9
#define COLUMN_COUNT    3
#define STAMP_SIZE      CGSizeMake(90, 90)
#define MARGIN_SE       -28
#define BOTTOM_MARGIN   30

@interface MatrixViewController () <MatrixViewDelegate, MatrixViewDataSource>

@property (strong, nonatomic) IBOutlet MatrixView *matrixView;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *constMatrixHeight;

@property (strong, nonatomic) NSMutableArray *numbers;
@property (nonatomic) NSInteger currentIndex;
@end

@implementation MatrixViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.matrixView setDelegate:self];
    [self.matrixView setDataSource:self];
    
    [self setMatrixData];
    self.currentIndex = 0;
}

- (void)setMatrixData {
    
    self.numbers = [NSMutableArray new];
    
    for (int i=0; i<DATA_COUNT; i+=3) {
        
        int value = i/3;
        int mod = fmodf(value,2);
        
        if(mod == 0) {
            [self.numbers addObject:[NSNumber numberWithInt:i]];
            [self.numbers addObject:[NSNumber numberWithInt:i+1]];
            [self.numbers addObject:[NSNumber numberWithInt:i+2]];
        }
        else {
            [self.numbers addObject:[NSNumber numberWithInt:i+2]];
            [self.numbers addObject:[NSNumber numberWithInt:i+1]];
            [self.numbers addObject:[NSNumber numberWithInt:i]];
        }
    }
    
//    for (int i=0; i<DATA_COUNT; i++) {
//        [self.numbers addObject:[NSNumber numberWithInt:i]];
//    }
    
    while (self.numbers.count > DATA_COUNT) {
        [self.numbers removeLastObject];
    }
    
    self.matrixView.realPostion = [self.numbers copy];
    [self.matrixView setItemViewSize:STAMP_SIZE withItemSpacing:0];
    [self.matrixView reloadData];
    
    __weak typeof (self) weakSelf = self;
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 1 *  NSEC_PER_SEC/16), dispatch_get_main_queue(), ^{
        [weakSelf.matrixView drawLine:DATA_COUNT
                                 addX:0
                                 addY:MARGIN_SE
                            lineColor:[UIColor colorWithRed:0.96 green:0.96 blue:0.96 alpha:1.0]
                           lineBorder:6];
    });
    
    [self.constMatrixHeight setConstant:ceil(DATA_COUNT / (float)COLUMN_COUNT) * (STAMP_SIZE.height + 20) + BOTTOM_MARGIN];
}

- (UIView *)createView {
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectZero];
    CGRect viewFrame = view.frame;
    viewFrame.size = STAMP_SIZE;
    
    [view setFrame:viewFrame];
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:viewFrame];
    [imageView setTag:1];
    [view addSubview:imageView];
    
    return view;
}

#pragma mark - MatrixView Delegate
- (NSInteger)numberOfRowsInMatrixView:(MatrixView *)matrixView {
    return DATA_COUNT / COLUMN_COUNT;
}

- (NSInteger)numberOfColumnInMatrixView:(MatrixView *)matrixView {
    return COLUMN_COUNT;
}

- (UIView *)matrixView:(MatrixView *)matrixView viewForItemAtIndex:(NSInteger)index reusingView:(UIView *)view {
    
    if (!view) {
        view = [self createView];
    }
    
    UIImageView *imageView = [view viewWithTag:1];
    
    if(index % 2 == 0) {
        [imageView setImage:[UIImage imageNamed:IMAGE_CHECKIN_N]];
    } else {
        [imageView setImage:[UIImage imageNamed:IMAGE_COUPON_N]];
    }
    
    return view;
}

/*
-(void)matrixView:(MatrixView *)matrixView didSelectItemAtIndexPath:(NSInteger)index {
    
    NSLog(@"matrixview didselect %ld idx", (long)index);
    
    UIView *view = [self createView];
    UIImageView *imageView = [view viewWithTag:1];
    
    if(index % 2 == 0) {
        [imageView setImage:[UIImage imageNamed:IMAGE_CHECKIN_SEL]];
    } else {
        [imageView setImage:[UIImage imageNamed:IMAGE_COUPON_SEL]];
    }
    
    [matrixView changeView:view atIndex:index];
}
*/

- (IBAction)onClickButton:(UIButton *)sender {
    
    UIView *view = [self createView];
    UIImageView *imageView = [view viewWithTag:1];
    
    if(self.currentIndex >= self.numbers.count) {
        return;
    }
    
    if (self.currentIndex % 2 == 0) {
        [imageView setImage:[UIImage imageNamed:IMAGE_CHECKIN_SEL]];
    } else {
        [imageView setImage:[UIImage imageNamed:IMAGE_COUPON_SEL]];
    }
    
    [self.matrixView changeView:view atIndex:self.currentIndex];
    
    self.currentIndex++;
}

@end
