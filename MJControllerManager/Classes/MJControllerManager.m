//
//  MJControllerManager.m
//  Common
//
//  Created by 黄磊 on 16/4/6.
//  Copyright © 2016年 Musjoy. All rights reserved.
//

#import "MJControllerManager.h"
#import HEADER_BASE_VIEW_CONTROLLER
#import HEADER_WINDOW_ROOT_VIEW_CONTROLLER
#ifdef MODULE_TOAST
#import "MJToast.h"
#endif
#import HEADER_ALERT

static MJControllerManager *s_controllerManager = nil;
static UIWindow *s_topWindow = nil;

// loading所依附的window
static UIWindow *s_windowLoading = nil;

#ifdef MODULE_LOADING_VIEW
static MJLoadingView *s_loadingView = nil;
#elif defined(MODULE_MBProgressHUD)
// 现实loading所用的第三方类
static MBProgressHUD *s_loadingProgress = nil;
#endif


@interface MJControllerManager ()<UIAlertViewDelegate>

@property (nonatomic, strong) NSMutableDictionary *dicForListVC;

@property (nonatomic, strong) UIView *viewShareMask;

@property (nonatomic, strong) NSMutableDictionary *dicVCs;


@end

@implementation MJControllerManager

+ (instancetype)sharedInstance
{
    if (s_controllerManager == nil) {
        s_controllerManager = [[self.class alloc] init];
    }
    return s_controllerManager;
}

- (id)init
{
    self = [super init];
    if (self) {
        _dicVCs = [[NSMutableDictionary alloc] init];
        /// 屏幕旋转
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeKeyWindow:) name:UIWindowDidBecomeKeyNotification object:nil];
    }
    return self;
}

+ (UIWindow *)mainWindow
{
    id<UIApplicationDelegate> delegate = [UIApplication sharedApplication].delegate;
    return [delegate window];
}

+ (UIWindow *)topWindow
{
    if (s_topWindow == nil) {
        [[THEControllerManager sharedInstance] changeKeyWindow:nil];
    }
    return s_topWindow;
}

#pragma mark - ViewCotroller

+ (UIViewController *)rootViewController
{
    UIViewController *tabBarVC = (UINavigationController *)self.mainWindow.rootViewController;
    return tabBarVC;
}

+ (UIViewController *)topViewController
{
    UIViewController *topVC = nil;
    UINavigationController *navVC = (UINavigationController *)self.topWindow.rootViewController;
    while (navVC.presentedViewController != nil) {
        navVC = (UINavigationController *)navVC.presentedViewController;
    }
    if ([navVC isKindOfClass:[UINavigationController class]]) {
        topVC = navVC.topViewController;
    } else {
        topVC = navVC;
    }
    
    while ([topVC isKindOfClass:[UINavigationController class]] || [topVC isKindOfClass:[UITabBarController class]]) {
        if ([topVC isKindOfClass:[UITabBarController class]]) {
            UITabBarController *tabBarVC = (UITabBarController *)topVC;
            NSInteger selectedIndex = tabBarVC.selectedIndex;
            if (selectedIndex < 0 || selectedIndex >= tabBarVC.viewControllers.count) {
                selectedIndex = 0;
            }
            topVC = [tabBarVC.viewControllers objectAtIndex:selectedIndex];
        } else {
            UINavigationController *navVC = (UINavigationController *)topVC;
            topVC = navVC.topViewController;
        }
    }
    
    return topVC;
}

+ (UIViewController *)topContainerController
{
    UIViewController *topVC = nil;
    topVC = self.topWindow.rootViewController;
    UIViewController *presentVC = topVC.presentedViewController;
    while (presentVC) {
        topVC = presentVC;
        presentVC = topVC.presentedViewController;
    }
    return topVC;
}

+ (UINavigationController *)topNavViewController
{
    UINavigationController *topVC = nil;
    topVC = (UINavigationController *)self.topWindow.rootViewController;
    UIViewController *presentVC = topVC.presentedViewController;
    while (presentVC) {
        topVC = (UINavigationController *)presentVC;
        presentVC = topVC.presentedViewController;
    }
    return topVC;
}

+ (BOOL)isInRootView
{
    UIViewController *tabBarVC = self.rootViewController;
    if ([tabBarVC presentedViewController] == nil) {
        return YES;
    }
    return NO;
}

+ (void)popToRootViewController
{
    [self popToRootViewControllerAnimated:YES];
}

