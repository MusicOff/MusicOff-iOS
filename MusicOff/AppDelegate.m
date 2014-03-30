//
//  AppDelegate.m
//  MusicOff
//
//  Created by 태환 on 3/6/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate (internal) 
- (void)setinitView;
@end

@implementation AppDelegate

@synthesize window = _window;
@synthesize managedObjectContext = __managedObjectContext;
@synthesize managedObjectModel = __managedObjectModel;
@synthesize persistentStoreCoordinator = __persistentStoreCoordinator;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    int screenHeight = [[UIScreen mainScreen] bounds].size.height;
    UIImageView * Bg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, screenHeight)];
    [Bg setImage:[UIImage imageNamed:@"background.png"]];
    pageViewController = [[PageViewController alloc] init];
    pageViewController.view.frame = CGRectMake(0, 20, 320, screenHeight - 20);
    
    UIWindow * window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window = window;
    [window release];
    [self.window addSubview:Bg];
    [Bg release];
    [self.window addSubview:pageViewController.view];
    
    [self.window makeKeyAndVisible];
    
    _timer = pageViewController.musicOffViewController.timer;
    
    //Local Alarm
    UILocalNotification * localNotification = [launchOptions objectForKey:UIApplicationLaunchOptionsLocalNotificationKey];
    if (localNotification) {
        NSLog(@"Local Noti get when the app tur");
    }
    
    return YES;
}

- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification
{
    NSLog(@"Receive Local Notification");
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
     */
    application.applicationIconBadgeNumber = 0;
    
    if ([[UIDevice currentDevice] respondsToSelector:@selector(isMultitaskingSupported)]) { //Check if our iOS version supports multitasking I.E iOS 4
		if ([[UIDevice currentDevice] isMultitaskingSupported]) { //Check if device supports mulitasking
            
			__block UIBackgroundTaskIdentifier background_task; //Create a task object
            
			background_task = [application beginBackgroundTaskWithExpirationHandler: ^ {
				[application endBackgroundTask: background_task]; //Tell the system that we are done with the tasks
				background_task = UIBackgroundTaskInvalid; //Set the task to be invalid
                
				//System will be shutting down the app at any point in time now
			}];
            
			//Background tasks require you to use asyncrous tasks
            
			dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
				//Perform your tasks that your application requires
                NSLog(@"Running in the background!");
                if(_timer.isRunning)
                    sleep(600);
                NSLog(@"Running in the background Ended!");
				[application endBackgroundTask: background_task]; //End the task so the system knows that you are done with what you need to perform
				background_task = UIBackgroundTaskInvalid; //Invalidate the background_task
			});
		}
	}
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    /*
     Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
     */
    
    if ([[UIDevice currentDevice] respondsToSelector:@selector(isMultitaskingSupported)]) { //Check if our iOS version supports multitasking I.E iOS 4
		if ([[UIDevice currentDevice] isMultitaskingSupported]) { //Check if device supports mulitasking
            NSLog(@"Running in the foreground!");
            
            if (_timer.isRunning)
            {
                [self showAlertView];
                [_timer restartAcc];
            }
		}
	}
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
    application.applicationIconBadgeNumber = 0;
    
    [[AVAudioSession sharedInstance] setCategory: AVAudioSessionCategoryAmbient error: nil];
    [[AVAudioSession sharedInstance] setActive: YES error: nil];
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Saves changes in the application's managed object context before the application terminates.
}

- (void)dealloc
{
    [fadeInOutView release];
    [_window release];
    [super dealloc];
}

#pragma mark - UIAlertView
-(void)showAlertView
{
    UIAlertView *av = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Music Off", @"") message:NSLocalizedString(@"Timer Reactivated!!", @"") delegate:nil cancelButtonTitle:NSLocalizedString(@"OK", @"") otherButtonTitles:nil, nil];
    av.delegate = self;
    [av show];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [alertView release];
}

@end
