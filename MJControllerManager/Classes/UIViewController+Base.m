//
//  UIViewController+Base.m
//  Common
//
//  Created by 黄磊 on 16/5/31.
//  Copyright © 2016年 Musjoy. All rights reserved.
//

#import "UIViewController+Base.h"

@implementation UIViewController (Base)


- (void)alertMsg:(NSString *)message
{
    [THEControllerManager alertMsg:message];
}

- (void)alert:(NSString *)title message:(NSString *)message
{
    [THEControllerManager alert:title message:message];
}

- (void)startLoading:(NSString *)labelText
{
    [THEControllerManager startLoading:labelText];
}

- (void)startLoading:(NSString *)labelText detailText:(NSString *)detailText
{
    [THEControllerManager startLoading:labelText detailText:detailText];
}

- (void)stopLoading
{
    [THEControllerManager stopLoading];
}

- (void)toast:(NSString *)str
{
    [THEControllerManager toast:str];
}


@end
