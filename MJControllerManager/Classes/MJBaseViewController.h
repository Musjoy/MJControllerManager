//
//  MJBaseViewController.h
//  Common
//
//  Created by 黄磊 on 16/4/6.
//  Copyright © 2016年 Musjoy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIViewController+Base.h"
#ifdef HEADER_CONTROLLER_MANAGER
#import HEADER_CONTROLLER_MANAGER
#endif
#ifdef MODULE_THEME_MANAGER
#import "MJThemeManager.h"
#endif
#ifdef MODULE_UTILS
#import "Utils.h"
#endif

#ifndef sLoading
#define sLoading            @"Loading..."
#endif


@interface MJBaseViewController : UIViewController

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *lytTop;        /**< 顶部适配Layout */
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *lytBottom;     /**< 底部适配Layout */

@property (nonatomic, nonatomic) BOOL isViewShow;

@property (nonatomic, nonatomic) BOOL isViewHadShow;        // 是否已经显示过

/// 加载主题
- (void)reloadTheme;
- (void)reloadThemeForTableView:(UITableView *)aTableView;
- (void)reloadThemeForCollectionView:(UICollectionView *)aCollectionView;

/// 键盘即将显示
- (void)keyboardWillShow:(NSNotification *)notification;
/// 键盘即将消失
- (void)keyboardWillHide:(NSNotification *)notification;


@end
