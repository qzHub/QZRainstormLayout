//
//  QZRainstormLayout.m
//  QZRainstormLayout
//
//  Created by mac on 2019/4/23.
//  Copyright © 2019 QZ. All rights reserved.
//

#import "QZRainstormLayout.h"

#define QZCollectionWidth self.collectionView.frame.size.width

@interface QZRainstormLayout ()
// 每一列的最大Y值
@property (nonatomic, strong) NSMutableDictionary *columnMaxYs;
// 存放所有cell的布局属性
@property (nonatomic, strong) NSMutableArray *attributesArray;
@end

@implementation QZRainstormLayout

#pragma mark - Lazy load
- (NSMutableDictionary *)columnMaxYs {
    if (!_columnMaxYs) {
        _columnMaxYs = [[NSMutableDictionary alloc] init];
    }
    return _columnMaxYs;
}

- (NSMutableArray *)attributesArray {
    if (!_attributesArray) {
        _attributesArray = [[NSMutableArray alloc] init];
    }
    return _attributesArray;
}

#pragma mark- 构造方法
- (instancetype)init {
    if (self = [super init]) {
        self.columnCount = 2;
    }
    return self;
}

#pragma mark - 实现内部的方法
/**
 * 决定了collectionView的contentSize
 */
- (CGSize)collectionViewContentSize {
    
    __block NSNumber *maxIndex = @0;
    //遍历字典，找出最长的那一列
    [self.columnMaxYs enumerateKeysAndObjectsUsingBlock:^(NSNumber *key, NSNumber *obj, BOOL *stop) {
        if ([self.columnMaxYs[maxIndex] floatValue] < obj.floatValue) {
            maxIndex = key;
        }
    }];
    
    //collectionView的contentSize.height就等于最长列的最大y值+下内边距
    return CGSizeMake(0, [self.columnMaxYs[maxIndex] floatValue] + self.sectionInset.bottom);
}

- (void)prepareLayout {
    [super prepareLayout];

    //初始化字典，有几列就有几个键值对，key为列，value为列的最大y值，初始值为上内边距
    for (int i = 0; i < self.columnCount; i++) {
        self.columnMaxYs[@(i)] = @(self.sectionInset.top);
    }
    
    //根据collectionView获取总共有多少个item
    NSInteger itemCount = [self.collectionView numberOfItemsInSection:0];
    [self.attributesArray removeAllObjects];
    //为每一个item创建一个attributes并存入数组
    for (int i = 0; i < itemCount; i++) {
        UICollectionViewLayoutAttributes *attributes = [self layoutAttributesForItemAtIndexPath:[NSIndexPath indexPathForItem:i inSection:0]];
        [self.attributesArray addObject:attributes];
    }
}


/**
 * 说明所有元素（比如cell、补充控件、装饰控件）的布局属性
 */
- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect {
    return self.attributesArray;
}

/**
 * 说明cell的布局属性
 */
- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewLayoutAttributes *attrs = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    
    /** 计算indexPath位置cell的布局属性 */
    
    //item的宽度 = (collectionView的宽度 - 内边距与列间距) / 列数
    CGFloat itemWidth = (QZCollectionWidth - self.sectionInset.left - self.sectionInset.right - (self.columnCount - 1) * self.columnSpacing) / self.columnCount;
    
    CGFloat itemHeight = 0;
    //获取item的高度，由外界计算得到
    if (self.itemHeightBlock) itemHeight = self.itemHeightBlock(itemWidth, indexPath);
    
    //找出最短的那一列
    __block NSNumber *minIndex = @0;
    [self.columnMaxYs enumerateKeysAndObjectsUsingBlock:^(NSNumber *key, NSNumber *obj, BOOL *stop) {
        if ([self.columnMaxYs[minIndex] floatValue] > obj.floatValue) {
            minIndex = key;
        }
    }];
    
    //根据最短列的列数计算item的x值
    CGFloat itemX = self.sectionInset.left + (self.columnSpacing + itemWidth) * minIndex.integerValue;
    
    //item的y值 = 最短列的最大y值 + 行间距
    CGFloat itemY = [self.columnMaxYs[minIndex] floatValue] + self.rowSpacing;
    
    //设置attributes的frame
    attrs.frame = CGRectMake(itemX, itemY, itemWidth, itemHeight);
    
    //更新字典中的最大y值
    self.columnMaxYs[minIndex] = @(CGRectGetMaxY(attrs.frame));
    
    return attrs;
}

@end
