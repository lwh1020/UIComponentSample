//
//  LinearFlowViewController.m
//  UIComponentSample
//
//  Created by ibank on 2018. 10. 17..
//  Copyright © 2018년 ibank. All rights reserved.
//

#import "LinearFlowViewController.h"
#import "LinearFlowItemView.h"
#import "LinearFlowView.h"

#define MARGIN  (16 * 2)
#define SPACING 6

@interface LinearFlowViewController ()<LinearFlowViewDelegate, LinearFlowViewDataSource>

@property (strong, nonatomic) IBOutlet LinearFlowView *linearFlowView;
@property (strong, nonatomic) IBOutlet UIPageControl *pageControl;

@property(nonatomic)  CGSize flowViewItemSize;
@property (strong, nonatomic) NSMutableArray *itemList;

@end

@implementation LinearFlowViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.linearFlowView setDelegate:self];
    [self.linearFlowView setDataSource:self];
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"LinearFlowViewItem"ofType:@"plist"];
    self.itemList = [[NSMutableArray alloc]initWithContentsOfFile:path];
    
    self.flowViewItemSize = CGSizeMake(self.linearFlowView.frame.size.width - MARGIN, self.linearFlowView.frame.size.height);
    [self.linearFlowView setItemViewSize:self.flowViewItemSize withItemSpacing:SPACING infinity:NO];
    
    [self.pageControl setNumberOfPages:self.itemList.count];
    [self.pageControl setCurrentPage:0];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.linearFlowView reloadData];
}

- (NSInteger)numberOfItemsInLinearFlowView:(LinearFlowView *)linearFlowView {
    return self.itemList.count;
}

- (UIView *)linearFlowView:(LinearFlowView *)linearFlowView viewForItemAtIndex:(NSInteger)index reusingView:(UIView *)view {
    
    LinearFlowItemView *itemView = nil;
    
    if(!view) {
        
        CGRect rect = CGRectMake(0, 0, self.flowViewItemSize.width, self.flowViewItemSize.height);
        view = [[UIView alloc] initWithFrame:rect];
        
        itemView = [[LinearFlowItemView alloc] initWithFrame:view.bounds];
        [itemView setTag:1];
        [view addSubview:itemView];
    } else {
        itemView = (LinearFlowItemView *)[view viewWithTag:1];
    }
    
    [itemView.imageView setImage:[UIImage imageNamed:[self.itemList[index] objectForKey:@"imageName"]]];
    [itemView.label setText:[self.itemList[index] objectForKey:@"title"]];
    
    return view;
}

- (void)linearFlowViewCurrentPageIndexDidChange:(NSInteger)index {
    [self.pageControl setCurrentPage:index];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
