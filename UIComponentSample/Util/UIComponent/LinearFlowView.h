//
//  LinearFlowView.h
//  Example
//
//  Created by Ryan Kim on 2017. 2. 27..
//  Copyright © 2017년 Digitalworks. All rights reserved.
//
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@protocol LinearFlowViewDelegate,LinearFlowViewDataSource;

@interface LinearFlowView : UIView

@property(nonatomic, weak, nullable) IBOutlet id<LinearFlowViewDataSource> dataSource;
@property(nonatomic, weak, nullable) IBOutlet id<LinearFlowViewDelegate> delegate;
@property(nonatomic) BOOL showScrollIndicator;
@property(nonatomic) BOOL isInfinity;

@property(nonatomic) NSInteger itemCount;
@property(nonatomic) NSInteger currentIndex;
@property(nonatomic) NSInteger pageIndex;

@property(nonatomic,strong) NSMutableDictionary *reuseingViews;

- (void)scrollToPage:(NSUInteger)page animated:(BOOL)animated;

- (void)setItemViewSize:(CGSize)size withItemSpacing:(CGFloat)spacing infinity:(BOOL)infinity;
- (void)addDataCount:(NSInteger)count;
- (void)reloadData;

- (UIView *)retainCell:(NSInteger)index;
@end

@protocol LinearFlowViewDelegate <NSObject,UIScrollViewDelegate>

@optional
- (void)linearFlowViewCurrentPageIndexDidChange:(NSInteger) index;
- (void)linearFlowViewCurrentPageIndexWillChange:(NSInteger) index;
- (void)linearFlowViewReloadComplete;
@end

@protocol LinearFlowViewDataSource <NSObject>

@required
- (NSInteger)numberOfItemsInLinearFlowView:(LinearFlowView * __nonnull)linearFlowView;
- (UIView * __nonnull)linearFlowView:(LinearFlowView * __nonnull)linearFlowView viewForItemAtIndex:(NSInteger)index reusingView:(UIView * __nullable)view;

@end
