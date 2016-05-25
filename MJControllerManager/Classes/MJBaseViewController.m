//
//  MJBaseViewController.m
//  Common
//
//  Created by 黄磊 on 16/4/6.
//  Copyright © 2016年 Musjoy. All rights reserved.
//

#import "MJBaseViewController.h"
#ifdef MODULE_UM_ANALYSE
#import HEADER_UM_ANALYSE
#endif

@interface MJBaseViewController ()

@end

@implementation MJBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
#ifdef kAppActiveColor
    [self.view setTintColor:kAppActiveColor];
#endif
}


- (void)viewWillAppear:(BOOL)animated
{
    LogTrace(@"   >>>>>>{ %@ } will appear", NSStringFromClass([self class]));
    [super viewWillAppear:animated];
    if (!_isViewHadShow) {
        // 解决部分界面第一次显示ScrollView显示异常问题
        if (__CUR_IOS_VERSION < __IPHONE_9_0) {
            [self.navigationController setNavigationBarHidden:YES animated:NO];
            [self.navigationController setNavigationBarHidden:NO animated:NO];
        }
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    LogTrace(@"   >>>>>>{ %@ } did appear", NSStringFromClass([self class]));
    [super viewDidAppear:animated];
    triggerBeginPage(NSStringFromClass([self class]));
    _isViewShow = YES;
    _isViewHadShow = YES;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
}

- (void)viewWillDisappear:(BOOL)animated
{
    LogTrace(@"<<<<<<{ %@ } will disappear", NSStringFromClass([self class]));
    _isViewShow = NO;
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillChangeFrameNotification object:nil];
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    LogTrace(@"<<<<<<{ %@ } did disappear", NSStringFromClass([self class]));
    triggerEndPage(NSStringFromClass([self class]));
    [super viewDidDisappear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Overwrite

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    if (_lytTop) {
        _lytTop.constant = self.topLayoutGuide.length;
    }
    if (_lytBottom) {
        _lytBottom.constant = self.bottomLayoutGuide.length;
    }
    if (__CUR_IOS_VERSION < __IPHONE_9_0) {
        [self.view layoutIfNeeded];
    }
}

#pragma mark - Keyboard

- (void)keyboardWillChangeFrame:(NSNotification *)notification
{
    NSDictionary *userInfo = [notification userInfo];
    NSNumber *duration = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    if ([duration doubleValue] > 0) {
        NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
        CGRect keyboardRect = [aValue CGRectValue];
        if (keyboardRect.origin.y >= kScreenHeight - 5) {
            // 键盘隐藏
            LogTrace(@" %@ keyboard will hide", NSStringFromClass([self class]));
            [self keyboardWillHide:notification];
        } else {
            // 键盘显示
            LogTrace(@" %@ keyboard will show", NSStringFromClass([self class]));
            [self keyboardWillShow:notification];
        }
    } else {
        // 键盘高度变化，以后可修改为另一个方法
        LogTrace(@" %@ keyboard change size", NSStringFromClass([self class]));
        [self keyboardWillShow:notification];
    }
}

- (void)keyboardWillShow:(NSNotification *)notification
{
    
}

- (void)keyboardWillHide:(NSNotification *)notification
{
    
}


#pragma mark -

- (BOOL)shouldAutorotate
{
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        return NO;
    }
    return YES;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        return UIInterfaceOrientationMaskPortrait;
    }
    return UIInterfaceOrientationMaskAll;
}

//- (BOOL)prefersStatusBarHidden
//{
//    return YES;
//}

@end
