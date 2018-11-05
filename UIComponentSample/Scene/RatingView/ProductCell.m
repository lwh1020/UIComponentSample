//
//  ProductCell.m
//  Innisfree_Global
//
//  Created by 박해진 on 2017. 2. 22..
//  Copyright © 2017년 Innisfree Co., Ltd. All rights reserved.
//

#import "ProductCell.h"

@implementation ProductCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self setupRatingView];
}

- (void)setupRatingView {
    NSMutableArray<UIImage *> *images = [NSMutableArray new];
    
    for(int i=1; i<10; i++) {
        NSString *imageName = [@"common_icn_leaf_on" stringByAppendingFormat:@"%d", i];
        [images addObject:[UIImage imageNamed:imageName]];
    }
    [images addObject:[UIImage imageNamed:@"common_icn_leaf_on"]];
    
    [self.ratingView setMarkImages:images];
    [self.ratingView setUnmarkImage:[UIImage imageNamed:@"common_icn_leaf_off"]];
    
    self.ratingView.margin = 0;
    self.ratingView.maxRating = 5;
    self.ratingView.rating = 0;
}

@end

@implementation ProductHeader

//- (void)layoutSubviews {
//    [super layoutSubviews];
//    [AppUtility textLocalizing:self];
//}

@end

@implementation ProductFooter

//- (void)layoutSubviews {
//    [super layoutSubviews];
//    [AppUtility textLocalizing:self];
//}

@end
