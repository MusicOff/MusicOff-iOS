//
//  MusicOffViewController.h
//  MusicOff
//
//  Created by 태환 on 3/6/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "Timer.h"
#import "Accelerometer.h"
#import "PopUpWindow.h"

@class SettingViewController;

@interface MusicOffViewController : UIViewController <TimerDelegate, AVAudioPlayerDelegate>
{
    NSInteger currentTime;
    IBOutlet UIButton * HourUp;
    IBOutlet UIButton * MinuteTenUp;
    IBOutlet UIButton * MinuteOneUp;
    IBOutlet UIButton * AutoMusicOffButton;
    IBOutlet UIButton * HourDown;
    IBOutlet UIButton * MinuteTenDown;
    IBOutlet UIButton * MinuteOneDown;
    
    IBOutlet UIImageView * Hour;
    IBOutlet UIImageView * MinuteTen;
    IBOutlet UIImageView * MinuteOne;
    IBOutlet UIImageView * SecondTen;
    IBOutlet UIImageView * SecondOne;
    
    UILabel * HourLabel;
    UILabel * MinuteTenLabel;
    UILabel * MinuteOneLabel;
    UILabel * SecondTenLabel;
    UILabel * SecondOneLabel;
    
    IBOutlet UIButton * startButton;
    IBOutlet UILabel * startLabel;
    
    UIView * coverView;
    SettingViewController * settingViewController;
    Timer * timer;
	AVAudioPlayer * audioPlayer;
    
    PopUpWindow * popWindow1;
    PopUpWindow * popWindow2;
}
@property(nonatomic, retain) Timer * timer;

- (void)resetTimer;
- (IBAction)changeTime:(id)sender;

- (void)setSettingViewController:(SettingViewController *)viewController;
- (void)setCoverView:(UIView *)cview;
- (void)enableButtons;
- (void)disableButtons;

@end
