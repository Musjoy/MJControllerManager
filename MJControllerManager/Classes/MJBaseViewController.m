//
//  MJBaseViewController.m
//  Common
//
//  Created by 黄磊 on 16/4/6.
//  Copyright © 2016年 Musjoy. All rights reserved.
//

#import "MJBaseViewController.h"
#ifdef HEADER_ANALYSE
#import HEADER_ANALYSE
#endif

@interface MJBaseViewController ()

@end

@implementation MJBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self reloadTheme];
    
#ifdef MODULE_THEME_MANAGER
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadTheme) name:kNoticThemeChanged object:nil];
#endif
    
    // 配置lytTop和lytBottom
    BOOL needLayout = NO;
    if (_lytTop) {
        NSObject *topLayout = self.topLayoutGuide;
        UIView *theView = _lytTop.firstItem;
        if (theView == self.view) {
            theView = _lytTop.secondItem;
        }
        NSLayoutConstraint *theLyt = [NSLayoutConstraint constraintWithItem:topLayout attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:theView attribute:NSLayoutAttributeTop multiplier:1 constant:0];
        [self.view removeConstraint:_lytTop];
        [self.view addConstraint:theLyt];
        _lytTop = theLyt;
        needLayout = YES;
    }
    if (_lytBottom) {
        NSObject *bottomLayout = self.bottomLayoutGuide;
        UIView *theView = _lytBottom.firstItem;
        if (theView == self.view) {
            theView = _lytBottom.secondItem;
        }
        NSLayoutConstraint *theLyt = [NSLayoutConstraint constraintWithItem:theView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:bottomLayout attribute:NSLayoutAttributeTop multiplier:1 constant:0];
        [self.view removeConstraint:_lytBottom];
        [self.view addConstraint:theLyt];
        _lytBottom = theLyt;
        needLayout = YES;
    }
    if (needLayout) {
        [self.view layoutIfNeeded];
    }
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


#pragma mark - Layout

- (void)alignTopView:(UIView *)aTopView
{
    NSObject *topLayout = self.topLayoutGuide;
    NSLayoutConstraint *theLyt = [NSLayoutConstraint constraintWithItem:topLayout attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:aTopView attribute:NSLayoutAttributeTop multiplier:1 constant:0];
    [self.view addConstraint:theLyt];
    if (_lytTop == nil) {
        _lytTop = theLyt;
    }
}

- (void)alignBottomView:(UIView *)aBottomView
{
    NSObject *bottomLayout = self.bottomLayoutGuide;
    NSLayoutConstraint *theLyt = [NSLayoutConstraint constraintWithItem:aBottomView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:bottomLayout attribute:NSLayoutAttributeTop multiplier:1 constant:0];
    [self.view addConstraint:theLyt];
    if (_lytBottom == nil) {
        _lytBottom = theLyt;
    }

}



#pragma mark - Theme

- (void)reloadTheme
{
#ifdef MODULE_THEME_MANAGER
    UIColor *bgColor = [MJThemeManager colorFor:kThemeBgColor];
    if (bgColor) {
        self.view.backgroundColor = bgColor;
    }
    UIColor *mainColor = [MJThemeManager colorFor:kThemeMainColor];
    if (mainColor) {
        [self.view setTintColor:mainColor];
    }
    UIImage *imgBg = [MJThemeManager curBgImage];
    if (imgBg) {
        self.view.layer.contents = (__bridge id _Nullable)(imgBg.CGImage);
    } else {
        self.view.layer.contents = nil;
    }
    
    // tableView自动加载
    if ([self respondsToSelector:@selector(tableView)]) {
        UITableView *aTableView = [self valueForKey:@"tableView"];
        [self reloadThemeForTableView:aTableView];
    }
#else
    self.view.backgroundColor = [UIColor whiteColor];
#ifdef kAppActiveColor
    [self.view setTintColor:kAppActiveColor];
#endif
#endif
}

