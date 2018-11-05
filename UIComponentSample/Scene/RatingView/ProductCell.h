//
//  ProductCell.h
//  Innisfree_Global
//
//  Created by 박해진 on 2017. 2. 22..
//  Copyright © 2017년 Innisfree Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RatingView.h"

@interface ProductCell : UICollectionViewCell

@property (strong, nonatomic) IBOutlet UIImageView *imageProduct;
@property (strong, nonatomic) IBOutlet UIImageView *imageBest;
@property (strong, nonatomic) IBOutlet UIImageView *imageNew;
@property (strong, nonatomic) IBOutlet UILabel *labelName;
@property (strong, nonatomic) IBOutlet UILabel *labelPrice;

@property (strong, nonatomic) IBOutlet RatingView *ratingView;
@property (strong, nonatomic) IBOutlet UILabel *labelCommentCount;

@end

@interface ProductHeader : UICollectionReusableView

@property (strong, nonatomic) IBOutlet UILabel *labelProductCount;


@end

@interface ProductFooter : UICollectionReusableView

@property (strong, nonatomic) IBOutlet UIView *viewLine;
@property (strong, nonatomic) IBOutlet UIView *viewButton;


@property (strong, nonatomic) IBOutlet UIButton *buttonMore;

@end
