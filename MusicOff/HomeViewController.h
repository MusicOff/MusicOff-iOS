//
//  HomeViewController.h
//  MusicOff
//
//  Created by 태환 on 3/6/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMailComposeViewController.h>

@interface HomeViewController : UIViewController <MFMailComposeViewControllerDelegate>
{
    IBOutlet UIButton *devFacebook;
    IBOutlet UIButton *dsgBlog;
    IBOutlet UIButton *mkrBlog;
}

- (IBAction)facebook:(id)sender;
- (IBAction)blog:(id)sender;

@end
