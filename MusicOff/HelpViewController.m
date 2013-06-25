//
//  HelpViewController.m
//  MusicOff
//
//  Created by 태환 on 3/6/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "HelpViewController.h"

@interface HelpViewController ()

@end

@implementation HelpViewController

@synthesize scrollView;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = NSLocalizedString(@"Help", @"");
    self.view.backgroundColor = [UIColor clearColor];
    
    scrollView.frame = CGRectMake(0, 0, 320, 460);
    scrollView.contentSize = CGSizeMake(320, 918);
    scrollView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:scrollView];
}


- (void)viewDidUnload
{
    [super viewDidUnload];
    self.scrollView = nil;
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)dealloc
{
    [scrollView dealloc];
    [utpFacebook dealloc];
    [utpGmail dealloc];
    [super dealloc];
}

#pragma mark - IBActions

- (IBAction)gmail:(id)sender
{
    //mail App을 이용해서 메일 보내기
    NSString *subject = @"iPhone : Music Off";
    NSString *body = @"Thanks to Developer : Tae Hwan Kim";
    NSString *address = @"help.utopia@gmail.com";
    NSString *cc = @"";
    NSString *path = [NSString stringWithFormat:@"mailto:%@?cc=%@&subject=%@&body=%@", address, cc, subject, body];
    NSURL *url = [NSURL URLWithString:[path stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    if(![[UIApplication sharedApplication] openURL:url])
        NSLog(@"%@%@",@"Failed to open url:",[url description]);
}

- (IBAction)facebook:(id)sender
{
    //facebook app이 있을경우 app을 켬
    NSURL *url = [NSURL URLWithString:@"fb://page/189952777750322"];
    if(![[UIApplication sharedApplication] openURL:url])
    {
        NSURL *url = [NSURL URLWithString:@"http://m.facebook.com/utopia.musicoff"];
        if (![[UIApplication sharedApplication] openURL:url])
            NSLog(@"%@%@",@"Failed to open url:",[url description]);   
    }
}

@end
