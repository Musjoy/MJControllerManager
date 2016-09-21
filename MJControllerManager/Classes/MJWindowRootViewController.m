//
//  MJWindowRootViewController.m
//  Common
//
//  Created by 黄磊 on 2016/9/21.
//  Copyright © 2016年 Musjoy. All rights reserved.
//

#import "MJWindowRootViewController.h"
#import HEADER_CONTROLLER_MANAGER

@interface MJWindowRootViewController ()

@end

@implementation MJWindowRootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (BOOL)shouldAutorotate
{
    return [[THEControllerManager topViewController] shouldAutorotate];
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return [[THEControllerManager topViewController] supportedInterfaceOrientations];
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return [[THEControllerManager topViewController] preferredStatusBarStyle];
}

- (BOOL)prefersStatusBarHidden
{
    return [[THEControllerManager topViewController] prefersStatusBarHidden];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
