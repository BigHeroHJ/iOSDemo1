//
//  CustomLayout.h
//  caogaoan3
//
//  Created by XDS on 2018/4/23.
//  Copyright © 2018年 MountainX. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CustomLayoutDelegate <NSObject>
- (CGFloat)getCellwithIndexPath:(int )index;
@end

@interface CustomLayout : UICollectionViewLayout

@end
