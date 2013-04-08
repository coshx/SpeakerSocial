#import "SubscribeController.h"
#import "Network.h"
#import "JSON.h"
#import "Audio.h"
#import "ClockSkew.h"

@interface SubscribeController ()
@end

@implementation SubscribeController

dispatch_queue_t backgroundQueue;


- (void)viewDidLoad{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.

    self.loadingView = [[UIView alloc] initWithFrame:CGRectMake(75, 155, 170, 250)];
    self.loadingView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:50 alpha:0.5];
    self.loadingView.clipsToBounds = YES;
    self.loadingView.layer.cornerRadius = 10.0;
    
    self.activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    self.activityView.frame = CGRectMake(65, 40, self.activityView.bounds.size.width, self.activityView.bounds.size.height);
    [self.loadingView addSubview:self.activityView];
    
    self.loadingLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 115, 130, 22)];
    self.loadingLabel.backgroundColor = [UIColor clearColor];
    self.loadingLabel.textColor = [UIColor whiteColor];
    self.loadingLabel.adjustsFontSizeToFitWidth = YES;
    self.loadingLabel.textAlignment = NSTextAlignmentCenter;
    self.loadingLabel.text = @"Syncing...";

    [self.loadingView addSubview:self.loadingLabel];
    [self.view addSubview:self.loadingView];
    [self.activityView startAnimating];
  
    backgroundQueue = dispatch_queue_create("com.coshx.speakersocial.bgqueue", NULL);
    
    dispatch_async(backgroundQueue, ^(void) {
        self.clockSkew = [ClockSkew calculate];
    });
    dispatch_async(backgroundQueue, ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.activityView stopAnimating];
            [self.loadingView removeFromSuperview];
        });
        NSLog(@"%@",@"Loading Complete");
    });

}

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)subscribeButtonTapped:(id)sender{
      //NSArray* songTitle = [song objectForKey:@"title"];
    //NSArray* songUrl = [song objectForKey:@"url"];
    

    NSDictionary* songData = [JSON parse: [Network httpGet:@"http://chielo.herokuapp.com/song_info"]];
   
    [self.audio = [[Audio alloc] init] load:[songData objectForKey:@"url"]];
   
    double serverStartTime = [[songData objectForKey:@"serverStartTime"] doubleValue] ;
    double now = [[NSDate date] timeIntervalSince1970]*1000;
    double clientStartTime = serverStartTime - [self.clockSkew doubleValue];
    double songPosition = 0.001*(now - clientStartTime);
    double songDuration = [self.audio duration];
    
    NSLog(@"%@",[songData objectForKey:@"title"]);

    
    if(songPosition>songDuration){
        self.quoteText.text = [NSString stringWithFormat:@"Song has ended, please broadcast again"];
    }else{
        [self.audio play:songPosition];
        self.quoteText.text = [NSString stringWithFormat:@"Clock Skew: %@", self.clockSkew];
    }
   // [self.audio mute];
}

-(IBAction)selectSongToBroadcast:(id)sender{
    }

-(IBAction)returned:(UIStoryboardSegue *)segue {
}

@end
