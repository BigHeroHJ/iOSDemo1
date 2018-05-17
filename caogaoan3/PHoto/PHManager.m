//
//  PHManager.m
//  caogaoan3
//
//  Created by XDS on 2018/5/7.
//  Copyright © 2018年 MountainX. All rights reserved.
//

#import "PHManager.h"
static dispatch_once_t onceToken = 0;
static PHManager *manager = nil;

@implementation PHManager

+ (instancetype)shareInstace
{
    dispatch_once(&onceToken, ^{
        manager = [[PHManager alloc] init];
    });
    return manager;
}

- (PHFetchResult *)getAblumsResult
{
    PHFetchResult * result = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeAlbum subtype:PHAssetCollectionSubtypeAlbumRegular options:nil];
    return result;
}

- (PHFetchResult *)getsmartResult
{
    PHFetchResult * result = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum subtype:PHAssetCollectionSubtypeAlbumRegular options:nil];
    return result;
}


- (PHFetchResult *)getUserCreatResult
{
    PHFetchResult * result = [PHCollectionList fetchTopLevelUserCollectionsWithOptions:nil];
    
    return result;
}

@end
