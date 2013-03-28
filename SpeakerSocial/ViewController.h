//
//  ViewController.h
//  SpeakerSocial
//
//  Created by Chielo Zimmerman on 3/26/13.
//  Copyright (c) 2013 Coshx Labs, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>


@interface ViewController : UIViewController{
    AVAudioPlayer *audioPlayer;
}

@property (nonatomic, strong) IBOutlet UITextView *quoteText;

- (IBAction)subscribeButtonTapped:(id)sender;

- (IBAction)broadcastButtonTapped:(id)sender;

- (IBAction)pauseButtonTapped:(id)sender;

-(NSString*)httpGet:(NSString*)url;

-(NSString*)httpPost: (NSString*)url :(NSString*)data;



@end
