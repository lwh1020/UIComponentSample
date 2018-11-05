//
//  LinearFlowItemView.h
//  UIComponentSample
//
//  Created by ibank on 2018. 10. 18..
//  Copyright © 2018년 ibank. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface LinearFlowItemView : UIView
@property (strong, nonatomic) UIView *view;

@property (strong, nonatomic) IBOutlet UIImageView *imageView;
@property (strong, nonatomic) IBOutlet UILabel *label;

@end

NS_ASSUME_NONNULL_END
