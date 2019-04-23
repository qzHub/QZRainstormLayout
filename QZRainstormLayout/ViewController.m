//
//  ViewController.m
//  QZRainstormLayout
//
//  Created by mac on 2019/4/23.
//  Copyright © 2019 QZ. All rights reserved.
//

#import "ViewController.h"
#import "QZRainstormLayout.h" // 自定义流水布局

@interface ViewController () <UICollectionViewDataSource>

@property (nonatomic, strong) UICollectionView *collectionView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self configUI];
}

#pragma mark - UI
- (void)configUI {
    // 布局
    QZRainstormLayout *layout = [[QZRainstormLayout alloc] init];
    layout.columnCount      = 3;        // 列数
    layout.columnSpacing    = 5;       // 每一列之间的间距
    layout.rowSpacing       = 5;       // 每一行之间的间距
    layout.sectionInset     = UIEdgeInsetsMake(0, 10, 0, 10);
    [layout setItemHeightBlock:^CGFloat(CGFloat itemHeight, NSIndexPath * _Nonnull indexPath) {
        return 50 + (60 * (arc4random() % 5) / 6) ;
    }];
    
    //创建collectionView
    self.collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:layout];
    self.collectionView.backgroundColor = [UIColor whiteColor];
    self.collectionView.dataSource = self;
    [self.view addSubview:self.collectionView];
    
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cellID"];
    
}


#pragma mark <UICollectionViewDataSource>
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return arc4random() % 50;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cellID" forIndexPath:indexPath];

    cell.backgroundColor = [UIColor orangeColor];
    return cell;
}

@end
