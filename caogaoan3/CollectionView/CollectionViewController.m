//
//  CollectionViewController.m
//  caogaoan3
//
//  Created by Lemon HOLL on 2018/4/23.
//  Copyright © 2018年 MountainX. All rights reserved.
//

#import "CollectionViewController.h"

#import "CusModel.h"

#import "CusFlowLayout.h"


#define space  8
#define SCREEN_WIDTH        [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT       [UIScreen mainScreen].bounds.size.height

@interface CollectionViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>
@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, strong) NSMutableArray *dataArray;
@end

@implementation CollectionViewController


- (NSMutableArray *)dataArray
{
    if(_dataArray == nil){
        NSMutableArray * arr  = [NSMutableArray arrayWithContentsOfFile:@"0.plist"];
        
        [arr enumerateObjectsUsingBlock:^(NSDictionary * obj, NSUInteger idx, BOOL * _Nonnull stop) {
            CusModel * model = [CusModel new];
            [model setValuesForKeysWithDictionary:obj];
            [_dataArray addObject:model];
        }];
    }
    return _dataArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
   
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
//    UICollectionViewFlowLayout * flowLayout = [[UICollectionViewFlowLayout alloc] init];
//    flowLayout.itemSize = self.view.frame.size;
//    flowLayout.minimumLineSpacing = 2 * space;
//
//    flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
//    flowLayout.sectionInset = UIEdgeInsetsMake(0, space,0, space);

    
    CusFlowLayout * flowLayout = [[CusFlowLayout alloc] init];
    
    
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(-space, 0, SCREEN_WIDTH + 2 * space, SCREEN_HEIGHT)  collectionViewLayout:flowLayout];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    [self.view addSubview:self.collectionView];
    
  /// self.collectionView.pagingEnabled = YES;
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
    
    
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 100;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
//    CATransform3D turnTrans = CATransform3DMakeRotation(0, 0, M_PI/4, 1);
//    [UIView animateWithDuration:2 animations:^{
////        cell.layer.transform = turnTrans;
//
//        [cell.layer setValue:@(100) forKeyPath:@"transform.translation.z"];
//    }];
    if(indexPath.row % 2 == 0){
        cell.backgroundColor = [UIColor redColor];
    }else
        cell.backgroundColor = [UIColor greenColor];
    
    return cell;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

//- (void)encodeWithCoder:(nonnull NSCoder *)aCoder {
//    <#code#>
//}
//
//- (void)traitCollectionDidChange:(nullable UITraitCollection *)previousTraitCollection {
//    <#code#>
//}
//
//- (void)preferredContentSizeDidChangeForChildContentContainer:(nonnull id<UIContentContainer>)container {
//    <#code#>
//}
//
//- (CGSize)sizeForChildContentContainer:(nonnull id<UIContentContainer>)container withParentContainerSize:(CGSize)parentSize {
//    <#code#>
//}
//
//- (void)systemLayoutFittingSizeDidChangeForChildContentContainer:(nonnull id<UIContentContainer>)container {
//    <#code#>
//}
//
//- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(nonnull id<UIViewControllerTransitionCoordinator>)coordinator {
//    <#code#>
//}
//
//- (void)willTransitionToTraitCollection:(nonnull UITraitCollection *)newCollection withTransitionCoordinator:(nonnull id<UIViewControllerTransitionCoordinator>)coordinator {
//    <#code#>
//}
//
//- (void)didUpdateFocusInContext:(nonnull UIFocusUpdateContext *)context withAnimationCoordinator:(nonnull UIFocusAnimationCoordinator *)coordinator {
//    <#code#>
//}
//
//- (void)setNeedsFocusUpdate {
//    <#code#>
//}
//
//- (BOOL)shouldUpdateFocusInContext:(nonnull UIFocusUpdateContext *)context {
//    <#code#>
//}
//
//- (void)updateFocusIfNeeded {
//    <#code#>
//}

@end
