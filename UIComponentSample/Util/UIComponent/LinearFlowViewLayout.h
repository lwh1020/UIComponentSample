//
//  UICollectionViewFlowLayoutCenterItem.h
//  Example
//
//  Created by Ryan Kim on 2017. 2. 27..
//  Copyright © 2017년 Digitalworks. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LinearFlowViewLayout : UICollectionViewFlowLayout

@property (assign, nonatomic) CGFloat scalingOffset;
@property (assign, nonatomic) CGFloat minimumScaleFactor;
@property (assign, nonatomic) BOOL scaleItems;


+ (LinearFlowViewLayout *)layoutConfiguredWithCollectionView:(UICollectionView *)collectionView
                                                                    itemSize:(CGSize)itemSize
                                                          minimumLineSpacing:(CGFloat)minimumLineSpacing;
@end
