//
//  DetailViewController.h
//  AePubReader
//
//  Created by Federico Frappi on 04/04/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZipArchive.h"
#import "EPub.h"
#import "Chapter.h"
#import "EpubRecord.h"
#import "EpubRecordManager.h"

@class SearchResultsViewController;
@class SearchResult;

@interface EPubViewController : UIViewController <UIWebViewDelegate, ChapterDelegate, UISearchBarDelegate,UIGestureRecognizerDelegate> {
    
    UIToolbar *toolbar;
    
    UIBarButtonItem* chapterListButton;
	
	UIBarButtonItem* decTextSizeButton;
	UIBarButtonItem* incTextSizeButton;
    
    UISlider* pageSlider;
    UILabel* currentPageLabel;
    UIButton *tabBarView;
    
	EPub* loadedEpub;
	int currentSpineIndex; //当前epubSpine
	int currentPageInSpineIndex; //当前Spine中得页码
	int pagesInCurrentSpineCount; //当前Spine的总页数
	int currentTextSize; //当前字体大小
	int totalPagesCount; //总页数
    int pageNum; //当前阅读的页数
    
    /**
     * 后加
     */
    NSURL *currentUrl;
    float pageOffsetNumber;
    
    BOOL epubLoaded;
    BOOL paginating;
    BOOL searching;
    BOOL isflag;
    CGFloat viewWidth;
    
    UIViewController *parentVc;
    
    UIPopoverController* chaptersPopover;
    UIPopoverController* searchResultsPopover;
    
    SearchResultsViewController* searchResViewController;
    SearchResult* currentSearchResult;
}

- (void) increaseTextSizeClicked:(id)sender;
- (void) decreaseTextSizeClicked:(id)sender;
- (void) slidingStarted:(id)sender;
- (void) slidingEnded:(id)sender;
//- (void) doneClicked:(id)sender;

- (void) loadSpine:(int)spineIndex atPageIndex:(int)pageIndex highlightSearchResult:(SearchResult*)theResult;

//- (void) loadEpub:(NSURL*) epubURL;

//- (void)openBook:(NSString *)bookPath atView:(UIView *)view withPageFrame:(CGRect)pageFrame;


- (void)openBook:(NSString *)bookPath atView:(UIView *)view withPageFrame:(CGRect)pageFrame  parentController:(UIViewController *) _parentVc;

@property (nonatomic, retain) EPub* loadedEpub;

@property (nonatomic, retain) SearchResult* currentSearchResult;

@property (nonatomic, retain)  UIToolbar *toolbar;

@property (nonatomic, retain)  UIWebView *webView;

@property (nonatomic, retain)  UIBarButtonItem *chapterListButton;

@property (nonatomic, retain)  UIBarButtonItem *decTextSizeButton;
@property (nonatomic, retain)  UIBarButtonItem *incTextSizeButton;

@property (nonatomic, retain)  UISlider *pageSlider;
@property (nonatomic, retain)  UILabel *currentPageLabel;

@property(strong,nonatomic)UIPageViewController * pageController;

@property BOOL searching;

@end
