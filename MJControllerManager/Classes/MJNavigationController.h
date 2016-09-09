//
//  MJNavigationController.h
//  Common
//
//  Created by 黄磊 on 16/4/6.
//  Copyright © 2016年 Musjoy. All rights reserved.
//

#import <UIKit/UIKit.h>

#ifndef kNavActiveColor
#define kNavActiveColor [UIColor colorWithRed:0 green:122.0/255.0 blue:1 alpha:1]
#endif

@interface MJNavigationController : UINavigationController<UIGestureRecognizerDelegate>

@property (nonatomic, nonatomic) BOOL isViewShow;

@property (nonatomic, nonatomic) BOOL isViewHadShow;        // 是否已经显示过

- (void)reloadTheme;

#pragma mark -

- (void)showBackButtonWith:(UIViewController *)viewController;
- (void)showBackButtonWith:(UIViewController *)viewController andAction:(SEL)action;
- (UIBarButtonItem *)showLeftButtonWith:(UIViewController *)viewController title:(NSString*)title action:(SEL)action;
- (UIBarButtonItem *)showLeftButtonWith:(UIViewController *)viewController image:(UIImage *)image action:(SEL)action;

- (UIBarButtonItem *)showRightButtonWith:(UIViewController *)viewController title:(NSString*)title action:(SEL)action ;
- (UIBarButtonItem *)showRightButtonWith:(UIViewController *)viewController image:(UIImage *)image action:(SEL)action;

- (BOOL)back;

- (BOOL)clickLeftItem;

@end


/** UIViewController extension */
@interface UIViewController (MJNavigationController)

- (MJNavigationController *)navController;

// The funtion below need be overwrite
/** 是否可以滑出 */
- (BOOL)canSlipOut:(UIGestureRecognizer *)gestureRecognizer;
/** 是否可以滑入 */
- (BOOL)canSlipIn:(UIGestureRecognizer *)gestureRecognizer;

@end

