//
//  PopUpWindow.m
//  Music Off
//
//  Created by 태환 on 6/14/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PopUpWindow.h"

#define kShadeViewTag 1000
#define animDuration 1.0
#define soundEffectDuration 0.175

@interface PopUpWindow(Private)
- (id)initWithSuperview:(UIView*)sview;
@end

@implementation PopUpWindow

/**
 * Initializes the class instance, gets a view where the window will pop up in
 */
- (id)initWithSuperview:(UIView*)sview
{
    self = [super init];
    if (self) {
        cView = sview;
        [cView setHidden:NO];
        
        // Initialization code here.
        bgView = [[[UIView alloc] initWithFrame: cView.bounds] autorelease];
        [cView addSubview: bgView];
        
        // proceed with animation after the bgView was added
        [self performSelector:@selector(doTransition) withObject:NULL afterDelay:0.1];
    }
    return self;
}

/**
 * Afrer the window background is added to the UI the window can animate in
 * and load the UIWebView
 */
-(void)doTransition
{
    NSURL *url = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource: @"CLICK5"
                                                                        ofType: @"WAV"]];
	NSError *error;
	audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:&error];
    audioPlayer.delegate = self;
    audioPlayer.numberOfLoops = 1;
    [self performSelector:@selector(playSoundEffect) withObject:nil afterDelay:animDuration - soundEffectDuration];
    
    //faux view
    UIView* fauxView = [[[UIView alloc] initWithFrame: CGRectMake(10, 10, 200, 200)] autorelease];
    [bgView addSubview: fauxView];
    
    //the new panel
    bigPanelView = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, bgView.frame.size.width, bgView.frame.size.height)] autorelease];
    bigPanelView.center = CGPointMake( bgView.frame.size.width/2, (bgView.frame.size.height-70)/2);
    
    //add the window background
    UIImageView* background = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"popupWindowBack.png"]] autorelease];
    background.center = CGPointMake(bigPanelView.frame.size.width/2, bigPanelView.frame.size.height/2);
    [bigPanelView addSubview: background];
    
    //add the labels
    UILabel * cautionLable = [[UILabel alloc]initWithFrame:CGRectMake(20, 45, 280, 100)];
    [cautionLable setFont:[UIFont boldSystemFontOfSize:40.0f]];
    cautionLable.textAlignment = UITextAlignmentCenter;
    [cautionLable setText:NSLocalizedString(@"CAUTION!", @"")];
    [cautionLable setBackgroundColor:[UIColor clearColor]];
    [bigPanelView addSubview:cautionLable];
    [cautionLable release];
    
    UILabel * lockButtonCautionLable = [[UILabel alloc]initWithFrame:CGRectMake(120, 155, 180, 25)];
    [lockButtonCautionLable setFont:[UIFont boldSystemFontOfSize:20.0f]];
    lockButtonCautionLable.textAlignment = UITextAlignmentCenter;
    [lockButtonCautionLable setText:NSLocalizedString(@"lock1", @"Do NOT Press")];
    [lockButtonCautionLable setBackgroundColor:[UIColor clearColor]];
    [bigPanelView addSubview:lockButtonCautionLable];
    [lockButtonCautionLable release];
    
    UILabel * lockButtonCautionLable2 = [[UILabel alloc]initWithFrame:CGRectMake(120, 185, 180, 25)];
    [lockButtonCautionLable2 setFont:[UIFont boldSystemFontOfSize:20.0f]];
    lockButtonCautionLable2.textAlignment = UITextAlignmentCenter;
    [lockButtonCautionLable2 setText:NSLocalizedString(@"lock2", @"The LOCK Button!")];
    [lockButtonCautionLable2 setBackgroundColor:[UIColor clearColor]];
    [bigPanelView addSubview:lockButtonCautionLable2];
    [lockButtonCautionLable2 release];
    
    UILabel * lockButtonCautionLable3 = [[UILabel alloc]initWithFrame:CGRectMake(190, 200, 150, 12)];
    [lockButtonCautionLable3 setFont:[UIFont fontWithName:@"ArialRoundedMTBold" size:11.0f]];
    lockButtonCautionLable3.textAlignment = UITextAlignmentCenter;
    [lockButtonCautionLable3 setText:NSLocalizedString(@"Timer Stops", @"")];
    CGSize textSize2 = [[lockButtonCautionLable3 text] sizeWithFont:[lockButtonCautionLable3 font]];
    [lockButtonCautionLable3 setFrame:CGRectMake(190, 200, textSize2.width+4, 12)];
    [lockButtonCautionLable3 setTextColor:[UIColor colorWithRed:220.0/255.0 green:0.0/255.0 blue:0.0/255.0 alpha:1.0]];
    [lockButtonCautionLable3 setBackgroundColor:[UIColor colorWithRed:0.0/255.0 green:0.0/255.0 blue:0.0/255.0 alpha:0.5]];
    [lockButtonCautionLable3 setTransform:CGAffineTransformMakeRotation(-M_PI / 20)];
    [bigPanelView addSubview:lockButtonCautionLable3];
    [lockButtonCautionLable3 release];
    
    UILabel * homeButtonCautionLable = [[UILabel alloc]initWithFrame:CGRectMake(120, 253, 180, 25)];
    [homeButtonCautionLable setFont:[UIFont boldSystemFontOfSize:20.0f]];
    homeButtonCautionLable.textAlignment = UITextAlignmentCenter;
    [homeButtonCautionLable setText:NSLocalizedString(@"home1", @"Do NOT Press")];
    [homeButtonCautionLable setBackgroundColor:[UIColor clearColor]];
    [bigPanelView addSubview:homeButtonCautionLable];
    [homeButtonCautionLable release];
    
    UILabel * homeButtonCautionLable2 = [[UILabel alloc]initWithFrame:CGRectMake(120, 283, 180, 25)];
    [homeButtonCautionLable2 setFont:[UIFont boldSystemFontOfSize:20.0f]];
    homeButtonCautionLable2.textAlignment = UITextAlignmentCenter;
    [homeButtonCautionLable2 setText:NSLocalizedString(@"home2", @"The HOME Button!")];
    [homeButtonCautionLable2 setBackgroundColor:[UIColor clearColor]];
    [bigPanelView addSubview:homeButtonCautionLable2];
    [homeButtonCautionLable2 release];
    
    UILabel * homeButtonCautionLable3 = [[UILabel alloc]initWithFrame:CGRectMake(190, 298, 150, 12)];
    [homeButtonCautionLable3 setFont:[UIFont fontWithName:@"ArialRoundedMTBold" size:11.0f]];
    homeButtonCautionLable3.textAlignment = UITextAlignmentCenter;
    [homeButtonCautionLable3 setText:NSLocalizedString(@"Timer Stops", @"")];
    CGSize textSize3 = [[homeButtonCautionLable3 text] sizeWithFont:[homeButtonCautionLable3 font]];
    [homeButtonCautionLable3 setFrame:CGRectMake(190, 298, textSize3.width+4, 12)];
    [homeButtonCautionLable3 setTextColor:[UIColor colorWithRed:220.0/255.0 green:0.0/255.0 blue:0.0/255.0 alpha:1.0]];
    [homeButtonCautionLable3 setBackgroundColor:[UIColor colorWithRed:0.0/255.0 green:0.0/255.0 blue:0.0/255.0 alpha:0.5]];
    [homeButtonCautionLable3 setTransform:CGAffineTransformMakeRotation(-M_PI / 20)];
    [bigPanelView addSubview:homeButtonCautionLable3];
    [homeButtonCautionLable3 release];
    
    UILabel * chargeCautionLable = [[UILabel alloc]initWithFrame:CGRectMake(120, 351, 180, 25)];
    [chargeCautionLable setFont:[UIFont boldSystemFontOfSize:20.0f]];
    chargeCautionLable.textAlignment = UITextAlignmentCenter;
    [chargeCautionLable setText:NSLocalizedString(@"charge1", @"DO Charge")];
    [chargeCautionLable setBackgroundColor:[UIColor clearColor]];
    [bigPanelView addSubview:chargeCautionLable];
    [chargeCautionLable release];
    
    UILabel * chargeCautionLable2 = [[UILabel alloc]initWithFrame:CGRectMake(120, 381, 180, 25)];
    [chargeCautionLable2 setFont:[UIFont boldSystemFontOfSize:20.0f]];
    chargeCautionLable2.textAlignment = UITextAlignmentCenter;
    [chargeCautionLable2 setText:NSLocalizedString(@"charge2", @"Your iPhone!")];
    [chargeCautionLable2 setBackgroundColor:[UIColor clearColor]];
    [bigPanelView addSubview:chargeCautionLable2];
    [chargeCautionLable2 release];
    
    UILabel * chargeCautionLable3 = [[UILabel alloc]initWithFrame:CGRectMake(190, 396, 150, 12)];
    [chargeCautionLable3 setFont:[UIFont fontWithName:@"ArialRoundedMTBold" size:11.0f]];
    chargeCautionLable3.textAlignment = UITextAlignmentCenter;
    [chargeCautionLable3 setText:NSLocalizedString(@"GOOD FOR YOU!", @"")];
    CGSize textSize4 = [[chargeCautionLable3 text] sizeWithFont:[chargeCautionLable3 font]];
    [chargeCautionLable3 setFrame:CGRectMake(190, 396, textSize4.width+4, 12)];
    [chargeCautionLable3 setTextColor:[UIColor colorWithRed:200.0/255.0 green:200.0/255.0 blue:0.0/255.0 alpha:1.0]];
    [chargeCautionLable3 setBackgroundColor:[UIColor colorWithRed:0.0/255.0 green:0.0/255.0 blue:0.0/255.0 alpha:0.5]];
    [chargeCautionLable3 setTransform:CGAffineTransformMakeRotation(-M_PI / 20)];
    [bigPanelView addSubview:chargeCautionLable3];
    [chargeCautionLable3 release];
    
    //add the close button
    int closeBtnOffset = 10;
    UIImage* closeBtnImg = [UIImage imageNamed:@"popupCloseBtn.png"];
    UIButton* closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [closeBtn setImage:closeBtnImg forState:UIControlStateNormal];
    [closeBtn setFrame:CGRectMake( background.frame.origin.x + background.frame.size.width - closeBtnImg.size.width - closeBtnOffset, 
                                  background.frame.origin.y ,
                                  closeBtnImg.size.width + closeBtnOffset, 
                                  closeBtnImg.size.height + closeBtnOffset)];
    [closeBtn addTarget:self action:@selector(closePopupWindow) forControlEvents:UIControlEventTouchUpInside];
    [bigPanelView addSubview: closeBtn];
    
    //animation options
    UIViewAnimationOptions options = UIViewAnimationOptionTransitionFlipFromRight |
    UIViewAnimationOptionAllowUserInteraction    |
    UIViewAnimationOptionBeginFromCurrentState;
    
    //run the animation
    [UIView transitionFromView:fauxView toView:bigPanelView duration:animDuration options:options completion: ^(BOOL finished) {
        
        //dim the contents behind the popup window
        UIView* shadeView = [[[UIView alloc] initWithFrame:bigPanelView.frame] autorelease];
        shadeView.backgroundColor = [UIColor blackColor];
        shadeView.alpha = 0.0;
        shadeView.tag = kShadeViewTag;
        [bigPanelView addSubview: shadeView];
        [bigPanelView sendSubviewToBack: shadeView];
    }];
}

