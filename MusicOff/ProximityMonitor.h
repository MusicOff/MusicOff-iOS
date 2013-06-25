//
//  ProximityMonitor.h
//  Music Off
//
//  Created by 태환 on 7/15/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ProximityMonitor : NSObject
{
    
}
+ (ProximityMonitor *)sharedInstance;
- (void)proximityMonitorEnable:(BOOL)enabled;
@end
