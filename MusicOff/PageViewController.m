//
//  PageViewController.m
//  MusicOff
//
//  Created by 태환 on 3/6/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PageViewController.h"
#import "HomeViewController.h"
#import "HelpViewController.h"
#import "SettingViewController.h"
#import "MusicOffViewController.h"
#import "AppDelegate.h"

@implementation PageViewController

@synthesize musicOffViewController;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor clearColor];
    pgControl.hidden = YES;
    
    self.navigationController.navigationBar.tintColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0];
    self.navigationController.navigationBar.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0];
    self.title = NSLocalizedString(@"Music Off", @"Music Off");
    
    int screenHeight = [[UIScreen mainScreen] bounds].size.height;
    
    // Do any additional setup after loading the view from its nib.
    scrollView.contentSize = CGSizeMake(320 * 6, screenHeight - 70);
    scrollView.contentOffset = CGPointMake(320, screenHeight - 70);
    scrollView.backgroundColor = [UIColor clearColor];
    
    helpViewControllerFront = [[HelpViewController alloc] init];
    helpViewControllerFront.view.frame = CGRectMake(0, 0, 320, screenHeight - 70);
    homeViewController = [[HomeViewController alloc] init];
    homeViewController.view.frame = CGRectMake(320, 0, 320, screenHeight - 70);
    settingViewController = [[SettingViewController alloc] init];
    settingViewController.view.frame = CGRectMake(640, 0, 320, screenHeight - 70);
    musicOffViewController = [[MusicOffViewController alloc] init];
    musicOffViewController.view.frame = CGRectMake(960, 0, 320, screenHeight - 70);
    helpViewController = [[HelpViewController alloc] init];
    helpViewController.view.frame = CGRectMake(1280, 0, 320, screenHeight - 70);
    homeViewControllerBehind = [[HomeViewController alloc] init];
    homeViewControllerBehind.view.frame = CGRectMake(1600, 0, 320, screenHeight - 70);
    
    [settingViewController setMusicOffViewController:musicOffViewController];
    [musicOffViewController setSettingViewController:settingViewController];
    
    [scrollView addSubview:helpViewControllerFront.view];
    [scrollView addSubview:homeViewController.view];
    [scrollView addSubview:settingViewController.view];
    [scrollView addSubview:musicOffViewController.view];
    [scrollView addSubview:helpViewController.view];
    [scrollView addSubview:homeViewControllerBehind.view];
    
    //ScrollView에 필요한 옵션을 적용한다. 
    scrollView.showsVerticalScrollIndicator=NO;
    scrollView.showsHorizontalScrollIndicator=NO;
    scrollView.alwaysBounceVertical=NO;             
    scrollView.alwaysBounceHorizontal=NO;         
    scrollView.pagingEnabled=YES;          //Paging Enabled YES
    scrollView.delegate=self;
    
    [self setinitView];
    
    //Cover View
    UIView * cover = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, screenHeight)];
    [self.view addSubview:cover];
    [cover setHidden:YES];
    [musicOffViewController setCoverView:cover];
    [cover release];
    
    //pageControl에 필요한 옵션을 적용한다.
    pgControl.numberOfPages=6;          //페이지 갯수는 6개
    [pgControl addTarget:self action:@selector(pageChangeValue:) forControlEvents:UIControlEventValueChanged]; //페이지 컨트롤 값변경시 이벤트 처리 등록
    
    //PageControl 초기화
    [scrollView setContentOffset:CGPointMake(320 * 3, 0)];
    [tabBar setSelectedIndex:2];
    pgControl.currentPage = 3;
    previousValue = 3;
}

- (void)setinitView
{
    int screenHeight = [[UIScreen mainScreen] bounds].size.height;
    tabBar = [[CustomTabBar alloc] initWithFrame:CGRectMake(0, screenHeight - 20 - CustomTabHeight, 320, CustomTabHeight)];
    [tabBar setDelegate:self];
    [tabBar setBg:[UIImage imageNamed:@"menu_bar.png"]];
    
    
    NSArray * titleLabels = [NSArray arrayWithObjects:
                             NSLocalizedString(@"Home", @""),
                             NSLocalizedString(@"Setting", @""),
                             NSLocalizedString(@"Music Off", @""),
                             NSLocalizedString(@"Help", @""),
                             nil];
    
    NSArray * normalImages = [NSArray arrayWithObjects:
                              [UIImage imageNamed:@"home_button_unchoosed"],
                              [UIImage imageNamed:@"setting_button_unchoosed"],
                              [UIImage imageNamed:@"app_button_unchoosed"],
                              [UIImage imageNamed:@"help_button_unchoosed"],
                              nil];
    NSArray * selImages = [NSArray arrayWithObjects:
                           [UIImage imageNamed:@"home_button_choosed"],
                           [UIImage imageNamed:@"setting_button_choosed"],
                           [UIImage imageNamed:@"app_button_choosed"],
                           [UIImage imageNamed:@"help_button_choosed"],
                           nil];
    [tabBar setTabbarImages:normalImages selectedImages:selImages selectedLabels:titleLabels selectedIndex:0];
    
    [self.view addSubview:tabBar];
    
    [tabBar release];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)dealloc
{
    [homeViewController release];
    [settingViewController release];
    [homeViewControllerBehind release];
    [super dealloc];
}

- (void)setPage:(NSInteger)index
{
    pgControl.currentPage = index;
    [scrollView setContentOffset:CGPointMake(320 * pgControl.currentPage, 0) animated:YES];
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)aScrollView     
{
    CGFloat pageWidth = aScrollView.frame.size.width;
    pgControl.currentPage = floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    
    if(previousValue != pgControl.currentPage)
    {
        if (pgControl.currentPage == 0) 
        {
            [tabBar setSelectedIndex:3];
        }
        else if(pgControl.currentPage == 5)
        {
            [tabBar setSelectedIndex:0];
        }
        else
        {
            [tabBar setSelectedIndex:(pgControl.currentPage - 1)];
        }
    }
    previousValue = pgControl.currentPage;
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)aScrollView
{
    if (pgControl.currentPage == 0) 
    {
        [aScrollView setContentOffset:CGPointMake(320 * 4, 0)];
    }
    else if(pgControl.currentPage == 3)
    {
        [helpViewControllerFront.scrollView setContentOffset:CGPointMake(0,helpViewController.scrollView.contentOffset.y)];
    }
    else if(pgControl.currentPage == 5)
    {
        [helpViewControllerFront.scrollView setContentOffset:CGPointMake(0,helpViewController.scrollView.contentOffset.y)];
        [aScrollView setContentOffset:CGPointMake(320, 0)];
    }
}

#pragma mark - customTabBarDelegate
- (void)tabButtonClicked:(UIButton *)button
{
    NSInteger index = button.tag;
    [self setPage:(index + 1)];
}

@end
