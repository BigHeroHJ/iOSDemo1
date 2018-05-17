//
//  PhotoBrowerController.m
//  caogaoan3
//
//  Created by XDS on 2018/5/7.
//  Copyright © 2018年 MountainX. All rights reserved.
//

#import "PhotoBrowerController.h"
#import "PhotoBrowerTransition.h"

static const float  photoSapce = 10;

@interface PhotoBrowerController ()<UIViewControllerTransitioningDelegate,UICollectionViewDelegate,UICollectionViewDataSource>
@property (nonatomic, strong) UICollectionView * allAblumsView;
@property (nonatomic, strong) PhotoBrowerTransition *translation;
@property (nonatomic, strong) PHCachingImageManager * cacheImageManager;

@end

@implementation PhotoBrowerController

- (instancetype)initWithItems:(NSMutableArray * )items currentIndex:(NSInteger) currentIndex
{
    self = [super init];
    if(self){
        self.transitioningDelegate = self;
        self.currentIndex = currentIndex;
        self.items = items;
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.allAblumsView];
    [self.allAblumsView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
}


- (PhotoBrowerTransition *)translation
{
    if (!_translation)
    {
        _translation = [[PhotoBrowerTransition alloc] init];
    }
    return _translation;
}

- (PHCachingImageManager * )cacheImageManager
{
    
    if(_cacheImageManager == nil){
        _cacheImageManager = [[PHCachingImageManager alloc] init];
    }
    return _cacheImageManager;
    
}

- (UICollectionView *)allAblumsView
{
    
    if(_allAblumsView == nil){
        
        UICollectionViewFlowLayout * flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.itemSize = CGSizeMake(self.view.frame.size.width, self.view.frame.size.height);
        flowLayout.minimumLineSpacing = 2 * photoSapce;
        flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
       // flowLayout.minimumInteritemSpacing = 2 * photoSapce;
        
        flowLayout.sectionInset = UIEdgeInsetsMake(0, photoSapce, 0, photoSapce);
        
        _allAblumsView = [[UICollectionView alloc] initWithFrame:CGRectMake(-photoSapce, 0, self.view.frame.size.width + 2 * photoSapce, self.view.frame.size.height) collectionViewLayout:flowLayout];
        _allAblumsView.delegate = self;
        _allAblumsView.dataSource = self;
        _allAblumsView.pagingEnabled = YES;
    }
    return _allAblumsView;
    
}


#pragma mark -- delegate & datasource
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.items.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    PHAsset * asset = self.items[indexPath.item];
    [cell.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if([obj isKindOfClass:[UIImageView class]]){
            [obj removeFromSuperview];
        }
    }];
    float originWidth = asset.pixelWidth;
    float originHeight = asset.pixelHeight;
    float originRadio = originWidth / originHeight;
    
    float showWidth  = 0;
    float showHeight = 0;
    if(originWidth <= collectionView.frame.size.width * [UIScreen mainScreen].scale){
        showWidth = originWidth;
        showHeight = originHeight;
    }else{
        showWidth = cell.frame.size.width;
        showHeight =  cell.frame.size.width / originRadio;
    }
    [self.cacheImageManager requestImageForAsset:asset targetSize:CGSizeMake(showWidth, showHeight) contentMode:PHImageContentModeDefault options:nil resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
        UIImageView *imgView = [[UIImageView alloc] initWithImage:result];
        imgView.frame = CGRectMake(0, 0, showWidth, showHeight);
        imgView.center = CGPointMake(cell.frame.size.width  /2.0f, cell.frame.size.height / 2.0f);
        [cell addSubview:imgView];
    }];
    cell.backgroundColor = [UIColor grayColor];
    return cell;
    
}


#pragma mark UIViewControllerTransitioningDelegate(转场动画代理)
- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source
{
    self.translation.transitionType = PhotoBrowerTransitionPresent;
    self.translation.asset = self.items[self.currentIndex];
    return self.translation;
}

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed
{
    self.translation.transitionType = PhotoBrowerTransitionDismiss;
    return self.translation;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

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