- (void)reloadThemeForTableView:(UITableView *)aTableView
{
#ifdef MODULE_THEME_MANAGER
    if (aTableView == nil) {
        return;
    }
    // Cell处理
    [aTableView setSeparatorColor:[MJThemeManager colorFor:kThemeCellLineColor]];
    NSArray *arrCells = [aTableView visibleCells];
    NSMutableDictionary *arrCacheCells = (NSMutableDictionary*)[aTableView valueForKey:@"_reusableTableCells" ];
    [arrCacheCells removeAllObjects];
    for (UITableViewCell *aCell in arrCells) {
        if ([aCell respondsToSelector:@selector(reloadTheme)]) {
            [aCell reloadTheme];
        }
    }
    // Loading处理
#ifdef MODULE_UTILS
    UIColor *refreshColor = [MJThemeManager colorFor:kThemeRefreshColor];
    if (aTableView.header) {
        [aTableView.header setTintColor:refreshColor];
    }
    if (aTableView.footer) {
        [aTableView.footer setTintColor:refreshColor];
    }
#endif
#else
#endif
}

- (void)reloadThemeForCollectionView:(UICollectionView *)aCollectionView
{
#ifdef MODULE_THEME_MANAGER
    if (aCollectionView == nil) {
        return;
    }
    // Cell处理
    NSArray *arrCells = [aCollectionView visibleCells];
    NSMutableDictionary *arrCacheCells = (NSMutableDictionary*)[aCollectionView valueForKey:@"_cellReuseQueues" ];
    [arrCacheCells removeAllObjects];
    for (UITableViewCell *aCell in arrCells) {
        if ([aCell respondsToSelector:@selector(reloadTheme)]) {
            [aCell reloadTheme];
        }
    }
    // Loading处理
#ifdef MODULE_UTILS
    UIColor *refreshColor = [MJThemeManager colorFor:kThemeRefreshColor];
    if (aCollectionView.header) {
        [aCollectionView.header setTintColor:refreshColor];
    }
    if (aCollectionView.footer) {
        [aCollectionView.footer setTintColor:refreshColor];
    }
#endif
#else
#endif
}

#pragma mark - Loading

#ifdef MODULE_LOADING_VIEW

- (MJLoadingView *)loadingView
{
    if (self.viewInnerLoading == nil) {
        self.viewInnerLoading = [[MJLoadingView alloc] initWithFrame:self.view.bounds];
        self.viewInnerLoading.hidden = YES;
        [self.viewInnerLoading setAutoresizingMask:UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight];
        [self.view addSubview:self.viewInnerLoading];
    }
    return self.viewInnerLoading;
}

- (NSInteger)startInnerLoading:(NSString *)loadingText
{
    if(loadingText.length == 0) {
        loadingText = @"Loading...";
    }
    MJLoadingView *viewLoading = [self loadingView];
    [self.view bringSubviewToFront:viewLoading];
    return [viewLoading startLoading:loadingText];
}

- (void)startInnerLoading:(NSString *)loadingText withBlock:(NSString *(^)(NSInteger))block
{
    if(loadingText.length == 0) {
        loadingText = @"Loading...";
    }
    MJLoadingView *viewLoading = [self loadingView];
    [self.view bringSubviewToFront:viewLoading];
    
    NSInteger aIndex = [viewLoading startLoading:loadingText];
    
    NSString *requestId = block(aIndex);
    if (requestId.length > 0) {
        [viewLoading setLoadingRequestId:requestId needCancel:NO atIndex:aIndex];
    }
}

- (void)setInnerLoadingRequestId:(NSString *)requestId atIndex:(NSInteger)aIndex
{
    MJLoadingView *viewLoading = [self loadingView];
    [viewLoading setLoadingRequestId:requestId needCancel:NO atIndex:aIndex];
}

- (void)stopInnerLoading
{
    MJLoadingView *viewLoading = [self loadingView];
    [viewLoading stopLoading];
}

- (void)stopInnerLoadingAtIndex:(NSInteger)aIndex
{
    MJLoadingView *viewLoading = [self loadingView];
    [viewLoading stopLoadingAtIndex:aIndex];
}

#endif

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

- (BOOL)prefersStatusBarHidden
{
    return NO;
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
#ifdef MODULE_THEME_MANAGER
    return [MJThemeManager curStatusStyle];
#else
    return UIStatusBarStyleDefault;
#endif
}


#pragma mark - 

- (void)dealloc
{
#ifdef MODULE_THEME_MANAGER
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kNoticThemeChanged object:nil];
#endif
}

@end
