//
//  HelpViewController.h
//  MusicOff
//
//  Created by 태환 on 3/6/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HelpViewController : UIViewController
{
    IBOutlet UIScrollView * scrollView;
    IBOutlet UIButton *utpFacebook;
    IBOutlet UIButton *utpGmail;
}

@property (nonatomic, retain) UIScrollView * scrollView;
- (IBAction)facebook:(id)sender;
- (IBAction)gmail:(id)sender;

@end
