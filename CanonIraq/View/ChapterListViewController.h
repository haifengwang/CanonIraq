//
//  ChapterListViewController.h
//  AePubReader
//
//  Created by Federico Frappi on 04/05/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EPubViewController.h"
#import "../AppConfig.h"

@interface ChapterListViewController : UITableViewController {
    EPubViewController* epubViewController;
    UIButton *btnBack;
}

@property(nonatomic, assign) EPubViewController* epubViewController;

@end
