//
//  MJNavigationController.m
//  Common
//
//  Created by 黄磊 on 16/4/6.
//  Copyright © 2016年 Musjoy. All rights reserved.
//

#import "MJNavigationController.h"
#import "MJBaseViewController.h"
#include <objc/message.h>
#ifdef MODULE_UTILS
#import "Utils.h"
#endif

#define BACK_ITEM_TAG 1000

@implementation UIViewController (MJNavigationController)


- (MJNavigationController *)navController
{
    UIViewController *viewController = self.parentViewController;
    while (!(viewController == nil || [viewController isKindOfClass:[MJNavigationController class]]))
    {
        viewController = viewController.parentViewController;
    }
    
    return (MJNavigationController *)viewController;
}

- (BOOL)canSlipOut
{
    return YES;
}

- (BOOL)canSlipIn
{
    return YES;
}


@end

@interface MJNavigationController ()

@end

@implementation MJNavigationController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)initWithRootViewController:(UIViewController *)rootViewController
{
    self = [super initWithRootViewController:rootViewController];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
#ifdef kNavBgColor
    [self.navigationBar setBarTintColor:kNavBgColor];
#endif
    [self.navigationBar setTintColor:kNavActiveColor];

    [self.navigationBar setTranslucent:YES];

    self.interactivePopGestureRecognizer.delegate = self;
    
    NSShadow *shadow = [[NSShadow alloc] init];
    shadow.shadowColor = [UIColor clearColor];
    shadow.shadowOffset = CGSizeMake(0, 0);
    NSDictionary *textAttr = [NSDictionary dictionaryWithObjectsAndKeys:
                              kNavActiveColor, NSForegroundColorAttributeName,
                              //                              kAppActiveColor, NSForegroundColorAttributeName,
                              //                              [UIFont fontWithName:@"JXiHei" size:17], TextAttributeFont,
                              //                              [UIFont boldSystemFontOfSize:17], TextAttributeFont,
                              shadow, NSShadowAttributeName,nil];
    self.navigationBar.titleTextAttributes = textAttr;
}


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    _isViewShow = YES;
    _isViewHadShow = YES;
}

-(void)viewWillDisappear:(BOOL)animated
{
    _isViewShow = NO;
    [super viewWillDisappear:animated];
}

-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)showBackButtonWith:(UIViewController *)viewController
{
    UIBarButtonItem *leftItem = [self createButtonWith:self action:@selector(back)];
    [viewController.navigationItem setLeftBarButtonItem:leftItem animated:YES];
}

- (void)showBackButtonWith:(UIViewController *)viewController andAction:(SEL)action
{
    UIBarButtonItem *leftItem = [self createButtonWith:viewController action:action];
    [viewController.navigationItem setLeftBarButtonItem:leftItem animated:YES];
}

- (UIBarButtonItem *)showLeftButtonWith:(UIViewController *)viewController image:(UIImage *)image action:(SEL)action
{
    UIButton* btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn addTarget:viewController action:action forControlEvents:UIControlEventTouchUpInside];
    btn.frame = CGRectMake(0, 5, 30, 35);
    [btn setImage:image forState:UIControlStateNormal];
    UIBarButtonItem* leftItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
    [viewController.navigationItem setLeftBarButtonItem:leftItem];
    return leftItem;
}

- (UIBarButtonItem *)showRightButtonWith:(UIViewController *)viewController title:(NSString*)title action:(SEL)action
{
    UIButton* btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn addTarget:viewController action:action forControlEvents:UIControlEventTouchUpInside];
    btn.frame = CGRectMake(250, 5, 56, 30);
    [btn setTitle:title forState:UIControlStateNormal];
    [btn.titleLabel setFont:[UIFont systemFontOfSize:18]];
    UIBarButtonItem* rightItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
    [viewController.navigationItem setRightBarButtonItem:rightItem];
    return rightItem;
}

- (UIBarButtonItem *)showRightButtonWith:(UIViewController *)viewController image:(UIImage *)image action:(SEL)action
{
    
    UIButton* btn = [UIButton buttonWithType:UIButtonTypeSystem];
    [btn addTarget:viewController action:action forControlEvents:UIControlEventTouchUpInside];
    btn.frame = CGRectMake(270, 5, 30, 35);
    [btn setImage:image forState:UIControlStateNormal];
    UIBarButtonItem* rightItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
    [viewController.navigationItem setRightBarButtonItem:rightItem];
    return rightItem;
}




- (UIBarButtonItem *)createButtonWith:(id)target action:(SEL)action
{
    // 设置返回键
    UIBarButtonItem *backNav = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"nav_back"] style:UIBarButtonItemStylePlain target:target action:action];
    return backNav;
}


- (BOOL)back
{
    if (self.viewControllers.count > 1) {
        if ([[self.viewControllers lastObject] isViewHadShow]) {
            [self popViewControllerAnimated:YES];
            return YES;
        }
    } else {
        [self dismissViewControllerAnimated:YES completion:nil];
        return YES;
    }
    return NO;
}

- (BOOL)clickLeftItem
{
    UIViewController *aVC = self.topViewController;
    if (self.viewControllers.count > 0) {
        if ([[self.viewControllers lastObject] isViewHadShow]) {
            if (!aVC.navigationItem.hidesBackButton) {
                return [self back];
            }
            UIBarButtonItem *leftItem = aVC.navigationItem.leftBarButtonItem;
            if (leftItem.tag == BACK_ITEM_TAG) {
                return [self back];
            }
        }
    }
    return NO;
}


-(void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
//    if (self.topViewController && ![self.topViewController isViewHadShow]) {
//        LogError(@"Cann't push view controller { %@ }, when the top view controller is not show",  NSStringFromClass([viewController class]));
//        return;
//    }
    if (self.viewControllers.count == 1) {
        if ([[self.viewControllers objectAtIndex:0] isKindOfClass:[UITabBarController class]]) {
            UITabBarController *theTabBarVC = (UITabBarController *)[self.viewControllers objectAtIndex:0];
            UINavigationController *aNavVC = (UINavigationController *)theTabBarVC.selectedViewController;
            if ([aNavVC isKindOfClass:[UINavigationController class]] && ![aNavVC isNavigationBarHidden]) {
                [self setNavigationBarHidden:NO animated:NO];
            } else {
                [self setNavigationBarHidden:NO animated:YES];
            }
        }
    }
    [super pushViewController:viewController animated:animated];
}

- (UIViewController *)popViewControllerAnimated:(BOOL)animated
{
    UIViewController *aVC = self.topViewController;
    if (![aVC respondsToSelector:@selector(isViewHadShow)]) {
        return [super popViewControllerAnimated:YES];
    } else {
        MJBaseViewController *baseVC = (MJBaseViewController *)aVC;
        if ([baseVC isViewHadShow]) {
            return [super popViewControllerAnimated:YES];
        }
    }
    return nil;
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    if (self.viewControllers.count == 1) {             //关闭主界面的右滑返回
        return NO;
    } else {
        UIViewController *lastVC = self.viewControllers.lastObject;
        UIViewController *secondLastVC = self.viewControllers[self.viewControllers.count-2];
        if ([lastVC canSlipOut] && [secondLastVC canSlipIn]) {
            return YES;
        } else {
            return NO;
        }
    }
}

-(BOOL)shouldAutorotate
{
    return [self.topViewController shouldAutorotate];
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations NS_AVAILABLE_IOS(6_0)
{
    return [[self topViewController] supportedInterfaceOrientations];
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
{
    return [[self topViewController] preferredInterfaceOrientationForPresentation];
}


@end
