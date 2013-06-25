//
//  PageViewController.h
//  MusicOff
//
//  Created by 태환 on 3/6/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomTabBar.h"
#import "HomeViewController.h"
#import "HelpViewController.h"
#import "SettingViewController.h"
#import "MusicOffViewController.h"

@interface PageViewController : UIViewController <UIScrollViewDelegate, CustomTabBarDelegate>
{
    IBOutlet UIScrollView * scrollView;
    IBOutlet UIPageControl * pgControl;
    HelpViewController * helpViewControllerFront;
    HelpViewController * helpViewController;
    
    MusicOffViewController * musicOffViewController;
    HomeViewController * homeViewController;
    SettingViewController * settingViewController;
    HomeViewController * homeViewControllerBehind;
    
    NSInteger previousValue;
    NSInteger helpViewScroll;
    
    CustomTabBar * tabBar;
    NSArray * titles;
}
@property(nonatomic, retain) MusicOffViewController * musicOffViewController;

- (void)setPage:(NSInteger)index;
- (void)setinitView;

@end
