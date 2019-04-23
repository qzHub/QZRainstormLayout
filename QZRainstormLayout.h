//
//  QZRainstormLayout.h
//  QZRainstormLayout
//
//  Created by mac on 2019/4/23.
//  Copyright © 2019 QZ. All rights reserved.
//

#import <UIKit/UIKit.h>


/**
 *实现了瀑布流功能，但是不能添加头部和底部视图
 */

NS_ASSUME_NONNULL_BEGIN

@interface QZRainstormLayout : UICollectionViewLayout

//总共多少列，默认是2
@property (nonatomic, assign) NSInteger columnCount;

//列间距，默认是0
@property (nonatomic, assign) NSInteger columnSpacing;

//行间距，默认是0
@property (nonatomic, assign) NSInteger rowSpacing;

//section与collectionView的间距，默认是（0，0，0，0）
@property (nonatomic, assign) UIEdgeInsets sectionInset;


//计算item高度的block，将item的高度与indexPath传递给外界
@property (nonatomic, copy) CGFloat(^itemHeightBlock)(CGFloat itemHeight,NSIndexPath *indexPath);

@end

NS_ASSUME_NONNULL_END
