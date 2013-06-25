//
//  SettingViewController.h
//  MusicOff
//
//  Created by 태환 on 3/6/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "Accelerometer.h"

#define AlarmOnTime 0.1

@class MusicOffViewController;

@interface SettingViewController : UIViewController <AccelerometerDelegate, AVAudioPlayerDelegate>
{
    NSMutableArray * placeButtons;
    IBOutlet UIButton * bed_Buttons;
    IBOutlet UIButton * couch_Buttons;
    IBOutlet UIButton * floor_Buttons;
    
    NSMutableArray * volumeButtons;
    IBOutlet UIButton * volume_0_Button;
    IBOutlet UIButton * volume_1_Button;
    IBOutlet UIButton * volume_2_Button;
    IBOutlet UIButton * volume_3_Button;
    IBOutlet UIButton * volume_4_Button;
    
    IBOutlet UIButton * appTestButton;
    IBOutlet UILabel * appTestLabel;
    IBOutlet UIImageView * sensorImage;
    
    UISlider * sensitivitySlider;
    BOOL sensitivitySliderEnable;
    
    MusicOffViewController * musicOffViewController;
    Accelerometer * accelerometer;
	AVAudioPlayer * audioPlayer;
	AVAudioPlayer * audioPlayer2;
    BOOL audioPlayed;
}

- (void)setMusicOffViewController:(MusicOffViewController *)viewController;
- (void)enableButtons;
- (void)disableButtons;

@end
