//
//  PopUpWindow.h
//  Music Off
//
//  Created by 태환 on 6/14/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

@interface PopUpWindow : NSObject <AVAudioPlayerDelegate>
{
    UIView* bgView;
    UIView* bigPanelView;
    
	AVAudioPlayer * audioPlayer;
    UIView* cView;
}

- (id)initWithSuperview:(UIView*)sview;

@end
