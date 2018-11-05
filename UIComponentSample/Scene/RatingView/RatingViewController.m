//
//  RatingViewController.m
//  UIComponentSample
//
//  Created by ibank on 2018. 10. 17..
//  Copyright © 2018년 ibank. All rights reserved.
//

#import "RatingViewController.h"
#import "RatingView.h"

@interface RatingViewController ()

@property (strong, nonatomic) IBOutlet RatingView *ratingView;
@property (strong, nonatomic) IBOutlet UISlider *slider;

@end

@implementation RatingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.slider setMaximumValue:self.ratingView.maxRating];
    [self.slider setMinimumValue:0];
    [self.slider setValue:0];
    
    [self.ratingView draw];
}

- (IBAction)sliderValueChanged:(UISlider *)sender {
    [self.ratingView setRating:sender.value];
    [self.ratingView draw];
}

@end