+ (void)popToRootViewControllerAnimated:(BOOL)animated
{
    UINavigationController *navVC = (UINavigationController *)self.mainWindow.rootViewController;
    if (navVC.presentedViewController != nil) {
        [navVC.presentedViewController dismissViewControllerAnimated:animated completion:nil];
    }
    if (navVC.viewControllers.count > 1) {
        [navVC popToRootViewControllerAnimated:animated];
    }
    UIViewController *aVC = [navVC.viewControllers objectAtIndex:0];
    if ([aVC isKindOfClass:[UITabBarController class]]) {
        UITabBarController *aTabBarVC = (UITabBarController *)aVC;
        aVC = [aTabBarVC selectedViewController];
        if ([aVC isKindOfClass:[UINavigationController class]]) {
            navVC = (UINavigationController *)aVC;
            [navVC popToRootViewControllerAnimated:animated];
        }
    }
}

+ (UIViewController *)getViewControllerWithName:(NSString *)aVCName
{
    if (aVCName.length == 0) {
        return nil;
    }
    Class classVC = NSClassFromString(aVCName);
    if (classVC) {
        // 存在该类
        NSString *filePath = [[NSBundle mainBundle] pathForResource:aVCName ofType:@"nib"];
        UIViewController *aVC = nil;
        if (filePath.length > 0) {
            aVC = [[classVC alloc] initWithNibName:aVCName bundle:nil];
        } else {
            aVC = [[classVC alloc] init];
        }

        if (aVC) {
//            if ([aVC isKindOfClass:[DataListViewController class]]) {
//                DataListViewController *aDateListVC = (DataListViewController *)aVC;
//                DataListHandleModel *handleModel = [self getListHandleModelWith:aVCName];
//                if (handleModel) {
//                    [aDateListVC configWithData:handleModel];
//                }
//                return aDateListVC;
//            }
            return aVC;
        }
    }
    
    // 不存在该类
//    DataListHandleModel *handleModel = [self getListHandleModelWith:aVCName];
//    if (handleModel) {
//        DataListViewController *dataListVC = [[DataListViewController alloc] init];
//        [dataListVC configWithData:handleModel];
//        return dataListVC;
//    }
    
    return nil;
}

+ (__kindof UIViewController *)getUniqueViewControllerWithName:(NSString *)aVCName
{
    NSMutableDictionary *dicVCs = [[self sharedInstance] dicVCs];
    UIViewController *aVC = [dicVCs objectForKey:aVCName];
    if (aVC) {
        return aVC;
    }
    aVC = [self getViewControllerWithName:aVCName];
    if (aVC) {
        [dicVCs setObject:aVC forKey:aVCName];
    }
    return aVC;
}


/*
+ (DataListViewController *)getListViewControllerWithName:(NSString *)aListVCName
{
    DataListViewController *dataListVC = nil;
    Class classVC = NSClassFromString(aListVCName);
    if (classVC) {
        dataListVC = [[classVC alloc] initWithNibName:aListVCName bundle:nil];
        if (![dataListVC isKindOfClass:[DataListViewController class]]) {
            LogError(@" { %@ } is not kind of class { DataListViewController }", NSStringFromClass([self class]));
            return nil;
        }
    } else {
        dataListVC = [[DataListViewController alloc] init];
    }
    DataListHandleModel *handleModel = [self getListHandleModelWith:aListVCName];
    if (handleModel) {
        [dataListVC configWithData:handleModel];
    }
    return dataListVC;
}

+ (DataListHandleModel *)getListHandleModelWith:(NSString *)aListVCName
{
    return [[self sharedInstance] getListHandleModelWith:aListVCName];
}

#pragma mark -Subjoin

- (DataListHandleModel *)getListHandleModelWith:(NSString *)aListVCName
{
    DataListHandleModel *handleModel = nil;
    if (_dicForListVC == nil) {
        NSString *filePath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"dataListVC.plist"];
        _dicForListVC = [[[NSDictionary alloc] initWithContentsOfFile:filePath] mutableCopy];
    }
    id dic = [_dicForListVC objectForKey:aListVCName];
    
    if (dic) {
        if ([dic isKindOfClass:[DataListHandleModel class]]) {
            handleModel = dic;
        } else {
            @try {
                handleModel = [[DataListHandleModel alloc] initWithDictionary:dic error:nil];
            }
            @catch (NSException *exception) {
                LogError(@"%@", exception);
            }
            @finally {
                if (handleModel) {
                    [_dicForListVC setObject:handleModel forKey:aListVCName];
                }
                return handleModel;
            }
        }
    }
    return handleModel;
}
*/

