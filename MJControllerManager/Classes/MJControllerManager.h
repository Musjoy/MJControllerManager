//
//  ControllerManager.h
//  Common
//
//  Created by 黄磊 on 16/4/6.
//  Copyright © 2016年 Musjoy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <ActionProtocol/ActionProtocol.h>
#ifdef  MODULE_LOADING_VIEW
#import <MJLoadingView/MJLoadingView.h>
#elif defined(MODULE_MBProgressHUD)
#import "MBProgressHUD.h"
#endif

// 配置通用loading的样式
#ifndef LOADING_COMMON_TYPE
#define LOADING_COMMON_TYPE 0
#endif

// 统计定义
#ifdef HEADER_ANALYSE
#import HEADER_ANALYSE
#ifndef STAT_Share
#define STAT_Share              @"Share"
#endif
#ifndef STAT_SharePlatform
#define STAT_SharePlatform      @"SharePlatform"
#endif
#endif

@class DataListViewController;

@interface MJControllerManager : NSObject

#pragma mark - ViewCotroller

+ (instancetype)sharedInstance;

+ (UIWindow *)mainWindow;

+ (UIWindow *)topWindow;

+ (UIViewController *)rootViewController;

/// 最顶层界面
+ (UIViewController *)topViewController;

/// 最顶层容器界面
+ (UIViewController *)topContainerController;

/// 请使用topContainerController
+ (UINavigationController *)topNavViewController;

+ (BOOL)isInRootView;

+ (void)popToRootViewController;

+ (void)popToRootViewControllerAnimated:(BOOL)animated;

+ (UIViewController *)getViewControllerWithName:(NSString *)aVCName;


+ (__kindof UIViewController *)getUniqueViewControllerWithName:(NSString *)aVCName;




//+ (DataListViewController *)getListViewControllerWithName:(NSString *)aListVCName;
//
//+ (DataListHandleModel *)getListHandleModelWith:(NSString *)aListVCName;


#pragma mark - Share View

+ (void)showShareViewWith:(NSArray *)shareContents onView:(id)aView completion:(ActionCompleteBlock)completion;

+ (void)showShareViewWith:(NSArray *)shareContents onView:(id)aView excludedList:(NSArray<UIActivityType> *)excludedList completion:(ActionCompleteBlock)completion;

//+ (void)hideShareView;


#pragma mark - Utils

/**
 *	@brief	提示
 *
 *	@param 	massage     提示信息
 */
+ (void)alertMsg:(NSString*)massage;
/**
 *	@brief	提示
 *
 *	@param 	title       提示标题
 *	@param 	massage     提示信息
 */
+ (void)alert:(NSString *)title message:(NSString *)massage;

/**
 *	@brief	弹出底部的提示文字
 *
 *	@param 	str 需要弹出的字符串
 */
+ (void)toast:(NSString *)str;

#pragma mark - Loading

/**
 *	@brief	显示加载框
 *
 *	@param 	labelText 	加载框显示内容
 *
 *  @return loading index
 */
+ (NSInteger)startLoading:(NSString *)labelText;

+ (NSInteger)startLoading:(NSString *)labelText detailText:(NSString *)detailText;


#ifdef MODULE_LOADING_VIEW
/**
 *	@brief	设置loading的网络请求id
 *
 *	@param 	requestId 	网络请求Id
 *	@param 	needCancel  是否显示取消按钮
 *	@param 	aIndex      loading对应Index
 */
+ (void)setLoadingRequestId:(NSString *)requestId needCancel:(BOOL)needCancel atIndex:(NSInteger)aIndex;
#endif

/**
 *	@brief	隐藏加载框
 */
+ (void)stopLoading;
#ifdef MODULE_LOADING_VIEW
/** 隐藏对应aIndex位置的loading */
+ (void)stopLoadingAtIndex:(NSInteger)aIndex;
/** 隐藏所有loading */
+ (void)stopAllLoading;
#endif



@end
