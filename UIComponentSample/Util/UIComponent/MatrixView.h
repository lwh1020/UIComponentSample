//
//  MatrixView.h
//  DWorks
//
//  Created by Ryan Kim on 2017. 3. 28..
//  Copyright © 2017년 Digitalworks. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MatrixViewDelegate,MatrixViewDataSource;

@interface MatrixView : UIView
@property(nonatomic,strong) UICollectionView * _Nonnull collectionView;
@property(nonatomic, weak, nullable) IBOutlet id<MatrixViewDataSource> dataSource;
@property(nonatomic, weak, nullable) IBOutlet id<MatrixViewDelegate> delegate;
@property(nonatomic) BOOL showScrollIndicator;
@property(nonatomic) CGSize cellSize;
@property(nonatomic, strong, readwrite, nonnull) NSArray *realPostion;

-(void) setItemViewSize:(CGSize)size withItemSpacing:(CGFloat)spacing;
-(void) changeView:(UIView * __nullable)view atIndex:(NSInteger)index;
-(void) drawLine:(NSInteger)max addX:(CGFloat)x addY:(CGFloat)y;
-(void) drawLine:(NSInteger)max addX:(CGFloat)x addY:(CGFloat)y lineColor:(UIColor*_Nonnull)color lineBorder:(CGFloat)border;
-(void) reloadData;
@end

@protocol MatrixViewDelegate <NSObject,UIScrollViewDelegate>

@optional
- (void)matrixViewCurrentPageIndexDidChange:(NSInteger) index;
- (void)matrixView:(MatrixView * __nonnull)matrixView didSelectItemAtIndexPath:(NSInteger)index;

@end

@protocol MatrixViewDataSource <NSObject>

@required
- (NSInteger)numberOfRowsInMatrixView:(MatrixView * __nonnull)matrixView;
- (NSInteger)numberOfColumnInMatrixView:(MatrixView * __nonnull)matrixView;
- (UIView * __nonnull)matrixView:(MatrixView * __nonnull)matrixView viewForItemAtIndex:(NSInteger)index reusingView:(UIView * __nullable)view;

@end