#pragma mark - Share View

+ (void)showShareViewWith:(NSArray *)shareContents onView:(UIView *)aView completion:(ActionCompleteBlock)completion
{
    [self showShareViewWith:shareContents onView:aView excludedList:nil completion:completion];
}

+ (void)showShareViewWith:(NSArray *)shareContents onView:(UIView *)aView excludedList:(NSArray<UIActivityType> *)excludedList completion:(ActionCompleteBlock)completion
{
    UIActivityViewController *activityVC =
    [[UIActivityViewController alloc] initWithActivityItems:shareContents
                                      applicationActivities:nil];
    
    activityVC.excludedActivityTypes = excludedList;
    if (__CUR_IOS_VERSION >= __IPHONE_8_0) {
        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
            if (aView) {
                activityVC.popoverPresentationController.sourceView = aView;
            } else {
                activityVC.popoverPresentationController.sourceView = [[self topViewController] view];
            }
            activityVC.popoverPresentationController.sourceRect = activityVC.popoverPresentationController.sourceView.bounds;
        }
        [activityVC setCompletionWithItemsHandler: ^(NSString * __nullable activityType, BOOL completed, NSArray * __nullable returnedItems, NSError * __nullable activityError) {
            if (completed) {
                triggerEventStr(STAT_Share, @"分享成功");
                triggerEventStr(STAT_SharePlatform, activityType);
            }
            if (completion) {
                completion(completed, @"", activityType);
            }
        }];
    } else {
#if __IPHONE_OS_VERSION_MIN_REQUIRED < __IPHONE_8_0
        [activityVC setCompletionHandler:^(NSString * __nullable activityType, BOOL completed) {
            if (completed) {
                triggerEventStr(STAT_Share, @"分享成功");
                triggerEventStr(STAT_SharePlatform, activityType);
            }
            if (completion) {
                completion(completed, @"", activityType);
            }
        }];
#endif
    }
    
    [[self topNavViewController] presentViewController:activityVC
                                              animated:YES
                                            completion:^{
                                                // ...
                                                
                                            }];
}

#pragma mark - Utils


+ (void)alertMsg:(NSString *)massage
{
    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:nil message:massage delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alertView show];
}

+ (void)alert:(NSString *)title message:(NSString *)massage
{
    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:title message:massage delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alertView show];
}

+ (void)toast:(NSString *)str
{
    if(str.length == 0) {
        return;
    }
    NSLog(@"Toast : %@", str);
#ifdef MODULE_TOAST
    MJToast *toast = [MJToast makeToast:str];
    [toast show];
#endif
}


#pragma mark - Loading

#ifdef MODULE_LOADING_VIEW
+ (NSInteger)startLoading:(NSString *)labelText
{
    if(labelText.length == 0) {
        labelText = @"Loading...";
    }
    LogTrace(@"{Loading} start");
    [self loadingWindow];
    MJLoadingView *viewLoading = [self loadingView];
    return [viewLoading startLoading:labelText];
}

+ (NSInteger)startLoading:(NSString *)labelText detailText:(NSString *)detailText
{
    return [self startLoading:[labelText stringByAppendingFormat:@"\n%@", detailText]];
}

+ (void)setLoadingRequestId:(NSString *)requestId needCancel:(BOOL)needCancel atIndex:(NSInteger)aIndex
{
    MJLoadingView *viewLoading = [self loadingView];
    [viewLoading setLoadingRequestId:requestId needCancel:needCancel atIndex:aIndex];
}

+ (void)stopLoading
{
    LogTrace(@"{Loading} stop");
    MJLoadingView *viewLoading = [self loadingView];
    
    [viewLoading stopAllLoading];
    
}

+ (void)stopLoadingAtIndex:(NSInteger)aIndex
{
    LogTrace(@"{Loading} stop");
    MJLoadingView *viewLoading = [self loadingView];
    
    [viewLoading stopLoadingAtIndex:aIndex];
}

+ (void)stopAllLoading
{
    LogTrace(@"{Loading} stop");
    MJLoadingView *viewLoading = [self loadingView];
    
    [viewLoading stopAllLoading];
    
}
#elif defined(MODULE_MBProgressHUD)
#pragma mark -MBProgressHUD
+ (NSInteger)startLoading:(NSString *)labelText
{
    return [self startLoading:labelText detailText:nil];
}

