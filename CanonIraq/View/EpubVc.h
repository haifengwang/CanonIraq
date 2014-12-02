//
//  EpubVc.h
//  CanonIraq
//
//  Created by onskyline on 14-5-20.
//  Copyright (c) 2014年 onskyline. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EPubViewController.h"
#import "AppConfig.h"
#import "BaseViewController.h"


@interface EpubVc : BaseViewController<UIGestureRecognizerDelegate>
{
    BOOL isflage; //用于设置导航隐藏显示
}

//@property (strong, nonatomic) EPubController *epubController;

@property(strong,nonatomic)EPubViewController *epubViewVc;

@end
