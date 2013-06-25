//
//  MusicOffViewController.m
//  MusicOff
//
//  Created by 태환 on 3/6/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MusicOffViewController.h"
#import "SettingViewController.h"

@implementation MusicOffViewController

@synthesize timer;

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
    // Do any additional setup after loading the view from its nib.
    self.title = NSLocalizedString(@"Music Off", @"");
    self.view.backgroundColor = [UIColor clearColor];
    
    //Timer
    [HourUp setImage:[UIImage imageNamed:@"arrow_up_unfocused.png"] forState:UIControlStateHighlighted];
    [MinuteTenUp setImage:[UIImage imageNamed:@"arrow_up_unfocused.png"] forState:UIControlStateHighlighted];
    [MinuteOneUp setImage:[UIImage imageNamed:@"arrow_up_unfocused.png"] forState:UIControlStateHighlighted];
    [HourDown setImage:[UIImage imageNamed:@"arrow_down_unfocused.png"] forState:UIControlStateHighlighted];
    [MinuteTenDown setImage:[UIImage imageNamed:@"arrow_down_unfocused.png"] forState:UIControlStateHighlighted];
    [MinuteOneDown setImage:[UIImage imageNamed:@"arrow_down_unfocused.png"] forState:UIControlStateHighlighted];
    
    [HourUp setImage:[UIImage imageNamed:@"arrow_up_focused_white.png"] forState:UIControlStateDisabled];
    [MinuteTenUp setImage:[UIImage imageNamed:@"arrow_up_focused_white.png"] forState:UIControlStateDisabled];
    [MinuteOneUp setImage:[UIImage imageNamed:@"arrow_up_focused_white.png"] forState:UIControlStateDisabled];
    [HourDown setImage:[UIImage imageNamed:@"arrow_down_focused_white.png"] forState:UIControlStateDisabled];
    [MinuteTenDown setImage:[UIImage imageNamed:@"arrow_down_focused_white.png"] forState:UIControlStateDisabled];
    [MinuteOneDown setImage:[UIImage imageNamed:@"arrow_down_focused_white.png"] forState:UIControlStateDisabled];
    
    HourLabel = [[UILabel alloc] initWithFrame:CGRectMake(4.5, 4.5, 28, 42)];
    [HourLabel setFont:[UIFont fontWithName:@"Arial" size:40.0f]];
    HourLabel.textAlignment = UITextAlignmentCenter;
    [HourLabel setBackgroundColor:[UIColor clearColor]];
    [Hour addSubview:HourLabel];
    
    MinuteTenLabel = [[UILabel alloc] initWithFrame:CGRectMake(4.5, 4.5, 28, 42)];
    [MinuteTenLabel setFont:[UIFont fontWithName:@"Arial" size:40.0f]];
    MinuteTenLabel.textAlignment = UITextAlignmentCenter;
    [MinuteTenLabel setBackgroundColor:[UIColor clearColor]];
    [MinuteTen addSubview:MinuteTenLabel];
    
    MinuteOneLabel = [[UILabel alloc] initWithFrame:CGRectMake(4.5, 4.5, 28, 42)];
    [MinuteOneLabel setFont:[UIFont fontWithName:@"Arial" size:40.0f]];
    MinuteOneLabel.textAlignment = UITextAlignmentCenter;
    [MinuteOneLabel setBackgroundColor:[UIColor clearColor]];
    [MinuteOne addSubview:MinuteOneLabel];
    
    SecondTenLabel = [[UILabel alloc] initWithFrame:CGRectMake(4.5, 4.5, 28, 42)];
    [SecondTenLabel setFont:[UIFont fontWithName:@"Arial" size:40.0f]];
    SecondTenLabel.textAlignment = UITextAlignmentCenter;
    [SecondTenLabel setBackgroundColor:[UIColor clearColor]];
    [SecondTen addSubview:SecondTenLabel];
    
    SecondOneLabel = [[UILabel alloc] initWithFrame:CGRectMake(4.5, 4.5, 28, 42)];
    [SecondOneLabel setFont:[UIFont fontWithName:@"Arial" size:40.0f]];
    SecondOneLabel.textAlignment = UITextAlignmentCenter;
    [SecondOneLabel setBackgroundColor:[UIColor clearColor]];
    [SecondOne addSubview:SecondOneLabel];
    
    //Auto Music Off Check Box
    [AutoMusicOffButton setImage:[UIImage imageNamed:@"checkbox_checked.png"] forState:UIControlStateSelected];
    [AutoMusicOffButton addTarget:self action:@selector(AutoMusicOffButtonOnAction) forControlEvents:UIControlEventTouchUpInside];
    
    //Start Stop Button
    [startButton setImage:[UIImage imageNamed:@"button_unfocused.png"] forState:UIControlStateSelected];
    [startButton setImage:[UIImage imageNamed:@"button_focused_white.png"] forState:UIControlStateDisabled];
    [startButton addTarget:self action:@selector(StartStopTimer) forControlEvents:UIControlEventTouchUpInside];
    timer = [Timer sharedInstance];
    [timer setDelegate:self];
    
    //defaults
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	NSInteger newMusicOffDefaults = [defaults integerForKey:@"newMusicOffDefaultsKey"];
    currentTime = [defaults integerForKey:@"currentTimeKey"];
    NSInteger autoMusicOffValue = [defaults integerForKey:@"autoMusicOffValueKey"];
    
    if (newMusicOffDefaults == 0) {
        currentTime = 60;
        autoMusicOffValue = 0;
        [defaults setInteger:1 forKey:@"newMusicOffDefaultsKey"];
        [defaults setInteger:currentTime forKey:@"currentTimeKey"];
        [defaults setInteger:autoMusicOffValue forKey:@"autoMusicOffValueKey"];
        [defaults synchronize];
    }
    
    [self resetTimer];
    
    if (autoMusicOffValue != 0){
        AutoMusicOffButton.selected = YES;
        [AutoMusicOffButton setImage:[UIImage imageNamed:@"checkbox_checked_white.png"] forState:UIControlStateDisabled];
    }
    else{
        AutoMusicOffButton.selected = NO;
        [AutoMusicOffButton setImage:[UIImage imageNamed:@"checkbox_unchecked_white.png"] forState:UIControlStateDisabled];
    }
    
    NSURL *url = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource: @"CLICK5"
                                                                        ofType: @"WAV"]];
	NSError *error;
	audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:&error];
    audioPlayer.delegate = self;
    audioPlayer.numberOfLoops = 1;
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
    [HourUp release];
    [HourDown release];
    [MinuteTenUp release];
    [MinuteTenDown release];
    [MinuteOneUp release];
    [MinuteOneDown release];
    
    [Hour release];
    [MinuteTen release];
    [MinuteOne release];
    [SecondTen release];
    [SecondOne release];
    
    [HourLabel release];
    [MinuteTenLabel release];
    [MinuteOneLabel release];
    [SecondTenLabel release];
    [SecondOneLabel release];
    
    [timer release];
    
    [AutoMusicOffButton release];
    [startButton release];
    [startLabel release];
    
    [audioPlayer release];
    
    [popWindow1 release];
    [popWindow2 release];
    
    [super dealloc];
}

