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
#ifdef MODULE_LOADING_VIEW
#import "MJLoadingView.h"
#endif

#ifndef sLoading
#define sLoading            @"Loading..."
#endif


@interface MJBaseViewController : UIViewController



@property (nonatomic, assign) BOOL isViewShow;

@property (nonatomic, assign) BOOL isViewHadShow;        // 是否已经显示过

#pragma mark - Layout

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *lytTop;                    ///< 顶部适配Layout
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *lytBottom;                 ///< 底部适配Layout

#ifdef MODULE_THEME_MANAGER
@property (nonatomic, strong) IBInspectable NSString *themeIdentifier;              ///< 主题标示
#endif

/// 将该aTopView与topLayoutGuide相连，调用该函数前必须确保aTopView在self.view内
- (void)alignTopView:(UIView *)aTopView;
/// 将该aBottomView与bottomLayoutGuide相连，调用该函数前必须确保aBottomView在self.view内
- (void)alignBottomView:(UIView *)aBottomView;

#pragma mark - Theme

/// 加载主题
- (void)reloadTheme;
- (void)reloadThemeForTableView:(UITableView *)aTableView;
- (void)reloadThemeForCollectionView:(UICollectionView *)aCollectionView;


#pragma mark - Loading

#ifdef MODULE_LOADING_VIEW
@property (nonatomic, strong) IBOutlet MJLoadingView *viewInnerLoading;         ///< loading View

/**
 *	@brief	显示一个界面内的loadding
 *
 *	@param 	loadingText 	在loading中显示的文案
 *
 *	@return	返回改loading的Index
 */
- (NSInteger)startInnerLoading:(NSString *)loadingText;

/**
 *	@brief	显示一个界面内的loadding，并在block中配置请求
 *
 *	@param 	loadingText 	在loading中显示的文案
 *	@param 	block           配置网络请求的block
 *
 *	@return
 */
- (void)startInnerLoading:(NSString *)loadingText withBlock:(NSString *(^)(NSInteger aIndex))block;

/**
 *	@brief	设置界面内loading的网络请求id
 *
 *	@param 	requestId 	网络请求Id
 *	@param 	aIndex      loading对应Index
 *
 *	@return
 */
- (void)setInnerLoadingRequestId:(NSString *)requestId atIndex:(NSInteger)aIndex;

/** 停止界面内最后一个loading */
- (void)stopInnerLoading;
/** 停止界面内对应aIndex的一个loading */
- (void)stopInnerLoadingAtIndex:(NSInteger)aIndex;

#endif

#pragma mark - Keyboard

/// 键盘即将显示
- (void)keyboardWillShow:(NSNotification *)notification;
/// 键盘即将消失
- (void)keyboardWillHide:(NSNotification *)notification;


@end
