//
//  TabBarView.h
//  UIComponentSample
//
//  Created by ibank on 2018. 10. 31..
//  Copyright © 2018년 ibank. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TabBarViewDelegate <NSObject>

- (void)jumpSwipePage:(NSInteger)pageIndex;
@end

@interface TabBarView : UIView

@property (strong, nonatomic) UIView *view;
@property (strong, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak) id<TabBarViewDelegate> delegate;

- (void)setDataFromArray:(NSArray *)dataArray;
- (void)reloadData;
- (void)buttonStateChanged:(NSInteger)index;
@end

