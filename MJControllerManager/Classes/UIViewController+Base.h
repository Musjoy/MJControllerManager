//
//  UIViewController+Base.h
//  Common
//
//  Created by 黄磊 on 16/5/31.
//  Copyright © 2016年 Musjoy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import HEADER_CONTROLLER_MANAGER

@interface UIViewController (Base)

/**
 *	@brief	提示
 *
 *	@param 	massage     提示信息
 */
- (void)alertMsg:(NSString*)massage;
- (void)alert:(NSString *)title message:(NSString *)massage;


/**
 *	@brief	显示加载框
 *
 *	@param 	labelText 	加载框显示内容
 */
- (void)startLoading:(NSString *)labelText;
- (void)startLoading:(NSString *)labelText detailText:(NSString *)detailText;

/**
 *	@brief	隐藏加载框
 */
- (void)stopLoading;

/**
 *	@brief	弹出底部的提示文字
 *
 *	@param 	str 需要弹出的字符串
 */
- (void)toast:(NSString *)str;

@end
