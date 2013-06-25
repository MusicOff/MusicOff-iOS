//
//  CustomTabBar.h
//  MusicOff
//
//  Created by 태환 on 3/6/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#define CustomTabHeight 50
@protocol CustomTabBarDelegate
- (void)tabButtonClicked:(UIButton *)button;
@end

@interface CustomTabBar : UIView
{
    UIImageView * Bg;
    NSMutableArray * buttons;
    id<CustomTabBarDelegate> delegate;
}
@property(nonatomic, retain) id<CustomTabBarDelegate> delegate;
- (void)setBg:(UIImage *)Bg;
- (void)setTabbarImages:(NSArray *)images selectedImages:(NSArray *)selImages selectedLabels:(NSArray *)labels selectedIndex:(NSInteger)selectedIndex;
- (void)setSelectedIndex:(NSInteger)selectedIndex;

@end