#pragma mark - UIButton Action
- (IBAction)changeTime:(id)sender
{
    UIButton * changeButton = (UIButton *)sender;
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    if(changeButton.tag == 0) // HourUp
        currentTime += 60;
    else if(changeButton.tag == 1) // HourDown
        currentTime -= 60;
    else if(changeButton.tag == 2) // MinuteTenUp
        currentTime += 10;
    else if(changeButton.tag == 3) // MinuteTenDown
        currentTime -= 10;
    else if(changeButton.tag == 4) // MinuteOneUp
        currentTime += 1;
    else if(changeButton.tag == 5) // MinuteOneDown
        currentTime -= 1;
    
    [defaults setInteger:currentTime forKey:@"currentTimeKey"];
    [defaults synchronize];
    [self resetTimer];
}

- (void)AutoMusicOffButtonOnAction
{
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSInteger autoMusicOffValue;
    AutoMusicOffButton.selected = !AutoMusicOffButton.selected;
    if (AutoMusicOffButton.selected){
        autoMusicOffValue = 1;
        [AutoMusicOffButton setImage:[UIImage imageNamed:@"checkbox_checked_white.png"] forState:UIControlStateDisabled];
//        popWindow1 = [[PopUpWindow alloc] initWithSuperview:coverView];
    }
    else{
        autoMusicOffValue = 0;
        [AutoMusicOffButton setImage:[UIImage imageNamed:@"checkbox_unchecked_white.png"] forState:UIControlStateDisabled];
    }
    
    [defaults setInteger:autoMusicOffValue forKey:@"autoMusicOffValueKey"];
    [defaults synchronize];
}

