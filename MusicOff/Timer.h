//
//  Timer.h
//  MusicOff
//
//  Created by 태환 on 3/6/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>
#import "Accelerometer.h"
#import "ProximityMonitor.h"

@class AppDelegate;

@protocol TimerDelegate <NSObject>
- (void) resetTimer;
- (void) timerChanged:(int)second;
@end

@interface Timer : NSObject<AccelerometerDelegate, AVAudioPlayerDelegate>
{
    NSTimer * timerNS;
    NSInteger reservedTime;
    id<TimerDelegate> delegate;
    Accelerometer * accelerometer;
    ProximityMonitor * proximityMonitor;
    MPMusicPlayerController * musicPlayer;
    float lastVolume;
    
    BOOL isRunning;
    BOOL autoON;
    BOOL autoWorked;
    
    dispatch_queue_t enumerationQueue;
    BOOL stoped;
    dispatch_queue_t enumerationQueue2;
}
@property(nonatomic, retain) id<TimerDelegate> delegate;
@property(readwrite) BOOL isRunning;
@property(readwrite) BOOL autoON;

+ (Timer *)sharedInstance;
- (void)startTimerwithReservedTime:(NSInteger)reserved;
- (void)stopTimer;
- (void)restartAcc;
@end
