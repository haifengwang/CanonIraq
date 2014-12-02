//
//  AppDelegate.h
//  CanonIraq
//
//  Created by onskyline on 14-5-13.
//  Copyright (c) 2014年 ___FULLUSERNAME___. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Reachability.h"
#import "BookCoverViewController.h"
#import "HeadNaviViewController.h"

@interface CanonIraqDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
//自定一个根视图控制器
@property(retain,nonatomic)BookCoverViewController *coverBookVc;

    //导航
@property(retain,nonatomic)HeadNaviViewController *headNaviVc;

@end
