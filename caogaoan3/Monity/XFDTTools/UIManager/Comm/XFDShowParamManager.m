//
//  XFDShowParamManager.m
//  XFDTToolsKit
//
//  Created by XDS on 2018/5/25.
//  Copyright © 2018年 iFlytek_PIC. All rights reserved.
//

#import "XFDShowParamManager.h"
#import "XFDTToolsDefine.h"

@implementation XFDParamsObj
@end


@interface XFDShowParamManager()
@property (nonatomic, strong) NSMutableArray *currentShowCategorys;
@property (nonatomic, strong) NSMutableArray *allCategorys;
@end

@implementation XFDShowParamManager
/**
 * 初始化XFDShowParamManager
 */
+ (instancetype)shareInstance
{
    static id instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    return instance;
}

- (NSMutableArray *)currentShowCategorys
{
    if(!_currentShowCategorys){
        _currentShowCategorys = [NSMutableArray array];
    }
    _currentShowCategorys = [[NSUserDefaults standardUserDefaults] objectForKey:XFD_CATEGORY_USERDEFAULT_KEY];
    return _currentShowCategorys;
}
- (NSMutableArray *)allCategorys
{
    if(!_allCategorys){
        _allCategorys = [NSMutableArray array];
        NSMutableArray *temp = [NSMutableArray arrayWithObjects:@"内存",@"CPU",@"电量",@"网速和流量",@"内存泄漏",@"崩溃率和崩溃日志",@"监控结果查看和统计",@"监控悬浮显示", nil];
        [temp enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            XFDParamsObj * ob = [[XFDParamsObj alloc] init];
            ob.showType = 1 << idx;
            ob.categoryName = obj;
            ob.isShow = NO;
        }];
    }
    return _allCategorys;
}

- (void)addCategoryToShow:(XFDParamsObj *)obj
{
    if(![self p_isAlreadAdd:obj]){
        [self.currentShowCategorys addObject:obj];
    }
}

- (void)removeCategoryOfShow:(XFDParamsObj *)obj
{
    if([self p_isAlreadAdd:obj]){
        [self.currentShowCategorys removeObject:obj];
    }
}

- (BOOL)p_isAlreadAdd:(XFDParamsObj *)obj
{
    for (int i = 0; i < _currentShowCategorys.count; i++) {
        XFDParamsObj *obj_temp = _currentShowCategorys[i];
        if(obj.showType & obj_temp.showType){
            return YES;
        }
    }
    return NO;
}

@end
