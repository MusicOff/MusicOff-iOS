//
//  ProximityMonitor.m
//  Music Off
//
//  Created by 태환 on 7/15/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ProximityMonitor.h"

@implementation ProximityMonitor
static ProximityMonitor * singleTon;
+ (ProximityMonitor *)sharedInstance
{
    @synchronized(self)
    {
        if(singleTon == nil)
            singleTon = [[ProximityMonitor alloc] init];
    }
    return singleTon;
}

- (void)dealloc
{
    [singleTon release];
    [super dealloc];
}

- (void)proximityMonitorEnable:(BOOL)enabled
{
    [UIDevice currentDevice].proximityMonitoringEnabled = enabled;
}

@end
