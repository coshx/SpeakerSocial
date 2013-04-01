#import "ViewController.h"
#import "Network.h"
#import "JSON.h"
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
    [Network httpPost:@"http://chielo.herokuapp.com/song_info" : @"title=Let The Meter Run&url=http://chielo.herokuapp.com/media/Meter.mp3"];
}
-(IBAction)subscribeButtonTapped:(id)sender{
    NSDictionary* songData = [JSON parse: [Network httpGet:@"http://chielo.herokuapp.com/song_info"]];
    //NSArray* songTitle = [song objectForKey:@"title"];
    //NSArray* songUrl = [song objectForKey:@"url"];
    double songPosition = ([[NSDate date] timeIntervalSince1970]*1000 - [[songData objectForKey:@"serverStartTime"] doubleValue])/1000 ;
    NSInteger songDuration = [self songDuration];
    if(songPosition>songDuration){
        self.quoteText.text = [NSString stringWithFormat:@"Song has ended, please broadcast again"];
    }else
        [self playAudio:songPosition];
}
-(IBAction)pauseButtonTapped:(id)sender{
    [self mute];
}
-(void)playAudio:(double)position{
    self.audioPlayer.volume = 1.0;
    self.audioPlayer.currentTime = position;
    self.quoteText.text = [NSString stringWithFormat:@" audioPlayer.currentTime: %f", self.audioPlayer.currentTime];

}
-(void)loadAudio{
    NSURL *url = [NSURL URLWithString:@"http://chielo.herokuapp.com/media/Meter.mp3"];
    NSData *data = [NSData dataWithContentsOfURL:url];
    self.audioPlayer = [[AVAudioPlayer alloc] initWithData:data error:nil];
	self.audioPlayer.numberOfLoops = 1;
    if (self.audioPlayer == nil)
        NSLog(@"%@",@"Error loadAudio - Unable to load audio");
    else{
        [self.audioPlayer play];
        self.audioPlayer.volume = 0.0;
    }
}
-(NSInteger)songDuration{
    return self.audioPlayer.duration;
}
-(void)mute{
    self.audioPlayer.volume = 0.0;
    //[self.audioPlayer pause];  //[audioPlayer stop];
}

@end
