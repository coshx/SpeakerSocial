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
	 
    [self.progressBar startAnimating];
  
    backgroundQueue = dispatch_queue_create("com.coshx.speakersocial.bgqueue", NULL);
    
    dispatch_async(backgroundQueue, ^(void) {
        self.clockSkew = [ClockSkew calculate];
    });
    dispatch_async(backgroundQueue, ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.progressBar stopAnimating];
            [self.activityView removeFromSuperview];
            self.quoteText.text = [NSString stringWithFormat:@"Clock Skew: %@", self.clockSkew];
            NSLog(@"%@",@"Syncing Complete");
        });
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
    double clientStartTime = serverStartTime - [self.clockSkew doubleValue];
    [self.audio play:clientStartTime];

}

-(IBAction)selectSongToBroadcast:(id)sender{
}

-(IBAction)returned:(UIStoryboardSegue *)segue {
}

@end
