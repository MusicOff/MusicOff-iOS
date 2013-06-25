//
//  Accelerometer.m
//  MusicOff
//
//  Created by 태환 on 3/6/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Accelerometer.h"

@implementation Accelerometer
static Accelerometer * singleTon;
@synthesize delegate;
+ (Accelerometer *)sharedInstance
{
    @synchronized(self)
    {
        if(singleTon == nil)
            singleTon = [[Accelerometer alloc] init];
    }
    return singleTon;
}

- (id)init
{
    self = [super init];
    if (self) {
        motionManager = [[CMMotionManager alloc] init];
        lx = ly = lz = 0.0;
        sensorSumInMinute = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)dealloc 
{
    [motionManager release];
    [sensorSumInMinute release];
    [singleTon release];
    [super dealloc];    
}

- (void)startTest
{
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    sensitivity = [defaults integerForKey:@"sensitivityValueKey"];
    place = [defaults integerForKey:@"placeValueKey"];
    switch (place) {
        case 0:
            speedThreadhold = 40;
            break;
        case 1:
            speedThreadhold = 35;
            break;
        case 2:
            speedThreadhold = 30;
            break;
            
        default:
            speedThreadhold = 40;
            break;
    }
    
    if(motionManager.gyroAvailable)
    {
        if(motionManager.gyroActive == NO)
        {
            motionManager.gyroUpdateInterval = 1.0/AccelerometerFrequency;
            
            NSOperationQueue * queue = [[NSOperationQueue alloc] init];
            
            [motionManager startGyroUpdatesToQueue:queue withHandler: 
             ^(CMGyroData *gyroData, NSError *error) 
             {
                 x = gyroData.rotationRate.x;
                 y = gyroData.rotationRate.y;
                 z = gyroData.rotationRate.z;
                 speed = fabs(x + y + z - lx - ly - lz) * SpeedBumping;
                 lx = x;
                 ly = y;
                 lz = z;
                 
                 if (speed > speedThreadhold - sensitivity/4) {
                     [delegate alarmOn];
                     NSLog(@"speed : %f",speed);
                 }
             }];
            [queue release];
        }  
    } 
    else 
    {
        NSLog(@"No gyroscope on device.");
        [motionManager release];
    }
}

- (void)stopTest
{
    lx = ly = lz = 0.0;
    [motionManager stopGyroUpdates];
}

- (void)startMusicOff
{
    sensorSum = 0.0;
    minuteCheck = 0;
    [sensorSumInMinute removeAllObjects];
    
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    sensitivity = [defaults integerForKey:@"sensitivityValueKey"];
    place = [defaults integerForKey:@"placeValueKey"];
    switch (place) {
        case 0:
            speedThreadhold = 40;
            break;
        case 1:
            speedThreadhold = 35;
            break;
        case 2:
            speedThreadhold = 30;
            break;
            
        default:
            speedThreadhold = 40;
            break;
    }
    
    if(motionManager.gyroAvailable)
    {
        if(motionManager.gyroActive == NO)
        {
            motionManager.gyroUpdateInterval = 1.0/AccelerometerFrequency;
            
            NSOperationQueue * queue = [[NSOperationQueue alloc] init];
            
            [motionManager startGyroUpdatesToQueue:queue withHandler: 
             ^(CMGyroData *gyroData, NSError *error) 
             {
                 x = gyroData.rotationRate.x;
                 y = gyroData.rotationRate.y;
                 z = gyroData.rotationRate.z;
                 speed = fabs(x + y + z - lx - ly - lz) * SpeedBumping;
                 lx = x;
                 ly = y;
                 lz = z;
                 if (speed > speedThreadhold - sensitivity/4) {
                     sensorSum += speed * speed / 2;
//                     NSLog(@"speed: %f, speed*speed : %f",speed, speed*speed/2);
                 } else{
                     sensorSum += speed;
//                     NSLog(@"speed: %f",speed);
                 }
                 
                 if (++minuteCheck >= AccelerometerFrequency*60) {
                     NSLog(@"%f",sensorSum);
                     [sensorSumInMinute addObject:[NSNumber numberWithDouble:sensorSum]];
                     minuteCheck = 0;
                     sensorSum = 0.0;
                     [self checkSensorArray];
                 }
             }];
            [queue release];
        }  
    } 
    else 
    {
        NSLog(@"No gyroscope on device.");
        [motionManager release];
    }
}

- (void)stopMusicOff
{
    lx = ly = lz = 0.0;
    [motionManager stopGyroUpdates];
}

- (void)checkSensorArray
{
    bool sizeCheck, minMaxCheck, maxCheck, minCheck;
    sizeCheck = minMaxCheck = maxCheck = minCheck = FALSE;
    int count = [sensorSumInMinute count];
    
    //Size Check
    if (count >= ArrayCheck)
        sizeCheck = TRUE;
    
    //finde Min
    double min = [[sensorSumInMinute objectAtIndex:count-1]doubleValue];
    if (count>=ArrayCheck){
        for (int i=count-1; i>=count-ArrayCheck; i--){
            if (min > [[sensorSumInMinute objectAtIndex:i]doubleValue]){
                min = [[sensorSumInMinute objectAtIndex:i]doubleValue];
            }
        }
    }
    else{
        for (int i=count-1; i>=0; i--){
            if (min > [[sensorSumInMinute objectAtIndex:i]doubleValue]){
                min = [[sensorSumInMinute objectAtIndex:i]doubleValue];
            }
        }
    }
    
    //MaxMinCheck
    int maxMinCount=0;
    minMaxCheck = TRUE;
    if (count>=ArrayCheck){
        for (int i=count-1; i>=count-ArrayCheck; i--){
            if ([[sensorSumInMinute objectAtIndex:i]doubleValue]>MaxArrayNumber){
                maxMinCount++;
            }
        }
    }
    else{
        for (int i=count-1; i>=0; i--){
            if ([[sensorSumInMinute objectAtIndex:i]doubleValue]>MaxArrayNumber){
                maxMinCount++;
            }
        }
    }
    if (maxMinCount>1)
        minMaxCheck = FALSE;
    
    //Maximum Check
    maxCheck = TRUE;
    if (count>=MaxArrayCheck){
        for (int i=count-1; i>=count-MaxArrayCheck; i--){
            if ([[sensorSumInMinute objectAtIndex:i]doubleValue]-min>MaxMinArrayNumber){
                maxCheck = FALSE;
            }
        }
    }
    else{
        for (int i=count-1; i>=0; i--){
            if ([[sensorSumInMinute objectAtIndex:i]doubleValue]-min>MaxMinArrayNumber){
                maxCheck = FALSE;
            }
        }
    }
    
    //Minimum Check
    if (min > MinArrayNumber)
        minCheck = TRUE;
         
    //Check to turn off Timer
    if (sizeCheck && minMaxCheck && minCheck && maxCheck) {
        lx = ly = lz = 0.0;
        [motionManager stopGyroUpdates];
        if([delegate respondsToSelector:@selector(stopTimerByAcc)])
            [delegate stopTimerByAcc];
    }
    
//    NSLog(@"size : %d, minMax : %d, min : %d, max : %d",sizeCheck, minMaxCheck, minCheck, maxCheck);
}

@end

