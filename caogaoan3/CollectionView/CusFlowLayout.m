
//
//  CusFlowLayout.m
//  caogaoan3
//
//  Created by XDS on 2018/4/23.
//  Copyright © 2018年 MountainX. All rights reserved.
//

#import "CusFlowLayout.h"

@implementation CusFlowLayout

    /**
     *  用来做布局的初始化
     *  注意: 一定要调用 [super prepareLayout]
     */
- (void)prepareLayout{
        
        [super prepareLayout];
        self.itemSize = CGSizeMake(100, 100);
        //设置内边距
        CGFloat inset = (self.collectionView.frame.size.width - self.itemSize.width)*0.5;
    
        CGFloat heightInsert = (self.collectionView.frame.size.height - self.itemSize.height)*0.5;
    
        self.sectionInset = UIEdgeInsetsMake(heightInsert, inset, heightInsert, inset);
        //设置滚动方向
        self.scrollDirection = UICollectionViewScrollDirectionHorizontal;
}
    
- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect
{
    //获得super已经计算好的属性
    NSArray *orignal = [super layoutAttributesForElementsInRect:rect];

    NSArray *array = [[NSArray alloc] initWithArray:orignal copyItems:YES];

    //计算collectionView中心点位置
    CGFloat centerX = self.collectionView.contentOffset.x + self.collectionView.frame.size.width/2;

    for (UICollectionViewLayoutAttributes *attri in array) {
        
        //cell中心点 和 collectionView最中心点x 的间距
        CGFloat space = ABS(attri.center.x -  centerX) ;
        
        //根据距离算缩放比例
        CGFloat scale = 1- space/(self.collectionView.frame.size.width/2);
        //进行缩放
        attri.transform = CGAffineTransformMakeScale(scale, scale);
    }
    return array;
}

/**
 *  当collectionView的显示范围发生改变的时候,是否需要刷新重新布局
 *一但重新刷新布局,就会调用
 *1.prepareLayout
 *2.layoutAttributesForElementsInRect:(CGRect)rect 方法
 */
- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds
{
    return YES;
}


- (CGPoint)targetContentOffsetForProposedContentOffset:(CGPoint)proposedContentOffset
{
    // 计算出最终显示的矩形框
    
    CGRect rect;
    
    rect.origin.y = 0;
    
    rect.origin.x = proposedContentOffset.x;
    
    rect.size = self.collectionView.frame.size;
    
    // 获得super已经计算好的布局属性
    
    NSArray *array = [super layoutAttributesForElementsInRect:rect];
    
    // 计算collectionView最中心点的x值
    
    CGFloat centerX = proposedContentOffset.x + self.collectionView.frame.size.width * 0.5;
    
    // 存放最小的间距值
    
    CGFloat minDelta = MAXFLOAT;
    
    for (UICollectionViewLayoutAttributes *attrs in array) {
        
        if (ABS(minDelta) > ABS(attrs.center.x - centerX)) {
            
            minDelta = attrs.center.x - centerX;
          
        
        }
        
    }
    // 修改原有的偏移量
    
    proposedContentOffset.x += minDelta;
    
    return proposedContentOffset;
}


//proposedContentOffset scrollview 最终停止滚动的偏移量
- (CGPoint)targetContentOffsetForProposedContentOffset:(CGPoint)proposedContentOffset withScrollingVelocity:(CGPoint)velocity
{
    
    NSLog(@"%@",NSStringFromCGPoint(proposedContentOffset));
    // 计算出最终显示的矩形框
    
    CGRect rect;
    
    rect.origin.y = 0;
    
    rect.origin.x = proposedContentOffset.x;
    
    rect.size = self.collectionView.frame.size;
    
    // 获得super已经计算好的布局属性
    
    NSArray *array = [super layoutAttributesForElementsInRect:rect];
    
    // 计算collectionView最中心点的x值
    
    CGFloat centerX = proposedContentOffset.x + self.collectionView.frame.size.width * 0.5;
    
    // 存放最小的间距值
    
    CGFloat minDelta = MAXFLOAT;
    
    for (UICollectionViewLayoutAttributes *attrs in array) {
        
        if (ABS(minDelta) > ABS(attrs.center.x - centerX)) {
            
            minDelta = attrs.center.x - centerX;
        }
        
    }
    // 修改原有的偏移量
    
    proposedContentOffset.x += minDelta;
    
    return proposedContentOffset;
}
@end
