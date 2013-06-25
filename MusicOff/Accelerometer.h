//
//  Accelerometer.h
//  MusicOff
//
//  Created by 태환 on 3/6/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreMotion/CoreMotion.h>

#define AccelerometerFrequency 20
#define SpeedBumping 200
#define MaximumSensorArrayLength 600
#define ArrayCheck 15
#define MaxArrayCheck 7
#define MinArrayNumber 1000
#define MaxMinArrayNumber 25000
#define MaxArrayNumber 35000

@protocol AccelerometerDelegate <NSObject>
- (void) stopTimerByAcc;
- (void) alarmOn;
@end

@interface Accelerometer : NSObject
{
    CMMotionManager * motionManager;
    id<AccelerometerDelegate> delegate;
    
    double x,y,z,lx,ly,lz,speed,speedThreadhold;
    NSInteger sensitivity;
    NSInteger place;
    
    NSMutableArray * sensorSumInMinute;
    double sensorSum;
    NSInteger minuteCheck;
}
@property(nonatomic, retain) id<AccelerometerDelegate> delegate;
+ (Accelerometer *)sharedInstance;
- (void)startTest;
- (void)stopTest;
- (void)startMusicOff;
- (void)stopMusicOff;
- (void)checkSensorArray;

@end
