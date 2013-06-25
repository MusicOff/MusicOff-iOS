//
//  CustomTabBar.m
//  MusicOff
//
//  Created by 태환 on 3/6/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CustomTabBar.h"

@implementation CustomTabBar
@synthesize delegate;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        buttons = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)setBg:(UIImage *)BgImage
{
    Bg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, CustomTabHeight)];
    [Bg setImage:BgImage];
    [self addSubview:Bg];
    [Bg release];
}

- (void)setTabbarImages:(NSArray *)images selectedImages:(NSArray *)selImages selectedLabels:(NSArray *)labels selectedIndex:(NSInteger)selectedIndex
{
    for(int index = 0; index < [images count]; index++)
    {
        UIImage * normalImage = [images objectAtIndex:index];
        UIImage * selectedImage = [selImages objectAtIndex:index];
        NSString * normalLabel = [labels objectAtIndex:index];
        
        UIButton * button = [[UIButton alloc] initWithFrame:CGRectMake((304 / [images count]) * index+16, 1, 60, 48)];
        button.tag = index;
        if(index == selectedIndex)
            button.selected = YES;
        [button setImage:normalImage forState:UIControlStateNormal];
        [button setImage:selectedImage forState:UIControlStateSelected];
        [button addTarget:self action:@selector(tabButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:button];
        [buttons addObject:button];
        [button release];
        
        UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake((304 / [images count]) * index+16, 39, 60, 10)];
        [label setText:normalLabel];
        [label setContentMode:UIViewContentModeScaleAspectFit];
        [label setTextColor:[UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:1]];
        [label setFont:[UIFont fontWithName:@"Arial" size:9]];
        [label setBackgroundColor:[UIColor clearColor]];
        [label setTextAlignment:UITextAlignmentCenter];
        [self addSubview:label];
        [label release];
    }
}

- (void)setSelectedIndex:(NSInteger)selectedIndex
{
    NSInteger index = 0;
    for (UIButton * button in buttons) 
    {   
        if(index == selectedIndex)
            button.selected = YES;
        else
            button.selected = NO;
        index++;
    }
}

- (void)tabButtonClicked:(UIButton *)button
{
    for (UIButton * button in buttons) {
        button.selected = NO;
    }
    
    button.selected = !button.selected;
    [delegate tabButtonClicked:button];
}
@end