- (void)StartStopTimer
{
    startButton.selected =! startButton.selected;
    if(startButton.selected){
        [startLabel setText:NSLocalizedString(@"S T O P", @"")];
        
//        if (AutoMusicOffButton.selected){
//            popWindow2 = [[PopUpWindow alloc] initWithSuperview:coverView];
//        }
        
        popWindow2 = [[PopUpWindow alloc] initWithSuperview:coverView];
        
        HourUp.enabled = NO;
        HourDown.enabled = NO;
        MinuteTenUp.enabled = NO;
        MinuteTenDown.enabled = NO;
        MinuteOneUp.enabled = NO;
        MinuteOneDown.enabled = NO;
        AutoMusicOffButton.selected = NO;
        AutoMusicOffButton.enabled = NO;
        [settingViewController disableButtons];
        
        NSInteger second = currentTime * 60;
        [timer startTimerwithReservedTime:second];
        NSLog(@"Music Off Strated");
    }
    else{
        [startLabel setText:NSLocalizedString(@"S T A R T", @"")];
        
        HourUp.enabled = YES;
        HourDown.enabled = YES;
        MinuteTenUp.enabled = YES;
        MinuteTenDown.enabled = YES;
        MinuteOneUp.enabled = YES;
        MinuteOneDown.enabled = YES;
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        if ([defaults integerForKey:@"autoMusicOffValueKey"] != 0)
            AutoMusicOffButton.selected = YES;
        else 
            AutoMusicOffButton.selected = NO;
        AutoMusicOffButton.enabled = YES;
        [settingViewController enableButtons];
        
        [timer stopTimer];
        NSLog(@"Music Off Stoped");
    }
    [audioPlayer play];
}

#pragma mark - TimerDelegate
- (void)resetTimer
{
    if (currentTime >= 10 * 60)
        currentTime = 10 * 60 - 1;
    if (currentTime < 0)
        currentTime = 0;
    HourLabel.text = [NSString stringWithFormat:@"%d",currentTime/60];
    if (currentTime < 60 )
        HourLabel.text = @"";
    MinuteTenLabel.text = [NSString stringWithFormat:@"%d",(currentTime % 60)/10];
    if (currentTime < 10 )
        MinuteTenLabel.text = @"";
    MinuteOneLabel.text = [NSString stringWithFormat:@"%d",currentTime%10];
    SecondTenLabel.text = @"0";
    SecondOneLabel.text = @"0";
    
    startButton.selected = NO;
    [startLabel setText:NSLocalizedString(@"S T A R T", @"")];
    
    HourUp.enabled = YES;
    HourDown.enabled = YES;
    MinuteTenUp.enabled = YES;
    MinuteTenDown.enabled = YES;
    MinuteOneUp.enabled = YES;
    MinuteOneDown.enabled = YES;
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if ([defaults integerForKey:@"autoMusicOffValueKey"] != 0)
        AutoMusicOffButton.selected = YES;
    else 
        AutoMusicOffButton.selected = NO;
    AutoMusicOffButton.enabled = YES;
    [settingViewController enableButtons];
}

- (void)timerChanged:(int)second
{
    HourLabel.text = [NSString stringWithFormat:@"%d",second/3600];
    if (second < 3600)
        HourLabel.text = @"";
    MinuteTenLabel.text = [NSString stringWithFormat:@"%d",(second % 3600)/600];
    if (second < 600)
        MinuteTenLabel.text = @"";
    MinuteOneLabel.text = [NSString stringWithFormat:@"%d",(second % 600)/60];
    SecondTenLabel.text = [NSString stringWithFormat:@"%d",(second % 60)/10];
    SecondOneLabel.text = [NSString stringWithFormat:@"%d",second%10];
}

#pragma mark - View Controller
- (void)setSettingViewController:(SettingViewController *)viewController
{
    settingViewController = viewController;
}

- (void)setCoverView:(UIView *)cview
{
    coverView = cview;
}

- (void)enableButtons
{
    HourUp.enabled = YES;
    HourDown.enabled = YES;
    MinuteTenUp.enabled = YES;
    MinuteTenDown.enabled = YES;
    MinuteOneUp.enabled = YES;
    MinuteOneDown.enabled = YES;
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if ([defaults integerForKey:@"autoMusicOffValueKey"] != 0)
        AutoMusicOffButton.selected = YES;
    else 
        AutoMusicOffButton.selected = NO;
    AutoMusicOffButton.enabled = YES;
    startButton.enabled = YES;
}

- (void)disableButtons
{
    HourUp.enabled = NO;
    HourDown.enabled = NO;
    MinuteTenUp.enabled = NO;
    MinuteTenDown.enabled = NO;
    MinuteOneUp.enabled = NO;
    MinuteOneDown.enabled = NO;
    AutoMusicOffButton.selected = NO;
    AutoMusicOffButton.enabled = NO;
    startButton.enabled = NO;
}

@end
