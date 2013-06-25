//
//  HomeViewController.m
//  MusicOff
//
//  Created by 태환 on 3/6/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "HomeViewController.h"

@implementation HomeViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = NSLocalizedString(@"Home", @"");
    self.view.backgroundColor = [UIColor clearColor];
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
    [devFacebook dealloc];
    [dsgBlog dealloc];
    [mkrBlog dealloc];
    
    [super dealloc];
}

#pragma mark - IBActions

- (IBAction)facebook:(id)sender
{
    //facebook app이 있을경우 app을 켬
    NSURL *url = [NSURL URLWithString:@"fb://page/100000237826574"];
    if(![[UIApplication sharedApplication] openURL:url])
    {
        NSURL *url = [NSURL URLWithString:@"http://m.facebook.com/thefinestartist"];
        if (![[UIApplication sharedApplication] openURL:url])
            NSLog(@"%@%@",@"Failed to open url:",[url description]);   
    }
}

- (IBAction)blog:(id)sender
{
    UIButton * blogButton = (UIButton *)sender;
    if(blogButton.tag == 0) // Designer
    {
        NSURL *url = [NSURL URLWithString:@"http://blog.naver.com/pnh1936"];
        if(![[UIApplication sharedApplication] openURL:url])
            NSLog(@"%@%@",@"Failed to open url:",[url description]);
    }
    
    if(blogButton.tag == 1) // Marketer
    {
        NSURL *url = [NSURL URLWithString:@"http://blog.naver.com/layla_lalee"];
        if(![[UIApplication sharedApplication] openURL:url])
            NSLog(@"%@%@",@"Failed to open url:",[url description]);
    }
    
}

@end
