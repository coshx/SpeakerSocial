//
//  ViewController.m
//  SpeakerSocial
//
//  Created by Chielo Zimmerman on 3/26/13.
//  Copyright (c) 2013 Coshx Labs, Inc. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    [self loadAudio];
}

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(IBAction)broadcastButtonTapped:(id)sender{
    [self httpPost:@"http://chielo.herokuapp.com/song_info" : @"title=Let The Meter Run&url=http://chielo.herokuapp.com/media/Meter.mp3"];
}

-(IBAction)subscribeButtonTapped:(id)sender{
    NSDictionary* song = [self json: [self httpGet:@"http://chielo.herokuapp.com/song_info"]];
    //NSArray* songTitle = [song objectForKey:@"title"];
    //NSArray* songUrl = [song objectForKey:@"url"];
    NSString* songStart = [song objectForKey:@"serverStartTime"];
    double songPosition = ([[NSDate date] timeIntervalSince1970]*1000 - [songStart doubleValue])/1000 ;
   
    if(songPosition>audioPlayer.duration){
        self.quoteText.text = [NSString stringWithFormat:@"Song has ended, please broadcast again"];
    }else
        [self playAudio:(songPosition)];
}

-(IBAction)pauseButtonTapped:(id)sender{
    audioPlayer.volume = 0.0;
    [audioPlayer pause];  //[audioPlayer stop];
}

-(void)playAudio:(double)position{
    audioPlayer.volume = 1.0;
    audioPlayer.currentTime = position;
    self.quoteText.text = [NSString stringWithFormat:@" audioPlayer.currentTime: %f", audioPlayer.currentTime];
}

-(void)loadAudio{
    NSURL *url = [NSURL fileURLWithPath:[NSString stringWithFormat:@"%@/meter.mp3", [[NSBundle mainBundle] resourcePath]]];
	NSError *error;
	audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:&error];
	audioPlayer.numberOfLoops = -1;
    if (audioPlayer == nil)
        NSLog(@"%@",[error description]);
    else{
		[audioPlayer play];
        audioPlayer.volume = 0.0;
    }
}
- (NSDictionary*)json:(NSData*)data {
    NSError* error;
    NSDictionary* json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    return json;
}
-(NSData*)httpGet: (NSString*)url{
    NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
    NSURLResponse *resp = nil;
    NSError *err = nil;
    NSData *response = [NSURLConnection sendSynchronousRequest: theRequest returningResponse: &resp error: &err];
    //NSString * response_string = [[NSString alloc] initWithData:response encoding:NSUTF8StringEncoding];
    return response;
}
-(NSString*)httpPost: (NSString*)url :(NSString*)data{
    NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
    [theRequest setHTTPMethod:@"POST"];
    [theRequest setHTTPBody:[data dataUsingEncoding:NSUTF8StringEncoding]];
    NSURLResponse *resp = nil;
    NSError *err = nil;
    NSData *response = [NSURLConnection sendSynchronousRequest: theRequest returningResponse: &resp error: &err];
    NSString * response_string = [[NSString alloc] initWithData:response encoding:NSUTF8StringEncoding];
    return response_string;
}
@end
