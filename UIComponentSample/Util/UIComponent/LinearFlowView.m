//
//  LinearFlowView.m
//  Example
//
//  Created by Ryan Kim on 2017. 2. 27..
//  Copyright © 2017년 Digitalworks. All rights reserved.
//

#import "LinearFlowView.h"
#import "LinearFlowViewLayout.h"

#define kReuseingCellIdentity @"LinearFlowViewCellIdentity"

@interface LinearFlowView()<UICollectionViewDelegate,UICollectionViewDataSource>

@property(nonatomic,strong) UICollectionView *collectionView;

@property(nonatomic,strong) LinearFlowViewLayout *layout;

@property (nonatomic, strong) UIDynamicAnimator *animator;

@property (nonatomic, readwrite) CGRect button1Bounds;


@property(readonly, nonatomic) CGFloat itemWidth;
@property(readonly, nonatomic) CGFloat contentOffset;

@property(nonatomic) CGPoint startDragPoint;


@property(nonatomic) BOOL interactionEnabled;
@property(nonatomic) BOOL isSelect;

@end

@implementation LinearFlowView

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */
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
    self.reuseingViews = [[NSMutableDictionary alloc] init];
    self.interactionEnabled = YES;
}

- (CGFloat)itemWidth {
    return self.layout.itemSize.width + self.layout.minimumLineSpacing;
}

- (CGFloat)contentOffset {
    return self.collectionView.contentOffset.x + self.collectionView.contentInset.left;
}

- (NSInteger)currentIndex {
    
    return self.isInfinity ? [self calculateInfinityIndex:self.pageIndex] : self.pageIndex;
}

- (void)scrollToPage:(NSUInteger)page animated:(BOOL)animated {

    self.collectionView.userInteractionEnabled = NO;
    // 7+에서 처음에 contentInset.left의 값이 셋팅이 안되는걸 못잡아서.. 계산
    CGFloat pageOffset = page * self.itemWidth - (([[UIScreen mainScreen] bounds].size.width) -self.layout.itemSize.width)/2;
    NSTimeInterval duration = 0.3f;
    
    __weak typeof(self) weakSelf = self;
    if(animated) {
        
        [UIView animateWithDuration:duration animations:^{
            weakSelf.collectionView.contentOffset = CGPointMake(pageOffset, 0);
        } completion:^(BOOL finished) {
            weakSelf.interactionEnabled = YES;
            
            weakSelf.pageIndex = page;
            
            weakSelf.collectionView.userInteractionEnabled = YES;
            
            if([weakSelf.delegate respondsToSelector:@selector(linearFlowViewCurrentPageIndexWillChange:)]) {
                [weakSelf.delegate linearFlowViewCurrentPageIndexWillChange:[weakSelf calculateInfinityIndex:weakSelf.pageIndex]];
            }
        }];
    }
    else {
        [UIView animateWithDuration:0 animations:^{
            weakSelf.collectionView.contentOffset = CGPointMake(pageOffset, 0);
        } completion:^(BOOL finished) {
            if([self.delegate respondsToSelector:@selector(linearFlowViewCurrentPageIndexWillChange:)]) {
                [weakSelf.delegate linearFlowViewCurrentPageIndexWillChange:[weakSelf calculateInfinityIndex:weakSelf.pageIndex]];
            }
        }];

        self.interactionEnabled = YES;
        
        self.pageIndex = page;
        
        self.collectionView.userInteractionEnabled = YES;
        
    }
}

- (void)selectScrollToPage:(NSUInteger)page animated:(BOOL)animated {
    
    self.collectionView.userInteractionEnabled = NO;
    
    // 7+에서 처음에 contentInset.left의 값이 셋팅이 안되는걸 못잡아서.. 계산
    CGFloat pageOffset = page * self.itemWidth - (([[UIScreen mainScreen] bounds].size.width) -self.layout.itemSize.width)/2;
    NSTimeInterval duration = 0.3f;
    
    if(animated) {
        __weak typeof(self) weakSelf = self;
        
        [UIView animateWithDuration:duration animations:^{
            weakSelf.collectionView.contentOffset = CGPointMake(pageOffset, 0);
        } completion:^(BOOL finished) {
            weakSelf.interactionEnabled = YES;
            weakSelf.collectionView.userInteractionEnabled = YES;
            weakSelf.isSelect = NO;
            
            weakSelf.pageIndex = page;
            
            if (weakSelf.pageIndex < 2) {
                [weakSelf scrollToPage:weakSelf.itemCount +1 animated:NO];
                
            } else if(weakSelf.pageIndex > weakSelf.itemCount + 1){
                [weakSelf scrollToPage:2 animated:NO];
                
            }
            if([weakSelf.delegate respondsToSelector:@selector(linearFlowViewCurrentPageIndexWillChange:)]) {
                [weakSelf.delegate linearFlowViewCurrentPageIndexWillChange:[weakSelf calculateInfinityIndex:weakSelf.pageIndex]];
            }
        }];
    } else {
        
        [self.collectionView setContentOffset:CGPointMake(pageOffset, 0) animated:NO];
        self.interactionEnabled = YES;
        self.collectionView.userInteractionEnabled = YES;
        self.isSelect = NO;
        
        self.pageIndex = page;
        
        if([self.delegate respondsToSelector:@selector(linearFlowViewCurrentPageIndexWillChange:)]) {
            [self.delegate linearFlowViewCurrentPageIndexWillChange:[self calculateInfinityIndex:self.pageIndex]];
        }
    }
    
}

