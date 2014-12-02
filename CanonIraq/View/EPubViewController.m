//
//  DetailViewController.m
//  CanonIraq PubReader
//
//  Created by onskyline on 04/04/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "EPubViewController.h"
#import "ChapterListViewController.h"
#import "SearchResultsViewController.h"
#import "SearchResult.h"
#import "UIWebView+SearchWebView.h"
#import "Chapter.h"
#import "MBProgressHUD.h"
#import "UIImage+Addition.h"
#import "AppConfig.h"

#define SetNavImage(A) [UIImage scaleImage:[UIImage imageNamed:A] toRatio:2]


@interface EPubViewController()<UIPageViewControllerDataSource>

@property (strong, readonly) UIView *epubParentView;

- (void) gotoNextSpine;
- (void) gotoPrevSpine;
- (void) gotoNextPage;
- (void) gotoPrevPage;

- (int) getGlobalPageCount;

- (void) gotoPageInCurrentSpine: (int)pageIndex;
- (void) updatePagination;

- (void) loadSpine:(int)spineIndex atPageIndex:(int)pageIndex;

@property (nonatomic,retain) EpubRecord *record;
@property (nonatomic,retain) EpubRecordManager *recordManager;

@end

@implementation EPubViewController

@synthesize loadedEpub, toolbar, webView;
@synthesize chapterListButton, decTextSizeButton, incTextSizeButton;
@synthesize currentPageLabel, pageSlider, searching;
@synthesize currentSearchResult,pageController;


#pragma mark - Loading

- (void)showLoadingView
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.epubParentView animated:YES];
    [hud setDimBackground:YES];
    [hud setLabelText:@"请稍等..."];
    [hud setOpacity:0.4];
}

- (void)hideLoadingView
{
    [MBProgressHUD hideAllHUDsForView:self.epubParentView animated:YES];
}


#pragma mark -
#pragma mark 初始化视图

-(void)initLoadView:(UIView *) parentView withPageFrame:(CGRect)pageFrame parentController:(UIViewController *) _parentVc

{
//    NSLog(@"执行初始化 %s,%d",__FUNCTION__,__LINE__);
    self.webView = [[UIWebView alloc] initWithFrame:pageFrame];
    [_epubParentView addSubview:self.webView];
    self.webView.backgroundColor=[UIColor clearColor];
//     NSLog(@"initLoadView webView frame=%@",NSStringFromCGRect(webView.frame));
    [self.webView release];
    webView.delegate=self;
//    NSLog(@"_epubParentView frame=%@",NSStringFromCGRect(_epubParentView.frame));
    viewWidth=self.webView.bounds.size.width;
    parentVc=_parentVc;
    [self initNavigationitem:parentVc];
    parentVc.navigationController.navigationBar.hidden=YES;
    UIScrollView* sv = nil;
    for (UIView* v in  webView.subviews) {
        if([v isKindOfClass:[UIScrollView class]]){
            sv = (UIScrollView*) v;
            sv.scrollEnabled = NO;
            sv.bounces = NO;
        }
    }
    
    CGSize parentSize=_epubParentView.frame.size;
    self.currentPageLabel=[[UILabel alloc]initWithFrame:CGRectMake(parentSize.width-70, parentSize.height-40, 80, 20)];
    currentPageLabel.textAlignment = NSTextAlignmentCenter;
    currentPageLabel.adjustsFontSizeToFitWidth=YES; //调整基线位置需将此属性设置为YES
    currentPageLabel.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
    [currentPageLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:12]];
    [currentPageLabel setTextColor:[UIColor grayColor]];

