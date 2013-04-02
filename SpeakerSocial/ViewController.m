#import "ViewController.h"
#import "Network.h"
#import "JSON.h"
#import "Audio.h"
#import "ClockSkew.h"

@interface ViewController ()
@end

@implementation ViewController

- (void)viewDidLoad{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    self.clockSkew = [ClockSkew calculate];
    [self.audio = [[Audio alloc] init] load];
    
}
- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)broadcastButtonTapped:(id)sender{
    [Network httpPost:@"http://chielo.herokuapp.com/song_info" : @"title=Let The Meter Run&url=http://chielo.herokuapp.com/media/Meter.mp3"];
}

-(IBAction)subscribeButtonTapped:(id)sender{
    //NSArray* songTitle = [song objectForKey:@"title"];
    //NSArray* songUrl = [song objectForKey:@"url"];
    NSDictionary* songData = [JSON parse: [Network httpGet:@"http://chielo.herokuapp.com/song_info"]];
    double serverStartTime = [[songData objectForKey:@"serverStartTime"] doubleValue] ;
    double now = [[NSDate date] timeIntervalSince1970]*1000;
    double clientStartTime = serverStartTime - [self.clockSkew doubleValue];
    double songPosition = 0.001*(now - clientStartTime);
    double songDuration = [self.audio duration];
    if(songPosition>songDuration){
        self.quoteText.text = [NSString stringWithFormat:@"Song has ended, please broadcast again"];
    }else{
        [self.audio play:songPosition];
        self.quoteText.text = [NSString stringWithFormat:@"Clock Skew: %@", self.clockSkew];
    }
}

-(IBAction)pauseButtonTapped:(id)sender{
    [self.audio mute];
}


@end
