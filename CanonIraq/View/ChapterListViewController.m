//
//  ChapterListViewController.m
//  AePubReader
//
//  Created by Federico Frappi on 04/05/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ChapterListViewController.h"


@implementation ChapterListViewController

@synthesize epubViewController;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    return self;
}

- (void)dealloc
{
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationController.title=@"摄影笔记";

    
    btnBack=[UIButton buttonWithType:UIButtonTypeCustom];
    btnBack.frame=CGRectMake(screenWidth, (screenHight-80)/3, 28, 66);
//    btnBack.frame = CGRectMake(0, 0, 100, 100);
    
    [btnBack setImage:[UIImage imageNamed:@"close_left"] forState:UIControlStateNormal];
    [btnBack addTarget:self action:@selector(dismissViewController) forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:btnBack];
    
//    [tableView release];

}

-(void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
      UIScreen *screen=[UIScreen mainScreen];
      self.view.frame=screen.bounds;

    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
   }

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (BOOL)prefersStatusBarHidden{
    return YES;
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGRect frame = CGRectMake(screenWidth, (screenHight-80)/3, 28, 66);;
//    frame.origin.y = scrollView.contentOffset.y+self.tableView.frame.size.height - btnBack.frame.size.height;
    frame.origin.y = scrollView.contentOffset.y+screenHight/2;
    frame.origin.x=screenWidth-28;//最终的坐标值
    btnBack.frame= frame;
    [self.view bringSubviewToFront:btnBack];
}

-(void)viewWillLayoutSubviews{

//    CGFloat rect = self.tableView.contentOffset.y;
//    NSLog(@"y %f",rect);
////    btnBack.frame=CGRectMake(screenWidth-40, (rect+screenHight-80)/3, 40, 40);
//    NSLog(@"Rect %@",NSStringFromCGSize(self.tableView.contentSize));
//    NSLog(@"btnFrame %@",NSStringFromCGRect(btnBack.frame));
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
     return [epubViewController.loadedEpub.spineArray count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return @"目录";
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    cell.textLabel.numberOfLines = 2;
    cell.textLabel.font = [UIFont fontWithName:@"Helvetica" size:12 ];
    cell.textLabel.lineBreakMode = UILineBreakModeMiddleTruncation;
    cell.textLabel.adjustsFontSizeToFitWidth = YES;
    cell.textLabel.text = [[epubViewController.loadedEpub.spineArray objectAtIndex:[indexPath row]] title];
    return cell;
}

-(void)dismissViewController
{
    [self dismissViewControllerAnimated:YES completion:^{
        NSLog(@"dismissView!");
    }];
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [epubViewController loadSpine:[indexPath row] atPageIndex:0 highlightSearchResult:nil];
    [self dismissViewController];
}

@end
