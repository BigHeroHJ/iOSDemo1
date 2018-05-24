//
//  XFDBaseViewController.h
//  caogaoan3
//
//  Created by XDS on 2018/5/24.
//  Copyright © 2018年 MountainX. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^XFD_UtilityDismissBlock)(void);

@interface XFDBaseViewController : UIViewController
@property (nonatomic, copy) XFD_UtilityDismissBlock dimissUtilityBlock;
@end