//    currentPageLabel.backgroundColor=[UIColor redColor];
//    NSLog(@"label frame=%@",NSStringFromCGRect(currentPageLabel.frame));
    [_epubParentView addSubview:self.currentPageLabel];
    [self.currentPageLabel release];
    
    CGRect sliderRect=CGRectMake(20, parentSize.height-40, parentSize.width-100, 20);
    pageSlider=[[UISlider alloc]initWithFrame:sliderRect];
    [pageSlider setThumbImage:[UIImage imageNamed:@"slider.png"] forState:UIControlStateNormal];
	[pageSlider setMinimumTrackImage:[[UIImage imageNamed:@"orangeSlide.png"] stretchableImageWithLeftCapWidth:10 topCapHeight:0] forState:UIControlStateNormal];
	[pageSlider setMaximumTrackImage:[[UIImage imageNamed:@"yellowSlide.png"] stretchableImageWithLeftCapWidth:10 topCapHeight:0] forState:UIControlStateNormal];
    //拖动前事件
    [pageSlider addTarget:self action:@selector(slidingStarted:) forControlEvents:UIControlEventValueChanged];
    //拖动后事件
    [pageSlider addTarget:self action:@selector(slidingEnded:) forControlEvents:UIControlEventTouchUpInside];
    
    [_epubParentView addSubview:pageSlider];
    pageSlider.hidden=YES;
    [pageSlider release];
    
    
    //显示目录view
    tabBarView = [UIButton buttonWithType:UIButtonTypeCustom] ;//initWithFrame:CGRectMake(0, self.webView.frame.size.height/2, 50 , 50)] ;
    tabBarView.frame=CGRectMake(0, self.webView.frame.size.height/2, 30 , 50) ;

    [tabBarView setImage:[UIImage imageNamed:@"holderBtn.png"] forState:UIControlStateNormal];
    tabBarView.hidden=YES;
    [tabBarView addTarget:self action:@selector(showCatalogue:) forControlEvents:UIControlEventTouchDown];
    [_epubParentView addSubview:tabBarView];
   
