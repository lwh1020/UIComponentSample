//
//  RatingView.h
//  Innisfree_Global
//
//  Created by 박해진 on 2017. 2. 22..
//  Copyright © 2017년 Innisfree Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RatingView : UIView

@property (nonatomic) CGFloat rating;     // 3
@property (nonatomic) CGFloat maxRating;  // 5

@property (nonatomic) NSArray<UIImage *> *markImages;
@property (nonatomic) UIImage *unmarkImage;    //


@property (nonatomic) CGFloat margin;

- (void)draw;

@end
