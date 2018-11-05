//
//  RoundProgressViewController.m
//  UIComponentSample
//
//  Created by ibank on 2018. 10. 17..
//  Copyright © 2018년 ibank. All rights reserved.
//

#import "RoundProgressViewController.h"
#import "RoundProgressView.h"

@interface RoundProgressViewController () <UIPickerViewDelegate, UIPickerViewDataSource>

@property (strong, nonatomic) IBOutlet RoundProgressView *roundProgress;
@property (strong, nonatomic) IBOutlet UITextField *textField;
@property (strong, nonatomic) IBOutlet UIPickerView *pickerView;

@property (strong, nonatomic) NSArray *colorTitle;
@property (strong, nonatomic) NSArray<UIColor *> *colorArray;

@end

@implementation RoundProgressViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    CGPoint point = self.roundProgress.center;
    float radius = 0;
    
    self.roundProgress.startDegree = -223;
    self.roundProgress.progressColor = [UIColor whiteColor];
    
    radius = self.view.frame.size.width/4 - self.roundProgress.lineWidth - self.roundProgress.spacing;
    point.x = self.view.frame.size.width/4 + self.roundProgress.lineWidth/2 - self.roundProgress.spacing/2;
    point.y = self.view.frame.size.width/4 + self.roundProgress.lineWidth - self.roundProgress.spacing/2;
    
    self.roundProgress.radius = radius;
    self.roundProgress.drawPoint = point;
    
    [self.roundProgress setProgress:0];
    
    
    self.colorTitle = [NSArray arrayWithObjects:@"white", @"black", @"red", @"green", @"blue", @"yellow", nil];
    self.colorArray = [NSArray arrayWithObjects:[UIColor whiteColor], [UIColor blackColor], [UIColor redColor], [UIColor greenColor], [UIColor blueColor], [UIColor yellowColor], nil];
}

#pragma mark - IBAction : Start Progress
- (IBAction)onclickStartButton:(UIButton *)sender {
    
    NSInteger value = self.textField.text.integerValue;
    [self.roundProgress setProgress:value];
}

#pragma mark - UIPickerView : selectProgressColor
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return self.colorArray.count;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return self.colorTitle[row];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    self.roundProgress.progressColor = self.colorArray[row];
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
