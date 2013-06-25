//
//  SettingViewController.m
//  MusicOff
//
//  Created by 태환 on 3/6/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SettingViewController.h"
#import "MusicOffViewController.h"

@interface SettingViewController ()

@end

@implementation SettingViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        accelerometer = [Accelerometer sharedInstance];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = NSLocalizedString(@"Setting", @"");
    self.view.backgroundColor = [UIColor clearColor];
    
    //place buttons setting
    placeButtons = [[NSMutableArray alloc] init];
    [placeButtons addObject:bed_Buttons];
    [placeButtons addObject:couch_Buttons];
    [placeButtons addObject:floor_Buttons];
    
    [bed_Buttons addTarget:self action:@selector(placeButtonOnAction:) forControlEvents:UIControlEventTouchUpInside];
    [couch_Buttons addTarget:self action:@selector(placeButtonOnAction:) forControlEvents:UIControlEventTouchUpInside];
    [floor_Buttons addTarget:self action:@selector(placeButtonOnAction:) forControlEvents:UIControlEventTouchUpInside];
    
    //volume buttons setting
    volumeButtons = [[NSMutableArray alloc] init];
    [volumeButtons addObject:volume_0_Button];
    [volumeButtons addObject:volume_1_Button];
    [volumeButtons addObject:volume_2_Button];
    [volumeButtons addObject:volume_3_Button];
    [volumeButtons addObject:volume_4_Button];
    
    [volume_0_Button addTarget:self action:@selector(volumeButtonOnAction:) forControlEvents:UIControlEventTouchUpInside];
    [volume_1_Button addTarget:self action:@selector(volumeButtonOnAction:) forControlEvents:UIControlEventTouchUpInside];
    [volume_2_Button addTarget:self action:@selector(volumeButtonOnAction:) forControlEvents:UIControlEventTouchUpInside];
    [volume_3_Button addTarget:self action:@selector(volumeButtonOnAction:) forControlEvents:UIControlEventTouchUpInside];
    [volume_4_Button addTarget:self action:@selector(volumeButtonOnAction:) forControlEvents:UIControlEventTouchUpInside];
    
    //app working test start button setting
    [appTestButton setImage:[UIImage imageNamed:@"sensitivity_test_button_choosed.png"] forState:UIControlStateSelected];
    [appTestButton setImage:[UIImage imageNamed:@"sensitivity_test_button_unchoosed_white.png"] forState:UIControlStateDisabled];
    [appTestButton addTarget:self action:@selector(appWorkingTestStart:) forControlEvents:UIControlEventTouchUpInside];
    accelerometer = [Accelerometer sharedInstance];
    
    //sensitivity slder setting
    sensitivitySlider = [[UISlider alloc] initWithFrame:CGRectMake(30, 360, 260, 2)];
    [sensitivitySlider setMinimumTrackImage:[UIImage imageNamed:@"sensitivity_bar.png"] forState:UIControlStateNormal];
    [sensitivitySlider setMaximumTrackImage:[UIImage imageNamed:@"sensitivity_bar.png"] forState:UIControlStateNormal];
    [sensitivitySlider trackRectForBounds:CGRectMake(0, 0, 260, 2)];
    [self.view addSubview:sensitivitySlider];
    [sensitivitySlider addTarget:self action:@selector(sensitivityValueChanged:) forControlEvents:UIControlEventValueChanged];
    
    [self defaultsButton:NO];
    
    NSURL *url = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource: @"POP"
                                                                        ofType: @"WAV"]];
	NSError *error;
	audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:&error];
    audioPlayer.delegate = self;
    audioPlayer.numberOfLoops = 1;
    
    NSURL *url2 = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource: @"CLICK5"
                                                                        ofType: @"WAV"]];
	NSError *error2;
	audioPlayer2 = [[AVAudioPlayer alloc] initWithContentsOfURL:url2 error:&error2];
    audioPlayer2.numberOfLoops = 1;
    
    [audioPlayer stop];
    [audioPlayer2 stop];
    
    audioPlayed = NO;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)dealloc
{
    [placeButtons release];
    [bed_Buttons release];
    [couch_Buttons release];
    [floor_Buttons release];
    
    [volumeButtons release];
    [volume_0_Button release];
    [volume_1_Button release];
    [volume_2_Button release];
    [volume_3_Button release];
    [volume_4_Button release];
    
    [appTestButton release];
    [appTestLabel release];
    
    [sensitivitySlider release];
    [sensorImage release];
    
    [musicOffViewController release];
    [accelerometer release];
    
    [audioPlayer release];
    [audioPlayer2 release];
    
    [super dealloc];
}

