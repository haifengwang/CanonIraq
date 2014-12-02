//
//  BookCoverViewController.m
//  CanonIraq
//
//  Created by onskyline on 14-5-13.
//  Copyright (c) 2014年 onskyline. All rights reserved.
//

#import "BookCoverViewController.h"
#import "View/EPubViewController.h"

#define stateNotice @"bookState"

@interface BookCoverViewController ()
{
    EPubViewController *detailViewController;
    
}

@end


@implementation BookCoverViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    CGRect bound =[UIScreen mainScreen].bounds;
    UIImageView *bgImgView = [[UIImageView alloc] initWithFrame:bound];
    [bgImgView setImage:[UIImage imageNamed:@"cover"]];
    [self.view addSubview:bgImgView];
    [bgImgView release];

    
    UITapGestureRecognizer *tapGesture=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapReadBook:)];
    [self.view addGestureRecognizer:tapGesture];
    self.view.tag=1;
    [tapGesture release];
    
//    [center postNotificationName:stateNotice object:nil];
    // Do any additional setup after loading the view.
    
}
-(void)tapReadBook:(UITapGestureRecognizer *)tapGesture
{
    self.epubVc=[[[EpubVc alloc]init]autorelease];
    self.epubVc.hidesBottomBarWhenPushed=YES;
    [self.navigationController pushViewController:self.epubVc animated:YES];
}

#pragma mark-
#pragma mark 系统

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)dealloc
{
    [super dealloc];
    
//    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"async000" object:nil];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
