//
//  EpubVc.m
//  CanonIraq
//
//  Created by onskyline on 14-5-20.
//  Copyright (c) 2014年 onskyline. All rights reserved.
//

#import "EpubVc.h"
@interface EpubVc ()
@end

@implementation EpubVc

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
    
//    CGRect bound =[[UIScreen mainScreen]bounds];
    CGRect frame =[[UIScreen mainScreen]applicationFrame];
    self.view.frame = frame;
   
    UIView *containerView=[[UIView alloc]initWithFrame:frame];
    containerView.backgroundColor=[UIColor clearColor];
    [self.view addSubview:containerView];
    [containerView release];
    
//    NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//    
//    NSString *filePath=[NSString stringWithFormat:@"%@/%@",[paths objectAtIndex:0],@"sheying.epub"];
    
    NSString* path=[[NSBundle mainBundle]pathForResource:@"swift" ofType:@"epub"];
    self.epubViewVc=[[EPubViewController alloc]init];
    CGRect viewfram=CGRectMake(8, 8, frame.size.width-16, frame.size.height-48);
    [self.epubViewVc openBook:path atView:containerView withPageFrame:viewfram parentController:self];
   
}

#pragma mark-隐藏tabBar


- (BOOL)prefersStatusBarHidden{
    return YES;
}


-(void)dealloc
{
    [super dealloc];
//    [self.epubController release];
}

-(void)viewWillAppear:(BOOL)animated
{
        self.view.backgroundColor=[UIColor clearColor];
//    self.navigationController.navigationBar.hidden=YES;
//    NSLog(@"重新 加载视图 function %s,line=%d",__FUNCTION__,__LINE__);
//    NSLog(@"viewWillAppear View frame:%@",NSStringFromCGRect(self.view.frame));
}

-(void)viewWillDisappear:(BOOL)animated
{
//    NSLog(@"function %s,line=%d",__FUNCTION__,__LINE__);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