#pragma mark - UIButton Action
- (void)placeButtonOnAction:(id)sender
{
    UIButton * button = (UIButton *)sender;
    NSInteger placeValue = 0;
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    for (UIButton * placebutton in placeButtons) {
        if(placebutton != button)
            placebutton.selected = NO;
        else
        {
            placebutton.selected = YES;
            [defaults setInteger:placeValue forKey:@"placeValueKey"];
            [defaults synchronize];
        }
        placeValue++;
    }
}

- (void)volumeButtonOnAction:(id)sender
{
    UIButton * button = (UIButton *)sender;
    NSInteger volumeValue = 0;
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    for (UIButton * volumebutton in volumeButtons) {
        if(volumebutton != button)
            volumebutton.selected = NO;
        else
        {
            volumebutton.selected = YES;
            [defaults setInteger:volumeValue forKey:@"volumeValueKey"];
            [defaults synchronize];
        }
        volumeValue++;
    }
}

- (void)appWorkingTestStart:(id)sender
{
    appTestButton.selected =! appTestButton.selected;
    if(appTestButton.selected){
        [appTestLabel setText:NSLocalizedString(@"Test Stop", @"")];
        bed_Buttons.enabled = NO;
        couch_Buttons.enabled = NO;
        floor_Buttons.enabled = NO;
        volume_0_Button.enabled = NO;
        volume_1_Button.enabled = NO;
        volume_2_Button.enabled = NO;
        volume_3_Button.enabled = NO;
        volume_4_Button.enabled = NO;
        [self defaultsButton:YES];
        [musicOffViewController disableButtons];
        [accelerometer setDelegate:self];
        [accelerometer startTest];
        NSLog(@"Test Strated");
        
        [audioPlayer2 play];
    }
    else{
        [appTestLabel setText:NSLocalizedString(@"Test Start", @"")];
        bed_Buttons.enabled = YES;
        couch_Buttons.enabled = YES;
        floor_Buttons.enabled = YES;
        volume_0_Button.enabled = YES;
        volume_1_Button.enabled = YES;
        volume_2_Button.enabled = YES;
        volume_3_Button.enabled = YES;
        volume_4_Button.enabled = YES;
        [self defaultsButton:NO];
        [musicOffViewController enableButtons];
        [accelerometer stopTest];
        NSLog(@"Test Stoped");
        
        [audioPlayer2 play];
    }
}

- (void)sensitivityValueChanged:(id)sender
{
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    if (!sensitivitySliderEnable){
        sensitivitySlider.value = ((float)[defaults integerForKey:@"sensitivityValueKey"])/10;
        return;
    }
    UISlider * slider = (UISlider *)sender;
    NSInteger sensitivityValue = slider.value * 10 + 0.5;
    
    if (sensitivityValue > 10)
        sensitivityValue = 10;
    sensitivitySlider.value = ((float)sensitivityValue)/10;
    [defaults setInteger:sensitivityValue forKey:@"sensitivityValueKey"];
    [defaults synchronize];
}

#pragma mark - AccelerometerDelegate
- (void)stopTimerByAcc
{
    
}

- (void)alarmOn
{
    NSLog(@"Alarm ON");
    [self performSelectorInBackground:@selector(changeImage) withObject:nil];
}
     
- (void)changeImage
{    
    [sensorImage setImage:[UIImage imageNamed:@"alarm_choosed.png"]];
    if (audioPlayer != nil)
    {
        if(audioPlayed == NO)
        {
            [audioPlayer play];
            audioPlayed = YES;
        }
    }
}

- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{
    audioPlayed = NO;
    [sensorImage setImage:[UIImage imageNamed:@"alarm_unchoosed.png"]];
}

