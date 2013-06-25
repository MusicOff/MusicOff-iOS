//
//  Timer.m
//  MusicOff
//
//  Created by 태환 on 3/6/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Timer.h"

@implementation Timer
static Timer * singleTon;
@synthesize delegate;
@synthesize isRunning;
@synthesize autoON;

+ (Timer *)sharedInstance
{
    @synchronized(self)
    {
        if(singleTon == nil)
            singleTon = [[Timer alloc] init];
    }
    
    return singleTon;
}

- (id)init
{
    self = [super init];
    if (self) {
        accelerometer = [Accelerometer sharedInstance];
        proximityMonitor = [ProximityMonitor sharedInstance];
        musicPlayer = [MPMusicPlayerController iPodMusicPlayer];
        isRunning = NO;
        autoON = NO;
        stoped = NO;
    }
    
    return self;
}

- (void)dealloc 
{
    [timerNS release];
    [accelerometer release];
    [proximityMonitor release];
    [musicPlayer release];
    [singleTon release];
    [super dealloc];    
}

- (void)startTimerwithReservedTime:(NSInteger)reserved
{
    isRunning = YES;
    autoON = NO;
    autoWorked = NO;
    
    reservedTime = reserved;
    timerNS = [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(onTimer:) userInfo:nil repeats:YES];    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if ([defaults integerForKey:@"autoMusicOffValueKey"] != 0)
    {
        [accelerometer startMusicOff];
        [accelerometer setDelegate:self];   
        autoON = YES;
    }
    [proximityMonitor proximityMonitorEnable:YES];
    [[ UIApplication sharedApplication ] setIdleTimerDisabled: YES];
    
    [self createLocalNotification:(NSTimeInterval)reserved];
}

- (void)onTimer:(NSTimer *)timer
{
    if (reservedTime>0)
        reservedTime--;
    if([delegate respondsToSelector:@selector(timerChanged:)])
        [delegate timerChanged:reservedTime];
    if(reservedTime <= 0) {
        [self volumeDown];
    }
}

- (void)stopTimer
{
    if (timerNS != nil && [timerNS isValid]) {
        [timerNS invalidate];
        timerNS = nil;
    }
    [accelerometer stopMusicOff];
    [proximityMonitor proximityMonitorEnable:NO];
    [[ UIApplication sharedApplication ] setIdleTimerDisabled: NO];
    if([delegate respondsToSelector:@selector(resetTimer)])
        [delegate resetTimer];
    
    //enumerationQueue stop
    stoped = YES;
    isRunning = NO;
    
    //Local Notification stop
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
}

- (void)volumeDown
{
    autoON = NO;
    if (timerNS != nil && [timerNS isValid]) {
        [timerNS invalidate];
        timerNS = nil;
    }
    [accelerometer stopMusicOff];
    
    lastVolume = [musicPlayer volume]*16;
    NSLog(@"currentVoluem : %f",lastVolume);
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	NSInteger volumeValue = [defaults integerForKey:@"volumeValueKey"];
    double volumeDownTerm = 0.0;
    
    if (lastVolume < 1.5) {
        volumeDownTerm = 0;
    } else {
        switch (volumeValue) {
            case 0:
                volumeDownTerm = 0.0;
                break;
            case 1:
                volumeDownTerm = 2/(lastVolume-1);
                break;
            case 2:
                volumeDownTerm = 4/(lastVolume-1);
                break;
            case 3:
                volumeDownTerm = 8/(lastVolume-1);
                break;
            case 4:
                volumeDownTerm = 16/(lastVolume-1);
                break;
                
            default:
                volumeDownTerm = 0.0;
                break;
        }
    }
    NSLog(@"volumeValue : %d, volumeDownTerm : %f",volumeValue,volumeDownTerm);
    
    stoped = NO;
    enumerationQueue = dispatch_queue_create("Browser Enumeration Queue", DISPATCH_QUEUE_SERIAL);
    dispatch_async(enumerationQueue, ^(void){
        while ([musicPlayer volume] > 0 && !stoped) {
            [musicPlayer setVolume:([musicPlayer volume]*16-1)/16];
            for (int i=0; i<volumeDownTerm*40; i++) {
                if (!stoped)
                    sleep(1);
                else
                    break;
            }
        }
        if (!stoped)
            [self performSelectorOnMainThread:@selector(musicOff) withObject:nil waitUntilDone:NO];
    });
}

- (void)musicOff
{
    //Music Off
    [[AVAudioSession sharedInstance] setCategory: AVAudioSessionCategorySoloAmbient error: nil];
    [[AVAudioSession sharedInstance] setActive: YES error: nil];
    
    [[AVAudioSession sharedInstance] setCategory: AVAudioSessionCategoryAmbient error: nil];
    [[AVAudioSession sharedInstance] setActive: YES error: nil];

    if([delegate respondsToSelector:@selector(resetTimer)])
        [delegate resetTimer];
    enumerationQueue2 = dispatch_queue_create("Browser Enumeration Queue", DISPATCH_QUEUE_SERIAL);
    dispatch_async(enumerationQueue2, ^(void){
        sleep(0.5);
        [musicPlayer setVolume:lastVolume/16];
    });
    [proximityMonitor proximityMonitorEnable:NO];
    [[ UIApplication sharedApplication ] setIdleTimerDisabled: NO];
    
    isRunning = NO;
}

- (void)restartAcc
{
    [accelerometer startMusicOff];
    [accelerometer setDelegate:self];
    NSLog(@"restart ACC");
}

#pragma mark - Local Noti
- (void) createLocalNotification:(NSTimeInterval) interval
{
    NSDate * notificationDate = [NSDate dateWithTimeIntervalSinceNow:interval];
    
    //Create Local Noti
    UILocalNotification * localNotification = [[UILocalNotification alloc] init];
    localNotification.fireDate = notificationDate;
    localNotification.timeZone = [NSTimeZone defaultTimeZone];
    
    //Local Noti Prop
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MM/dd a hh:mm:ss"];
    if (autoWorked) {
        localNotification.alertBody = [NSString stringWithFormat:@"%@ \n%@",[formatter stringFromDate:[NSDate date]],NSLocalizedString(@"Automatically Music turned Off", @"")];
    } else {
        localNotification.alertBody = [NSString stringWithFormat:@"%@ \n%@",[formatter stringFromDate:[NSDate date]],NSLocalizedString(@"Music turned Off", @"")];
    }
    [formatter release];
    
    localNotification.alertAction = nil;
//    localNotification.soundName = UILocalNotificationDefaultSoundName;
    localNotification.applicationIconBadgeNumber = 1;
    [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
    [localNotification release];
}

#pragma mark - AccelerometerDelegate
- (void)stopTimerByAcc
{
    autoWorked = YES;
    [self volumeDown];
}

- (void)alarmOn
{
    
}

@end