/**
 * Play Sound Effect
 */
-(void)playSoundEffect
{
    [audioPlayer play];
}

/**
 * Removes the window background and calls the animation of the window
 */
-(void)closePopupWindow
{
    //remove the shade
    [[bigPanelView viewWithTag: kShadeViewTag] removeFromSuperview];    
    [self performSelector:@selector(closePopupWindowAnimate) withObject:nil afterDelay:0.1];
    [audioPlayer play];
}

/**
 * Animates the window and when done removes all views from the view hierarchy
 * since they are all only retained by their superview this also deallocates them
 * finally deallocate the class instance
 */
-(void)closePopupWindowAnimate
{
    [self performSelector:@selector(playSoundEffect) withObject:nil afterDelay:soundEffectDuration];
    
    //faux view
    __block UIView* fauxView = [[UIView alloc] initWithFrame: CGRectMake(10, 10, 200, 200)];
    [bgView addSubview: fauxView];
    
    //run the animation
    UIViewAnimationOptions options = UIViewAnimationOptionTransitionFlipFromLeft |
    UIViewAnimationOptionAllowUserInteraction    |
    UIViewAnimationOptionBeginFromCurrentState;
    
    //hold to the bigPanelView, because it'll be removed during the animation
    [bigPanelView retain];
    
    [UIView transitionFromView:bigPanelView toView:fauxView duration:animDuration options:options completion:^(BOOL finished) {
        
        //when popup is closed, remove all the views
        for (UIView* child in bigPanelView.subviews) {
            [child removeFromSuperview];
        }
        for (UIView* child in bgView.subviews) {
            [child removeFromSuperview];
        }
        [bigPanelView release];
        [bgView removeFromSuperview];
        
        if (audioPlayer != Nil) {
            [audioPlayer release];
        }
        
        [self release];
        [cView setHidden:YES];
    }];
    [fauxView release];
}

@end
