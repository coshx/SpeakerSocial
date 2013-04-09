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
    double now = [[NSDate date] timeIntervalSince1970]*1000;
    double clientStartTime = serverStartTime - [self.clockSkew doubleValue];
    double songPosition = 0.001*(now - clientStartTime);
    double songDuration = [self.audio duration];
    
    
    if(songPosition>songDuration){
        self.quoteText.text = [NSString stringWithFormat:@"Song has ended, please broadcast again"];
    }else{
        [self.audio play:songPosition];
        NSLog(@"%@",self.quoteText.text );
        
        self.quoteText.text = [NSString stringWithFormat:@"Clock Skew: %@", self.clockSkew];
        NSLog(@"%@",[songData objectForKey:@"title"]);
        
    }
   // [self.audio mute];
}

-(IBAction)selectSongToBroadcast:(id)sender{
}

-(IBAction)returned:(UIStoryboardSegue *)segue {
}

@end
