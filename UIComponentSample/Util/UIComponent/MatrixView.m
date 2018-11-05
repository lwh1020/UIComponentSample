//
//  MatrixView.m
//  DWorks
//
//  Created by Ryan Kim on 2017. 3. 28..
//  Copyright © 2017년 Digitalworks. All rights reserved.
//

#import "MatrixView.h"

#define kReuseingCellIdentity @"matrixViewCellIdentity"

@interface MatrixView()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@property(nonatomic,strong) NSMutableDictionary *reuseingViews;
@property(nonatomic) NSInteger columnCount;
@property(nonatomic) NSInteger rowCount;

@end

@implementation MatrixView

#pragma mark - init method
- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame ];
    
    if(self) {
        [self initialize];
    }
    return self;
}
- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    
    
    self = [super initWithCoder:aDecoder];
    
    if(self) {
        [self initialize];
    }
    return self;
}

#pragma mark - private method
-(void)initialize {

    _reuseingViews = [[NSMutableDictionary alloc] init];
}

-(void) setItemViewSize:(CGSize)size withItemSpacing:(CGFloat)spacing {
    
    CGRect rect = self.bounds;
    
    UICollectionViewFlowLayout *layout = [UICollectionViewFlowLayout new];

    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    layout.minimumLineSpacing = spacing;
    layout.itemSize = size;

    _cellSize = size;
    
    if(_collectionView != nil) {
        
        [self.collectionView removeFromSuperview];
        _collectionView = nil;
        [self setNeedsDisplay];
    }
    
    
    _collectionView = [[UICollectionView alloc] initWithFrame:rect collectionViewLayout:layout];
    
    self.collectionView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.collectionView.backgroundColor = [UIColor clearColor];
    self.collectionView.alwaysBounceHorizontal = NO;
    self.collectionView.alwaysBounceVertical = NO;
    _showScrollIndicator = NO;
    self.collectionView.showsHorizontalScrollIndicator = self.showScrollIndicator;
    
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    
    self.collectionView.decelerationRate = UIScrollViewDecelerationRateFast;
    
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:kReuseingCellIdentity];
    
    [self addSubview:self.collectionView];
    
    
}
-(void) reloadData {
    [self.collectionView reloadData];
}
-(void)changeView:(UIView *)view atIndex:(NSInteger)index {
    
    NSNumber *realPosIndex = [self.realPostion objectAtIndex:index];
    
    int pos = (int)[realPosIndex integerValue];
    
    int column = fmodf(pos, self.columnCount);
    
    int row = pos / self.columnCount;

    UICollectionViewCell *cell = [self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:column inSection:row]];
    
    [cell addSubview:view];
}
-(void) drawLine:(NSInteger)max addX:(CGFloat)x addY:(CGFloat)y {
    
    [self drawLine:max addX:x addY:y lineColor:[UIColor blackColor] lineBorder:5];
}
-(void) drawLine:(NSInteger)max addX:(CGFloat)x addY:(CGFloat)y lineColor:(UIColor*)color lineBorder:(CGFloat)border {
    CGPoint startPoint = CGPointZero;;
    
    for(NSInteger i=0;i< max;i++) {
        
        NSNumber *realPosIndex = [self.realPostion objectAtIndex:i];
        
        int pos = (int)[realPosIndex integerValue];
        
        int column = fmodf(pos, self.columnCount);
        
        if (self.columnCount == 0) {
            return;
        }
        
        int row = pos / self.columnCount;
        
        UICollectionViewCell *cell = [self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:column inSection:row]];

        if(CGPointEqualToPoint(startPoint,CGPointZero)) {

            startPoint = [self.superview convertRect:cell.frame toView:nil].origin;
            
            startPoint.x = cell.center.x + x;
//            startPoint.y += y;
            startPoint.y = cell.center.y;
            
        }
        else {
            CGPoint endPoint = [self.superview convertRect:cell.frame toView:nil].origin;
            endPoint.x = cell.center.x + x;
//            endPoint.y += y;
            endPoint.y = cell.center.y;
            
            UIBezierPath *path = [UIBezierPath bezierPath];
            
            path.lineWidth = border;
            path.lineCapStyle = kCGLineCapRound;
            path.lineJoinStyle = kCGLineCapRound;
            [path moveToPoint:startPoint];
            [path addLineToPoint:endPoint];
            
            CAShapeLayer *circleLayer = [CAShapeLayer layer];
            [circleLayer setPath:path.CGPath];
            [circleLayer setLineWidth:border];
            [circleLayer setStrokeColor:color.CGColor];
            [circleLayer setLineCap:kCALineCapRound];
            [circleLayer setLineJoin:kCALineCapRound];
            
            circleLayer.zPosition = -1;
            
            [self.collectionView.layer addSublayer:circleLayer];
            
            startPoint = endPoint;
        }
        
        //[self.collectionView bringSubviewToFront:self.collectionView];
    }
}
#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    _rowCount = [self.dataSource numberOfRowsInMatrixView:self];
    return self.rowCount;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    _columnCount = [self.dataSource numberOfColumnInMatrixView:self];
    return self.columnCount;
}
- (UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    UICollectionViewCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:kReuseingCellIdentity forIndexPath:indexPath];
    
    NSString *key = [NSString stringWithFormat:@"ROW%luCOL%lu", (long)indexPath.section,(long)indexPath.row];
    
    UIView *reusingView = [self.reuseingViews objectForKey:key];

    NSInteger temp = indexPath.section * self.columnCount + indexPath.row;
    
    NSInteger pos = [self.realPostion indexOfObject:[NSNumber numberWithInteger:temp]];
    
    UIView * view = [self.dataSource matrixView:self viewForItemAtIndex:pos reusingView:reusingView];
    
    [self.reuseingViews setObject:view forKey:key];
    
    for(UIView *subView in cell.subviews)
        [subView removeFromSuperview];
    
    [cell addSubview:view];
    
    return cell;
}
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    CGFloat w = collectionView.frame.size.width;
    
    CGFloat iw = self.cellSize.width * self.columnCount;
    
    CGFloat t = (w -iw)/(self.columnCount+1);
    
    return UIEdgeInsetsMake(10, t, 10, t);
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    
    return 10;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    
    return 10;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if(self.delegate && [self.delegate respondsToSelector:@selector(matrixView:didSelectItemAtIndexPath:)]) {
        
        NSInteger temp = indexPath.section * self.columnCount + indexPath.row;
        NSInteger pos = [self.realPostion indexOfObject:[NSNumber numberWithInteger:temp]];

        [self.delegate matrixView:self didSelectItemAtIndexPath:pos];
    }
}
@end
