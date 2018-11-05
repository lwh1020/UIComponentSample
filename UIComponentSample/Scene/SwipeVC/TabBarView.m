//
//  TabBarView.m
//  UIComponentSample
//
//  Created by ibank on 2018. 10. 31..
//  Copyright © 2018년 ibank. All rights reserved.
//

#import "TabBarView.h"
#import "TabBarCell.h"

#define CELL_ID @"TabBarCell"

@interface TabBarView() <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (strong, nonatomic) NSArray *dataArray;
@end

@implementation TabBarView

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        
        NSString *className = NSStringFromClass([self class]);
        self.view = [[[NSBundle mainBundle] loadNibNamed:className owner:self options:nil] firstObject];
        [self addSubview:self.view];
        
        [self.collectionView registerNib:[UINib nibWithNibName:CELL_ID bundle:nil] forCellWithReuseIdentifier:CELL_ID];
        
        [self.collectionView setDelegate:self];
        [self.collectionView setDataSource:self];
    }
    return self;
}

- (void)setDataFromArray:(NSArray *)dataArray {
    if (dataArray) {
        self.dataArray = [NSArray arrayWithArray:dataArray];
    }
}

- (void)reloadData {
    
    [self.collectionView reloadData];
    
    [self.collectionView performBatchUpdates:^{} completion:^(BOOL finished) {
        
        [self.collectionView selectItemAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0] animated:NO scrollPosition:UICollectionViewScrollPositionNone];
    }];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataArray.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    TabBarCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CELL_ID forIndexPath:indexPath];
    
    [cell.tabLabel setText:[self.dataArray[indexPath.row] objectForKey:@"title"]];
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [self jumpSwipePage:indexPath.row];
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    CGFloat width = (SCREEN_WIDTH - ((15 * (self.dataArray.count - 1)) + (20 * 2))) / self.dataArray.count;
    CGSize size = CGSizeMake(width, self.collectionView.frame.size.height);
    
    CGFloat textWidth = 0.0;
    for (int i = 0; i < self.dataArray.count; i++) {
        
        CGSize textSize = [[self.dataArray[indexPath.row] objectForKey:@"title"] sizeWithAttributes:@{ NSFontAttributeName : [UIFont systemFontOfSize:17.0] }];
        
        if(textSize.width > width) {
            size.width = textSize.width;
        }
        textWidth += textSize.width;
    }
    return size;
}

- (void)buttonStateChanged:(NSInteger)index {
    
    NSIndexPath *indexPath;
    TabBarCell *cell;
    
    for (NSInteger i = 0; i < self.dataArray.count; i++) {
        
        indexPath = [NSIndexPath indexPathForItem:i inSection:0];
        cell = (TabBarCell *)[self.collectionView cellForItemAtIndexPath:indexPath];
        [cell setSelected:(i == index)];
    }
}

- (void)jumpSwipePage:(NSInteger)pageIndex {
    
    if ([self.delegate respondsToSelector:@selector(jumpSwipePage:)]) {
        [self.delegate jumpSwipePage:pageIndex];
    }
}

@end