#pragma mark - public method
- (void)reloadData {
    
    [self.collectionView reloadData];
    [self.collectionView performBatchUpdates:^{} completion:^(BOOL finished) {
        if ([self.delegate respondsToSelector:@selector(linearFlowViewReloadComplete)]) {
            
            if (self.isInfinity) {
                [self scrollToPage:2 animated:NO];
            } else {
                [self scrollToPage:0 animated:NO];
            }
            
            [self.delegate linearFlowViewReloadComplete];
        }
    }];
}

- (void)setItemViewSize:(CGSize)size withItemSpacing:(CGFloat)spacing infinity:(BOOL)infinity {
    
    CGRect rect = self.frame;
    self.isInfinity = infinity;
    rect.origin.x = 0;
    rect.origin.y = 0;
    
    _layout = [LinearFlowViewLayout layoutConfiguredWithCollectionView:self.collectionView itemSize:size minimumLineSpacing:spacing];
    
    _collectionView = [[UICollectionView alloc] initWithFrame:rect collectionViewLayout:self.layout];
    self.collectionView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    self.collectionView.backgroundColor = [UIColor clearColor];
    self.collectionView.alwaysBounceHorizontal = YES;
    self.collectionView.alwaysBounceVertical = NO;
    _showScrollIndicator = NO;
    self.collectionView.showsHorizontalScrollIndicator = self.showScrollIndicator;
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    
    self.collectionView.decelerationRate = UIScrollViewDecelerationRateFast;
    
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:kReuseingCellIdentity];
    
    [self addSubview:self.collectionView];
    
}
- (void)addDataCount:(NSInteger)count {
    
    NSMutableArray *indexPathsToLoad = [NSMutableArray new];
    
    for (int i = 0; i < count; i++) {
        [indexPathsToLoad addObject:[NSIndexPath indexPathForItem:self.itemCount inSection:0]];
        self.itemCount++;
    }
    if (self.itemCount == count) {
        [self.collectionView reloadData];
    }
    else {
        [self.collectionView insertItemsAtIndexPaths:indexPathsToLoad];
    }
}

- (void)setShowScrollIndicator:(BOOL)showScrollIndicator {
    
    _showScrollIndicator = showScrollIndicator;
    
    self.collectionView.showsHorizontalScrollIndicator = self.showScrollIndicator;
}
#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    self.itemCount = [self.dataSource numberOfItemsInLinearFlowView:self];
    // 무한스크롤 시 앞뒤 2개씩 추가되기때문에 + 4
    return self.isInfinity ? self.itemCount + 2 * 2 : self.itemCount;
}

