//
//  PHViewController.m
//  caogaoan3
//
//  Created by XDS on 2018/5/7.
//  Copyright © 2018年 MountainX. All rights reserved.
//

#import "PHViewController.h"
#import "PHManager.h"
#import <Photos/Photos.h>
#import "PhotoBrowerController.h"

static const float ablumMargin = 2.0;
static const int ablumsCols = 4;

@interface PHViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>
{
    CGSize  thumbImageSize;
}
@property (nonatomic, strong) UICollectionView * allAblumsView;
@property (nonatomic, strong) NSMutableArray * ablums;
@property (nonatomic, strong) NSMutableArray * videos;
@property (nonatomic, strong) PHManager * phManager;
@property (nonatomic, strong) PHCachingImageManager * cacheImageManager;
@property (nonatomic, strong) PHFetchOptions * options;
@end

@implementation PHViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
   // [self getUserAlbums];
    
    [self judgePhotoAuth];
    [self getAllAssetImage];
    [self getSmartAblums];
    
    [self.view addSubview:self.allAblumsView];
    [self.allAblumsView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
}

#pragma mark --lazy load
-(PHManager *)phManager
{
    
    if(_phManager == nil){
        _phManager = [[PHManager alloc] init];
    }
    return _phManager;
    
}

- (PHFetchOptions *)options {
    if (!_options) {
        _options = [[PHFetchOptions alloc] init];
        _options.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:YES]];
    }
    return _options;
}

-(NSMutableArray  *)ablums
{
    
    if(_ablums == nil){
        _ablums = [[NSMutableArray alloc] init];
    }
    return _ablums;
    
}
-(NSMutableArray  *)videos
{
    
    if(_videos == nil){
        _videos = [[NSMutableArray alloc] init];
    }
    return _videos;
    
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
        
        float ablumWidth = (self.view.frame.size.width - (ablumsCols + 1) * ablumMargin) / ablumsCols;
        flowLayout.itemSize = CGSizeMake(ablumWidth, ablumWidth);
        thumbImageSize = flowLayout.itemSize;
        flowLayout.minimumInteritemSpacing = ablumMargin;
        flowLayout.minimumLineSpacing = ablumMargin;
        
        _allAblumsView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:flowLayout];
        _allAblumsView.delegate = self;
        _allAblumsView.dataSource = self;
        
    }
    return _allAblumsView;
    
}

//判断是否授权
- (void)judgePhotoAuth
{
    switch (PHPhotoLibrary.authorizationStatus) {
        case PHAuthorizationStatusAuthorized:
            
            break;
            
        default:
            [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
                if(status != PHAuthorizationStatusAuthorized)
                {
                    return ;
                }
            }];
            break;
    }
}

#pragma mark -- delegate & datasource
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.ablums.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    PHAsset * asset = self.ablums[indexPath.item];
    [cell.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if([obj isKindOfClass:[UIImageView class]]){
            [obj removeFromSuperview];
        }
    }];
    [self.cacheImageManager requestImageForAsset:asset targetSize:thumbImageSize contentMode:PHImageContentModeDefault options:nil resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
        UIImageView *imgView = [[UIImageView alloc] initWithImage:result];
        imgView.frame = cell.bounds;
        [cell addSubview:imgView];
    }];
    cell.backgroundColor = [UIColor grayColor];
    return cell;
    
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [collectionView deselectItemAtIndexPath:indexPath animated:NO];
    
    PhotoBrowerController * photoBrower = [[PhotoBrowerController alloc] initWithItems:self.ablums currentIndex:indexPath.item];

    [self presentViewController:photoBrower animated:YES completion:nil];
}
#pragma mark -- 获取用户创建的album
- (void)getUserAlbums
{
    
   PHFetchResult * userResult = [self.phManager getUserCreatResult];
    
   for (int i =0 ; i < userResult.count; i++) {
        PHCollection * collection = userResult[i];
       
        if([collection isKindOfClass:[PHAssetCollection class]]){//phassetcollection 中包含的是phasset 的资源
            PHAssetCollection * assetCollection = (PHAssetCollection *)collection;
            PHFetchResult * fetchResult = [PHAsset fetchAssetsInAssetCollection:assetCollection options:nil];
            [self.ablums addObject:collection];
        }else{
            NSAssert(NO, @"未找到asset资源");
        }
    }
    
}

/**
 * 获取所有的智能相册
 */
- (void)getSmartAblums
{
    
    PHFetchResult * fetchResult = [self.phManager getsmartResult];
    NSMutableArray * results = [NSMutableArray array];
    NSMutableArray * resultTitles = [NSMutableArray array];

    for (int i = 0 ; i < fetchResult.count; i++) {
        PHAssetCollection * collection = fetchResult[i];
        if([collection isKindOfClass:[PHAssetCollection class]]){
            switch (collection.assetCollectionSubtype) {
                case PHAssetCollectionSubtypeSmartAlbumAllHidden:
                    
                    break;
                case PHAssetCollectionSubtypeSmartAlbumUserLibrary:
                {
                    PHFetchResult * asstFetchResult = [PHAsset fetchAssetsInAssetCollection:collection options:self.options];
                    [results insertObject:asstFetchResult atIndex:0];
                    [resultTitles insertObject:collection.localizedTitle atIndex:0];
                }
                    
                default:
                {
                    PHFetchResult * asstFetchResult = [PHAsset fetchAssetsInAssetCollection:collection options:self.options];
                    [results addObject:asstFetchResult];
                    [resultTitles addObject:collection.localizedTitle];
                }
                    break;
            }
        }
        
         NSLog(@"%s--%@--%@",__func__,results[i],resultTitles[i]);
    }
   
}
/**
 * 获取camera 中的所有的照片
 */
- (void)getAllAssetImage
{
    
//    PHFetchOptions * option = [[PHFetchOptions alloc] init];
//    option.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:YES]];
    
    
    PHFetchResult * result_images = [PHAsset fetchAssetsWithMediaType:PHAssetMediaTypeImage options:self.options];
    
    PHFetchResult * result_videos = [PHAsset fetchAssetsWithMediaType:PHAssetMediaTypeVideo options:self.options];
    
    NSLog(@"all assets %@",result_images);
    for (int i = 0; i < result_images.count; i++) {
        PHAsset *asset = result_images[i];
        [self.ablums addObject:asset];
    }
    
    for (int i = 0; i < result_videos.count; i++) {
        PHAsset *asset = result_videos[i];
        [self.videos addObject:asset];
    }
    
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

@end