#pragma mark - defaults
- (void)defaultsButton:(BOOL)disabled
{
    [bed_Buttons setImage:[UIImage imageNamed:@"place_buttons_choosed.png"] forState:UIControlStateSelected];
    [couch_Buttons setImage:[UIImage imageNamed:@"place_buttons_choosed.png"] forState:UIControlStateSelected];
    [floor_Buttons setImage:[UIImage imageNamed:@"place_buttons_choosed.png"] forState:UIControlStateSelected];
    
    [bed_Buttons setImage:[UIImage imageNamed:@"place_button_unchoosed_white.png"] forState:UIControlStateDisabled];
    [couch_Buttons setImage:[UIImage imageNamed:@"place_button_unchoosed_white.png"] forState:UIControlStateDisabled];
    [floor_Buttons setImage:[UIImage imageNamed:@"place_button_unchoosed_white.png"] forState:UIControlStateDisabled];
    
    [volume_0_Button setImage:[UIImage imageNamed:@"volume_term_choosed.png"] forState:UIControlStateSelected];
    [volume_1_Button setImage:[UIImage imageNamed:@"volume_term_choosed.png"] forState:UIControlStateSelected];
    [volume_2_Button setImage:[UIImage imageNamed:@"volume_term_choosed.png"] forState:UIControlStateSelected];
    [volume_3_Button setImage:[UIImage imageNamed:@"volume_term_choosed.png"] forState:UIControlStateSelected];
    [volume_4_Button setImage:[UIImage imageNamed:@"volume_term_choosed.png"] forState:UIControlStateSelected];
    
    [volume_0_Button setImage:[UIImage imageNamed:@"volume_term_unchoosed_white.png"] forState:UIControlStateDisabled];
    [volume_1_Button setImage:[UIImage imageNamed:@"volume_term_unchoosed_white.png"] forState:UIControlStateDisabled];
    [volume_2_Button setImage:[UIImage imageNamed:@"volume_term_unchoosed_white.png"] forState:UIControlStateDisabled];
    [volume_3_Button setImage:[UIImage imageNamed:@"volume_term_unchoosed_white.png"] forState:UIControlStateDisabled];
    [volume_4_Button setImage:[UIImage imageNamed:@"volume_term_unchoosed_white.png"] forState:UIControlStateDisabled];
    
    [sensitivitySlider setThumbImage:[UIImage imageNamed:@"sensitivity_bar_button_unchoosed.png"] forState:UIControlStateNormal];
    [sensitivitySlider setThumbImage:[UIImage imageNamed:@"sensitivity_bar_button_choosed.png"] forState:UIControlStateHighlighted];
    
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	NSInteger newSettingDefaults = [defaults integerForKey:@"newSettingDefaultsKey"];
	NSInteger placeValue = [defaults integerForKey:@"placeValueKey"];
	NSInteger volumeValue = [defaults integerForKey:@"volumeValueKey"];
	NSInteger sensitivityValue = [defaults integerForKey:@"sensitivityValueKey"];
    
    if (newSettingDefaults == 0) {
        placeValue = 0;
        volumeValue = 0;
        sensitivityValue = 5;
        [defaults setInteger:1 forKey:@"newSettingDefaultsKey"];
        [defaults setInteger:placeValue forKey:@"placeValueKey"];
        [defaults setInteger:volumeValue forKey:@"volumeValueKey"];
        [defaults setInteger:sensitivityValue forKey:@"sensitivityValueKey"];
        [defaults synchronize];
    }
    
    if(!disabled){
        bed_Buttons.selected = NO;
        couch_Buttons.selected = NO;
        floor_Buttons.selected = NO;
        
        switch (placeValue) {
            case 0:
                bed_Buttons.selected = YES;
                break;
            case 1:
                couch_Buttons.selected = YES;
                break;
            case 2:
                floor_Buttons.selected = YES;
                break;
                
            default:
                break;
        }
        
        volume_0_Button.selected = NO;
        volume_1_Button.selected = NO;
        volume_2_Button.selected = NO;
        volume_3_Button.selected = NO;
        volume_4_Button.selected = NO;
        
        switch (volumeValue) {
            case 0:
                volume_0_Button.selected = YES;
                break;
            case 1:
                volume_1_Button.selected = YES;
                break;
            case 2:
                volume_2_Button.selected = YES;
                break;
            case 3:
                volume_3_Button.selected = YES;
                break;
            case 4:
                volume_4_Button.selected = YES;
                break;
                
            default:
                break;
        }
        
        switch (sensitivityValue) {
            case 0:
                [sensitivitySlider setValue:0.0];
                break;
            case 1:
                [sensitivitySlider setValue:0.1];
                break;
            case 2:
                [sensitivitySlider setValue:0.2];
                break;
            case 3:
                [sensitivitySlider setValue:0.3];
                break;
            case 4:
                [sensitivitySlider setValue:0.4];
                break;
            case 5:
                [sensitivitySlider setValue:0.5];
                break;
            case 6:
                [sensitivitySlider setValue:0.6];
                break;
            case 7:
                [sensitivitySlider setValue:0.7];
                break;
            case 8:
                [sensitivitySlider setValue:0.8];
                break;
            case 9:
                [sensitivitySlider setValue:0.9];
                break;
            case 10:
                [sensitivitySlider setValue:1.0];
                break;
                
            default:
                break;
        }
        sensitivitySliderEnable = YES;
    }
    else{
        bed_Buttons.selected = NO;
        couch_Buttons.selected = NO;
        floor_Buttons.selected = NO;
        
        switch (placeValue) {
            case 0:
                [bed_Buttons setImage:[UIImage imageNamed:@"place_buttons_choosed.png"] forState:UIControlStateDisabled];
                break;
            case 1:
                [couch_Buttons setImage:[UIImage imageNamed:@"place_buttons_choosed.png"] forState:UIControlStateDisabled];
                break;
            case 2:
                [floor_Buttons setImage:[UIImage imageNamed:@"place_buttons_choosed.png"] forState:UIControlStateDisabled];
                break;
                
            default:
                break;
        }
        
        volume_0_Button.selected = NO;
        volume_1_Button.selected = NO;
        volume_2_Button.selected = NO;
        volume_3_Button.selected = NO;
        volume_4_Button.selected = NO;
        
        switch (volumeValue) {
            case 0:
                [volume_0_Button setImage:[UIImage imageNamed:@"volume_term_choosed.png"] forState:UIControlStateDisabled];
                break;
            case 1:
                [volume_1_Button setImage:[UIImage imageNamed:@"volume_term_choosed.png"] forState:UIControlStateDisabled];
                break;
            case 2:
                [volume_2_Button setImage:[UIImage imageNamed:@"volume_term_choosed.png"] forState:UIControlStateDisabled];
                break;
            case 3:
                [volume_3_Button setImage:[UIImage imageNamed:@"volume_term_choosed.png"] forState:UIControlStateDisabled];
                break;
            case 4:
                [volume_4_Button setImage:[UIImage imageNamed:@"volume_term_choosed.png"] forState:UIControlStateDisabled];
                break;
                
            default:
                break;
        }
        
        switch (sensitivityValue) {
            case 0:
                [sensitivitySlider setValue:0.0];
                break;
            case 1:
                [sensitivitySlider setValue:0.1];
                break;
            case 2:
                [sensitivitySlider setValue:0.2];
                break;
            case 3:
                [sensitivitySlider setValue:0.3];
                break;
            case 4:
                [sensitivitySlider setValue:0.4];
                break;
            case 5:
                [sensitivitySlider setValue:0.5];
                break;
            case 6:
                [sensitivitySlider setValue:0.6];
                break;
            case 7:
                [sensitivitySlider setValue:0.7];
                break;
            case 8:
                [sensitivitySlider setValue:0.8];
                break;
            case 9:
                [sensitivitySlider setValue:0.9];
                break;
            case 10:
                [sensitivitySlider setValue:1.0];
                break;
                
            default:
                break;
        }
        sensitivitySliderEnable = NO;
        [sensitivitySlider setThumbImage:[UIImage imageNamed:@"sensitivity_bar_button_unchoosed_white.png"] forState:UIControlStateNormal];
        [sensitivitySlider setThumbImage:[UIImage imageNamed:@"sensitivity_bar_button_unchoosed_white.png"] forState:UIControlStateHighlighted];
    }
}

