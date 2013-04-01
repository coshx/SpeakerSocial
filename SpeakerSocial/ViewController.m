#import "ViewController.h"
#import "Network.h"
#import "JSON.h"
#import "Audio.h"
@interface ViewController ()
@end

@implementation ViewController

- (void)viewDidLoad{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    self.audio = [[Audio alloc] init];
    
    [self.audio load];
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
    NSInteger songDuration = [self.audio duration];
    
    if(songPosition>songDuration){
        self.quoteText.text = [NSString stringWithFormat:@"Song has ended, please broadcast again"];
    }else{
        [self.audio play:songPosition];
        self.quoteText.text = [NSString stringWithFormat:@" audioPlayer.currentTime: %f", [self.audio currentTime]];
    }
}
-(IBAction)pauseButtonTapped:(id)sender{
    [self.audio mute];
}
@end