- (UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    UICollectionViewCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:kReuseingCellIdentity forIndexPath:indexPath];
    
    NSInteger index = self.isInfinity ? [self calculateInfinityIndex:indexPath.row] : indexPath.row;
    
    UIView *reusingView = [self.reuseingViews objectForKey:[NSNumber numberWithInteger:indexPath.row]];
    
    UIView * view = [self.dataSource linearFlowView:self viewForItemAtIndex:index reusingView:reusingView];
    
    [self.reuseingViews setObject:view forKey:[NSNumber numberWithInteger:indexPath.row]];
    
    for(UIView *subView in cell.subviews)
        [subView removeFromSuperview];
    
    [cell addSubview:view];
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if(self.interactionEnabled) {
        
        self.interactionEnabled = NO;
        self.collectionView.userInteractionEnabled = NO;
        NSUInteger selectedPage = indexPath.row;
        self.isSelect = YES;
        
        if (selectedPage != self.pageIndex) {
            if (self.isInfinity) {
                [self selectScrollToPage:selectedPage animated:YES];
            } else {
                [self scrollToPage:selectedPage animated:YES];
                
            }
        } else {
            
            self.interactionEnabled = YES;
            self.collectionView.userInteractionEnabled = YES;
            self.isSelect = NO;
        }
        
        if([self.delegate respondsToSelector:@selector(linearFlowViewCurrentPageIndexDidChange:)]) {
            
            [self.delegate linearFlowViewCurrentPageIndexDidChange:[self calculateInfinityIndex:selectedPage]];
        }
    }
}
- (void)collectionView:(UICollectionView *)collectionView
   moveItemAtIndexPath:(NSIndexPath *)sourceIndexPath
           toIndexPath:(NSIndexPath *)destinationIndexPath{
    
}

- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    
    NSLog(@"indexpath : %ld", (long)indexPath.row);
}
#pragma mark - UIScrollView Delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    self.collectionView.userInteractionEnabled = YES;
    if (self.isInfinity && !self.isSelect) {
        
        NSInteger maxIndex = self.itemCount;
        CGFloat startOffset = 2 * self.itemWidth - self.collectionView.contentInset.left;
        CGFloat endOffset = (maxIndex + 2) * self.itemWidth - self.collectionView.contentInset.left;
        
        if (startOffset > scrollView.contentOffset.x) {
            [self scrollToPage:maxIndex + 2 animated:NO];
        } else if (endOffset < scrollView.contentOffset.x) {
            [self scrollToPage:2 animated:NO];
        }
    }
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    
    self.collectionView.userInteractionEnabled = YES;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    
    if([self.delegate respondsToSelector:@selector(linearFlowViewCurrentPageIndexDidChange:)]) {
        
        [self.delegate linearFlowViewCurrentPageIndexDidChange:self.isInfinity ? [self calculateInfinityIndex:self.pageIndex] : self.pageIndex];
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    
    self.startDragPoint = scrollView.contentOffset;
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset {
    
    CGFloat pageOffset = 0;
    
    NSInteger temp = self.pageIndex;
    NSInteger maxIndex = self.isInfinity ? self.itemCount + 4 : self.itemCount;
    
    if(velocity.x > 0 && self.pageIndex + 1 <= maxIndex) {
        self.pageIndex++;
    } else if (velocity.x < 0 && self.pageIndex -1 >= 0) {
        self.pageIndex--;
    } else {
        CGFloat targetX = targetContentOffset->x;
        
        CGFloat revision = (targetX + self.collectionView.contentInset.left) / self.itemWidth;
        
        self.pageIndex = (NSInteger)revision;
        
    }
    
    if (self.pageIndex < 0) {
        self.pageIndex = 0;
    } else if (self.pageIndex >= maxIndex) {
        self.pageIndex = maxIndex-1;
    }
    
    if(temp != self.pageIndex && maxIndex > self.pageIndex) {
        pageOffset = self.pageIndex * self.itemWidth - self.collectionView.contentInset.left;
        targetContentOffset->x = pageOffset;
        
    }
    
    if([self.delegate respondsToSelector:@selector(linearFlowViewCurrentPageIndexWillChange:)]) {
        [self.delegate linearFlowViewCurrentPageIndexWillChange: self.isInfinity ? [self calculateInfinityIndex:self.pageIndex] : self.pageIndex];
    }
}

- (NSInteger)currentPage {
    float offsetX = _collectionView.contentOffset.x;
    
    int intPage = offsetX / self.itemWidth;
    float floatPage = offsetX / self.itemWidth;
    
    return (floatPage - intPage) < 0.5 ? intPage : intPage + 1;
}

- (NSInteger)calculateInfinityIndex:(NSInteger)index {
    
    NSInteger maxIndex = self.itemCount;
    
    // 앞뒤에 2개씩이라 - 2
    NSInteger calculateIndex = index - 2;
    
    if(calculateIndex < 0) {
        
        calculateIndex = maxIndex + calculateIndex;
        
    } else if (calculateIndex >= maxIndex) {
        
        calculateIndex = calculateIndex - maxIndex;
    }
    return (calculateIndex > 0) ? calculateIndex : 0;
}

- (UIView *)retainCell:(NSInteger)index {
    
    UIView *view = [self.reuseingViews objectForKey:[NSNumber numberWithInteger:index]];
    
    return view;
}
@end