#pragma mark - View Controller
- (void)setMusicOffViewController:(MusicOffViewController *)viewController
{
    musicOffViewController = viewController;
}

- (void)enableButtons
{
    bed_Buttons.enabled = YES;
    couch_Buttons.enabled = YES;
    floor_Buttons.enabled = YES;
    volume_0_Button.enabled = YES;
    volume_1_Button.enabled = YES;
    volume_2_Button.enabled = YES;
    volume_3_Button.enabled = YES;
    volume_4_Button.enabled = YES;
    appTestButton.enabled = YES;
    sensitivitySlider.enabled = YES;
    [sensorImage setImage:[UIImage imageNamed:@"alarm_unchoosed.png"]];
    
    [self defaultsButton:NO];
}

- (void)disableButtons
{
    bed_Buttons.enabled = NO;
    couch_Buttons.enabled = NO;
    floor_Buttons.enabled = NO;
    volume_0_Button.enabled = NO;
    volume_1_Button.enabled = NO;
    volume_2_Button.enabled = NO;
    volume_3_Button.enabled = NO;
    volume_4_Button.enabled = NO;
    appTestButton.enabled = NO;
    [sensorImage setImage:[UIImage imageNamed:@"alarm_unchoosed_white.png"]];
    
    [self defaultsButton:YES];
}

@end
