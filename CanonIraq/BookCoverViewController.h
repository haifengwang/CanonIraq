//
//  BookCoverViewController.h
//  CanonIraq
//
//  Created by onskyline on 14-5-13.
//  Copyright (c) 2014年 onskyline. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CJSONDeserializer.h"
#import "ASIHTTPRequest.h"
#import "ASINetworkQueue.h"
#import "EpubVc.h"
#import "JsonSingle.h"
#import "BaseViewController.h"


@interface BookCoverViewController : BaseViewController
{
    BOOL failed;
    float currentProgress;
}


//阅读视图控制器属性
@property(retain,nonatomic)EpubVc *epubVc;



@end