+ (NSInteger)startLoading:(NSString *)labelText detailText:(NSString *)detailText
{
    if(labelText.length == 0) {
        labelText = @"Loading";
    }
    LogTrace(@"{Loading} start");
    MBProgressHUD *theProgress = [self loadingProgress];
    theProgress.labelText = labelText;
    theProgress.detailsLabelText = detailText;
    theProgress.completionBlock = ^(){
        [self hideLoadingWindow];
    };
    [[self loadingWindow] addSubview:theProgress];
    [theProgress show:YES];
    return 0;
}

+ (void)stopLoading
{
    LogTrace(@"{Loading} hide");
    MBProgressHUD *theProgress = [self loadingProgress];
    theProgress.removeFromSuperViewOnHide = YES;
    [theProgress hide:YES];
}

#else
+ (NSInteger)startLoading:(NSString *)labelText
{
    LogTrace(@"Start Loading : %@", labelText);
    return 0;
}
+ (NSInteger)startLoading:(NSString *)labelText detailText:(NSString *)detailText
{
    LogTrace(@"Start Loading : %@ , detail : %@", labelText, detailText);
    return 0;
}
+ (void)stopLoading
{
    
}
#endif

#pragma mark -Windows

+ (UIWindow *)loadingWindow
{
    if (s_windowLoading == nil) {
        s_windowLoading = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
        [s_windowLoading setBackgroundColor:[UIColor clearColor]];
        s_windowLoading.windowLevel = UIWindowLevelAlert - 100;
        [s_windowLoading makeKeyAndVisible];
        [s_windowLoading setRootViewController:[[THEWindowRootViewController alloc] init]];
        [THEControllerManager sharedInstance];
    }
    return s_windowLoading;
}

+ (void)hideLoadingWindow
{
    LogTrace(@"{Loading} hide");
    [s_windowLoading resignKeyWindow];
    [s_windowLoading setHidden:YES];
    s_windowLoading = nil;
}

#ifdef MODULE_LOADING_VIEW
+ (MJLoadingView *)loadingView
{
    if (s_loadingView == nil) {
        s_loadingView = [[MJLoadingView alloc] initWithFrame:[[self loadingWindow] bounds]  andType:LOADING_COMMON_TYPE];
        s_loadingView.btnBack.enabled = YES;
        [s_loadingView setAutoresizingMask:UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight];
        s_loadingView.completionBlock = ^(){
            [s_loadingView removeFromSuperview];
            [self hideLoadingWindow];
        };
    }
    if (s_loadingView.superview == nil) {
        [s_loadingView setFrame:[[self loadingWindow] bounds]];
        [s_loadingView setAutoresizingMask:UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight];
        [[self loadingWindow] addSubview:s_loadingView];
    }
    return s_loadingView;
}
#elif defined(MODULE_MBProgressHUD)
+ (MBProgressHUD *)loadingProgress
{
    if (s_loadingProgress == nil) {
        s_loadingProgress = [[MBProgressHUD alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
        s_loadingProgress.delegate = (NavigationViewController *)[self topNavViewController];
        s_loadingProgress.completionBlock = ^(){
            [self hideLoadingWindow];
        };
        [[self loadingWindow] addSubview:s_loadingProgress];
    }
    return s_loadingProgress;
}
#endif


#pragma mark - Notification Receive

- (void)changeKeyWindow:(NSNotification *)note
{
    id<UIApplicationDelegate> delegate = [UIApplication sharedApplication].delegate;
    UIWindow *mainWindow = [delegate window];
    UIWindow *topWindow = [[UIApplication sharedApplication] keyWindow];
    if (topWindow != mainWindow) {
        NSArray *arrWindows = [[UIApplication sharedApplication].windows sortedArrayUsingComparator:^NSComparisonResult(UIWindow *win1, UIWindow *win2) {
            return win1.windowLevel - win2.windowLevel;
        }];
        for (NSInteger i = arrWindows.count - 1; i >=0 ; i--) {
            UIWindow *aWindow = arrWindows[i];
            if (![aWindow isKindOfClass:NSClassFromString(@"UITextEffectsWindow")]
                && aWindow.windowLevel <= UIWindowLevelNormal + 10
                && aWindow.rootViewController
                && !aWindow.rootViewController.view.isHidden) {
                topWindow = aWindow;
                break;
            }
        }
    }
    s_topWindow = topWindow;
}

@end