//    [_epubParentView insertSubview:catalogBtn aboveSubview:webView];
    
    
    UISwipeGestureRecognizer* rightSwipeRecognizer = [[[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(gotoNextPage)] autorelease];
    [rightSwipeRecognizer setDirection:UISwipeGestureRecognizerDirectionLeft];
    
    UISwipeGestureRecognizer* leftSwipeRecognizer = [[[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(gotoPrevPage)] autorelease];
    [leftSwipeRecognizer setDirection:UISwipeGestureRecognizerDirectionRight];
    
    UITapGestureRecognizer *tapGesture=[[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(showNavBar:)]autorelease];
    
    tapGesture.delegate = self;
    tapGesture.cancelsTouchesInView = NO;
    
    [webView addGestureRecognizer:rightSwipeRecognizer];
    [webView addGestureRecognizer:leftSwipeRecognizer];
    [webView addGestureRecognizer:tapGesture];
}


-(void)initNavigationitem:(UIViewController*)_parentVc
{
    UIToolbar* tools = [[UIToolbar alloc] initWithFrame:CGRectMake(200, 0, 200, 40)];
    [tools setTintColor:[self.navigationController.navigationBar tintColor]];
    [tools setAlpha:[self.navigationController.navigationBar alpha]];
    
    UIImage *shareimage=SetNavImage(@"share.png");
    UIButton *sButton=[UIButton buttonWithType:UIButtonTypeCustom];
    sButton.frame=CGRectMake(screenWidth-40,5,30,30);
    
    [sButton setBackgroundImage:[shareimage imageWithTintColor:[UIColor whiteColor]] forState:UIControlStateNormal];
    
    [sButton addTarget:self action:@selector(shareBook:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem* shareBtnItem=[[UIBarButtonItem alloc]initWithCustomView:sButton];
    self.navigationItem.rightBarButtonItem=shareBtnItem;
    [sButton release];

//    [buttons addObject:shareBtnItem];
    [shareBtnItem release];
//    [tools setItems:buttons animated:NO];
//    [buttons release];
    

//    UIBarButtonItem *myBtn = [[UIBarButtonItem alloc] initWithCustomView:tools];
//    self.navigationItem.rightBarButtonItem = myBtn;
    parentVc.navigationItem.rightBarButtonItem=shareBtnItem;

    
    //自定义导航栏的"返回"按钮
    UIImage *backImg=SetNavImage(@"back.png");
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn. frame=CGRectMake(15, 5, 28, 28);
    [btn setBackgroundImage:[backImg imageWithTintColor:[UIColor whiteColor]]forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(quitBook)forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *back=[[UIBarButtonItem alloc]initWithCustomView:btn];
    parentVc.navigationItem.leftBarButtonItem=back;
    
//    [myBtn release]; 
    [tools release];
}

#pragma mark -
#pragma mark UIPageViewControllerDataSource


- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController{
    
    if(currentPageInSpineIndex+1<pagesInCurrentSpineCount){
        [self gotoPageInCurrentSpine:++currentPageInSpineIndex];
//            pageOffset = (pagesInCurrentSpineCount - 1)*viewWidth;
    } else {
        [self gotoNextSpine];
        return [self viewCintrollerAtIndex:0];
    }

    return [self viewCintrollerAtIndex: pageOffsetNumber];
}
- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController{
    if(currentPageInSpineIndex-1>=0){
        [self gotoPageInCurrentSpine:--currentPageInSpineIndex];
       
    } else {
        if(currentSpineIndex!=0){
            int targetPage = [[loadedEpub.spineArray objectAtIndex:(currentSpineIndex-1)] pageCount];
            [self loadSpine:--currentSpineIndex atPageIndex:targetPage-1];
            
        }
        return [self viewCintrollerAtIndex:0];
    }
    return [self viewCintrollerAtIndex:pageOffsetNumber];
}


#pragma mark -  load epub

- (void)openBook:(NSString *)bookPath atView:(UIView *)view withPageFrame:(CGRect)pageFrame  parentController:(UIViewController *) _parentVc
{
     NSLog(@" %s,%d",__FUNCTION__,__LINE__);
    self.recordManager=[[EpubRecordManager alloc]initWithRecordName:@"sheyingjiaocheng"];
    self.record=self.recordManager.lastRecord;
    currentSpineIndex = self.record.currentSpineIndex;
    currentPageInSpineIndex = self.record.currentPageInSpineIndex;
    pagesInCurrentSpineCount = self.record.pagesInCurrentSpineCount;
    totalPagesCount = 0;
	searching = NO;
    epubLoaded = NO;
    isflag=YES;
    _epubParentView = view;
    NSInteger textSize=self.record.currentTextSize;
    currentTextSize=textSize>100?textSize:100;
     [self showLoadingView];
    if (!self.webView)
    {
        [self initLoadView:view withPageFrame:pageFrame parentController:_parentVc];
    }
    [self.webView setHidden:NO];
    self.loadedEpub = [[EPub alloc] initWithEPubPath:bookPath];
    epubLoaded = YES;
    [self updatePagination];
    [self hideLoadingView];
    //当程序进入后台时执行写入数据库操作
    UIApplication *app = [UIApplication sharedApplication];
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(applicationWillResignActive)
     name:UIApplicationWillResignActiveNotification
     object:app];
}


- (int) getGlobalPageCount{
	int pageCount = 0;
	for(int i=0; i<currentSpineIndex; i++){
		pageCount+= [[loadedEpub.spineArray objectAtIndex:i] pageCount];
	}
	pageCount+=currentPageInSpineIndex+1;
	return pageCount;
}

- (void) loadSpine:(int)spineIndex atPageIndex:(int)pageIndex {
	[self loadSpine:spineIndex atPageIndex:pageIndex highlightSearchResult:nil];
}

- (void) loadSpine:(int)spineIndex atPageIndex:(int)pageIndex highlightSearchResult:(SearchResult*)theResult
{
	self.currentSearchResult = theResult;
    
	[chaptersPopover dismissPopoverAnimated:YES];
	[searchResultsPopover dismissPopoverAnimated:YES];
	
	NSURL* url = [NSURL fileURLWithPath:[[loadedEpub.spineArray objectAtIndex:spineIndex] spinePath]];
    currentUrl=url;
	[webView loadRequest:[NSURLRequest requestWithURL:url]];
    
	currentPageInSpineIndex = pageIndex;
	currentSpineIndex = spineIndex;
	if(!paginating){
		[currentPageLabel setText:[NSString stringWithFormat:@"%d/%d",[self getGlobalPageCount], totalPagesCount]];
		[pageSlider setValue:(float)100*(float)[self getGlobalPageCount]/(float)totalPagesCount animated:YES];
	}
}


- (void) gotoPageInCurrentSpine:(int)pageIndex{
	if(pageIndex>=pagesInCurrentSpineCount){
		pageIndex = pagesInCurrentSpineCount - 1;
		currentPageInSpineIndex = pagesInCurrentSpineCount - 1;
	}
	
	float pageOffset = pageIndex*viewWidth;
    pageOffsetNumber=pageOffset;
    
	NSString* goToOffsetFunc = [NSString stringWithFormat:@" function pageScroll(xOffset){ window.scroll(xOffset,0); } "];
	NSString* goTo =[NSString stringWithFormat:@"pageScroll(%f)", pageOffset];
	
	[webView stringByEvaluatingJavaScriptFromString:goToOffsetFunc];
	[webView stringByEvaluatingJavaScriptFromString:goTo];
	
	if(!paginating){
		[currentPageLabel setText:[NSString stringWithFormat:@"%d/%d",[self getGlobalPageCount], totalPagesCount]];
        pageNum=[self getGlobalPageCount];
		[pageSlider setValue:(float)100*(float)[self getGlobalPageCount]/(float)totalPagesCount animated:YES];
	}
//	NSLog([NSString stringWithFormat:@"%d/%d",[self getGlobalPageCount], totalPagesCount]);
	webView.hidden = NO;
	
}

- (void) gotoNextSpine {
    [self showLoadingView];
	if(!paginating){
		if(currentSpineIndex+1<[loadedEpub.spineArray count]){
			[self loadSpine:++currentSpineIndex atPageIndex:0];
		}
	}
    [self hideLoadingView];
}

- (void) gotoPrevSpine {
	if(!paginating){
		if(currentSpineIndex-1>=0){
			[self loadSpine:--currentSpineIndex atPageIndex:0];
		}
	}
}

- (void) gotoNextPage {
	if(!paginating){
		if(currentPageInSpineIndex+1<pagesInCurrentSpineCount){
			[self gotoPageInCurrentSpine:++currentPageInSpineIndex];
//            NSLog(@"currentPageInSpineIndex: %d",currentPageInSpineIndex);
		} else {
			[self gotoNextSpine];
		}
	}
}

- (void) gotoPrevPage {
	if (!paginating) {
		if(currentPageInSpineIndex-1>=0){
			[self gotoPageInCurrentSpine:--currentPageInSpineIndex];
		} else {
			if(currentSpineIndex!=0){
				int targetPage = [[loadedEpub.spineArray objectAtIndex:(currentSpineIndex-1)] pageCount];
				[self loadSpine:--currentSpineIndex atPageIndex:targetPage-1];
			}
		}
	}
}


#pragma mark -
#pragma mark 字体大小设置

- (void) increaseTextSizeClicked:(id)sender{
	if(!paginating){
		if(currentTextSize+25<=200){
			currentTextSize+=25;
			[self updatePagination];
			if(currentTextSize == 200){
				[incTextSizeButton setEnabled:NO];
			}
			[decTextSizeButton setEnabled:YES];
		}
	}
}
- (void) decreaseTextSizeClicked:(id)sender{
	if(!paginating){
		if(currentTextSize-25>=50){
			currentTextSize-=25;
			[self updatePagination];
			if(currentTextSize==50){
				[decTextSizeButton setEnabled:NO];
			}
			[incTextSizeButton setEnabled:YES];
		}
	}
}

#pragma mark -
#pragma mark 滑动条设置

- (void) slidingStarted:(id)sender
{
    UISlider* control = (UISlider*)sender;
//    NSLog(@"pageSlider.value=%f,totalPagesCount=%d",control.value,totalPagesCount);
    int targetPage = ((control.value/(float)100)*(float)totalPagesCount);
    if (targetPage==0) {
        targetPage++;
    }
	[currentPageLabel setText:[NSString stringWithFormat:@"%d/%d", targetPage, totalPagesCount]];
    pageNum=targetPage;
}

- (void) slidingEnded:(id)sender{
    UISlider* control = (UISlider*)sender;
	int targetPage = (int)((control.value/(float)100)*(float)totalPagesCount);
    if (targetPage==0) {
        targetPage++;
    }
	int pageSum = 0;
	int chapterIndex = 0;
	int pageIndex = 0;
	for(chapterIndex=0; chapterIndex<[loadedEpub.spineArray count]; chapterIndex++){
		pageSum+=[[loadedEpub.spineArray objectAtIndex:chapterIndex] pageCount];
//        NSLog(@"Chapter %d, targetPage: %d, pageSum: %d, pageIndex: %d", chapterIndex, targetPage, pageSum, (pageSum-targetPage));
		if(pageSum>=targetPage){
			pageIndex = [[loadedEpub.spineArray objectAtIndex:chapterIndex] pageCount] - 1 - pageSum + targetPage;
			break;
		}
	}
//    NSLog(@"chapterIndex=%d pageIndex=%d",chapterIndex,pageIndex);
	[self loadSpine:chapterIndex atPageIndex:pageIndex];
}

- (void) updatePagination
{
	if(epubLoaded){
        if(!paginating){
            paginating = YES;
            totalPagesCount=0;
            [self loadSpine:currentSpineIndex atPageIndex:currentPageInSpineIndex];
            [[loadedEpub.spineArray objectAtIndex:0] setDelegate:self];
            [[loadedEpub.spineArray objectAtIndex:0] loadChapterWithWindowSize:webView.bounds fontPercentSize:currentTextSize];
            [currentPageLabel setText:@"?/?"];
            paginating = NO;
//            NSLog(@"Pagination Started! currentPageInSpineIndex：%d",currentPageInSpineIndex);
        }
	}
}




#pragma mark -
#pragma mark 章节设置


- (void) chapterDidFinishLoad:(Chapter *)chapter{
    totalPagesCount+=chapter.pageCount;
    
	if(chapter.chapterIndex + 1 < [loadedEpub.spineArray count]){
		[[loadedEpub.spineArray objectAtIndex:chapter.chapterIndex+1] setDelegate:self];
		[[loadedEpub.spineArray objectAtIndex:chapter.chapterIndex+1] loadChapterWithWindowSize:webView.bounds fontPercentSize:currentTextSize];
		[currentPageLabel setText:[NSString stringWithFormat:@"?/%d", totalPagesCount]];
	} else {
		[currentPageLabel setText:[NSString stringWithFormat:@"%d/%d",[self getGlobalPageCount], totalPagesCount]];
//        pageSlider.minimumValue=1;
//        pageSlider.value=1;
        pageSlider.maximumValue=100;
//        NSLog(@"总页数:%d",totalPagesCount);
		[pageSlider setValue:(float)100*(float)[self getGlobalPageCount]/(float)totalPagesCount animated:YES];
		paginating = NO;
		NSLog(@"Pagination Ended!");
	}
}

-(void)showCatalogue:(id)gesture
{
    
    ChapterListViewController* chapterListView = [[[ChapterListViewController alloc] init]autorelease];
    [chapterListView setEpubViewController:self];
//    chapterListView.modalPresentationCapturesStatusBarAppearance=YES;
    UINavigationController *nav = [[UINavigationController alloc]
                                   initWithRootViewController:chapterListView];
    nav.title=@"摄影笔记";
//    chapterListView.view.frame=CGRectMake(0, 20, viewWidth-40, _epubParentView.frame.size.height);
    [parentVc presentViewController:nav animated:YES completion:^{
         parentVc.navigationController.navigationBar.hidden=YES;
         tabBarView.hidden=YES;
         pageSlider.hidden=YES;
//         parentVc.view.backgroundColor=[UIColor whiteColor];
    }];
    
}


- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
	if(searchResultsPopover==nil){
		searchResultsPopover = [[UIPopoverController alloc] initWithContentViewController:searchResViewController];
		[searchResultsPopover setPopoverContentSize:CGSizeMake(400, 600)];
	}
	if (![searchResultsPopover isPopoverVisible]) {
		[searchResultsPopover presentPopoverFromRect:searchBar.bounds inView:searchBar permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
	}
    //	NSLog(@"Searching for %@", [searchBar text]);
	if(!searching){
		searching = YES;
		[searchResViewController searchString:[searchBar text]];
        [searchBar resignFirstResponder];
	}
}

#pragma mark -
#pragma mark 书签设置

-(void)addBookMark:(id) sender
{
    NSLog(@"add Book Mark");
    
//    self.record.lastReadTime=
    
}

-(void)addRecord
{
    self.record.bookId=1;
    self.record.currentSpineIndex=currentSpineIndex;
    self.record.currentPageInSpineIndex=currentPageInSpineIndex;
    self.record.pagesInCurrentSpineCount=pagesInCurrentSpineCount;
    self.record.pageInAll=pageNum;
    self.record.lastReadTime=[[NSDate date]convertDateToStringWithFormat:@"yyyy-MM-dd hh:mm ss"];
    [self.recordManager addRecord:self.record];
}

#pragma mark -
#pragma mark 分享

-(void)shareBook:(id)sender
{
    NSLog(@"分享！");
}
//-(BOOL)isDirectShareInIconActionSheet
//{
//    return YES;
//}

#pragma mark -
#pragma mark 退出书籍
    
-(void)quitBook
{
    NSLog(@"退出书籍");
    
    [parentVc.navigationController popViewControllerAnimated:YES];
    [self addRecord];
}
//程序进入后台时添加数据
-(void)applicationWillResignActive
{
    [self addRecord];
}


#pragma mark -
#pragma mark UIGestureRecognizer delegate

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}


- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    CGFloat hitHeight=self.webView.bounds.size.height;
    
    CGPoint pt =[touch locationInView:self.webView];
    
    if(pt.y>hitHeight/3&&pt.y<hitHeight/3*2&&pt.x>50)
    {
        return YES;
    }
    return NO;
}

-(void)showNavBar:(UITapGestureRecognizer *)gesture
{
    NSLog(@"showBar");
    //    _epubParentView.exclusiveTouch=YES;
    isflag=!isflag;
    parentVc.navigationController.navigationBar.hidden=isflag;
//    parentVc.navigationController.toolbar.hidden=isflag;
    self.navigationController.navigationBar.alpha = 1;
    tabBarView.hidden=isflag;
    pageSlider.hidden=isflag;
    
}


#pragma mark -
#pragma mark UIWebView delegate

- (void)webViewDidFinishLoad:(UIWebView *)theWebView
{
    
    NSLog(@"WebView 重新计算 %s,%d",__FUNCTION__,__LINE__);
	
	NSString *varMySheet = @"var mySheet = document.styleSheets[0];";
	
	NSString *addCSSRule =  @"function addCSSRule(selector, newRule) {"
	"if (mySheet.addRule) {"
	"mySheet.addRule(selector, newRule);"								// For Internet Explorer
	"} else {"
	"ruleIndex = mySheet.cssRules.length;"
	"mySheet.insertRule(selector + '{' + newRule + ';}', ruleIndex);"   // For Firefox, Chrome, etc.
	"}"
	"}";
	
	NSString *insertRule1 = [NSString stringWithFormat:@"addCSSRule('html', 'padding: 0px; height: %fpx; -webkit-column-gap: 0px; -webkit-column-width: %fpx; line-height:18px;width=%fpx')", webView.frame.size.height-20, viewWidth,viewWidth];
	NSString *insertRule2 = [NSString stringWithFormat:@"addCSSRule('p', 'text-align: justify;')"];
//    NSString *insertRule2 = [NSString stringWithFormat:@"addCSSRule('p', 'text-align: justify;')"];
	NSString *setTextSizeRule = [NSString stringWithFormat:@"addCSSRule('body', '-webkit-text-size-adjust: %d%%;')", currentTextSize];
	NSString *setHighlightColorRule = [NSString stringWithFormat:@"addCSSRule('highlight', 'background-color: yellow;')"];
    
   //拦截网页缩放图片
    
    [webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"var script = document.createElement('script');"
         "script.type = 'text/javascript';"
         "script.text = \"function ResizeImages() { "
         "var myimg,oldwidth;"
         "var maxwidth=%f;" //缩放系数
         
         "for(i=0;i <document.images.length;i++){"
         "myimg = document.images[i];"
         "if(myimg.width > maxwidth){"
         "oldwidth = myimg.width;"
//        "alert('width:'+myimg.width);"
         "var oh=myimg.height;"
//         "alert('myheight:'+myimg.height);"
         "myimg.style.width='%fpx';"
         "var fieight = oh * (maxwidth/oldwidth);"
//         "alert(fieight);"
         "myimg.style.height=fieight+'px';"
         "}"
         "}"
         "}\";""document.getElementsByTagName('head')[0].appendChild(script);",viewWidth,viewWidth]];
    
    [webView stringByEvaluatingJavaScriptFromString:@"ResizeImages();"];
    
	
	[webView stringByEvaluatingJavaScriptFromString:varMySheet];
	
	[webView stringByEvaluatingJavaScriptFromString:addCSSRule];
    
	[webView stringByEvaluatingJavaScriptFromString:insertRule1];
	
	[webView stringByEvaluatingJavaScriptFromString:insertRule2];
	
	[webView stringByEvaluatingJavaScriptFromString:setTextSizeRule];
	
	[webView stringByEvaluatingJavaScriptFromString:setHighlightColorRule];
//    [webView stringByEvaluatingJavaScriptFromString:meta];
	
	if(currentSearchResult!=nil){
        //	NSLog(@"Highlighting %@", currentSearchResult.originatingQuery);
        [webView highlightAllOccurencesOfString:currentSearchResult.originatingQuery];
	}
	
	
	int totalWidth = [[webView stringByEvaluatingJavaScriptFromString:@"document.documentElement.scrollWidth"] intValue];
//    NSLog(@"totalWidth=%d",totalWidth);
	pagesInCurrentSpineCount = (int)((float)totalWidth/(viewWidth));
    NSLog(@"pagesInCurrentSpineCount: %d",pagesInCurrentSpineCount);
	
	[self gotoPageInCurrentSpine:currentPageInSpineIndex];

}

@end
