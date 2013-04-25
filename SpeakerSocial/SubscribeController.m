#import "SubscribeController.h"
#import "Network.h"
#import "JSON.h"
#import "Audio.h"
#import "ClockSkew.h"
#import "GData.h"

@interface SubscribeController ()
@end

@implementation SubscribeController

dispatch_queue_t bgMonitor; 
dispatch_queue_t bgSync;
dispatch_queue_t bgLoadAudio;

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
}

- (void)viewDidLoad{
    [super viewDidLoad];
    bgLoadAudio = dispatch_queue_create("com.coshx.speakersocial.loadAudio", NULL);
    bgSync = dispatch_queue_create("com.coshx.speakersocial.syncClock", NULL);
    bgMonitor = dispatch_queue_create("com.coshx.speakersocial.monitorClock", NULL);
    [self monitorClock];
    [self syncClock];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(resync)
                                                 name:UIApplicationDidBecomeActiveNotification object:nil];
}

-(IBAction)selectSongToBroadcast:(id)sender{
}

-(IBAction)subscribeButtonTapped:(id)sender{
    [self loadAudio];
}


-(IBAction)returned:(UIStoryboardSegue *)segue {
    NSData *response = [Network httpGet:@"http://chielo.herokuapp.com/song_info"];
    
    if(response == NULL){
        self.quoteText.text = @"Connectivity problem... please try again later.";
        return ;
    }
    
    [self loadAudio];

}

-(void)resync{
    [self syncClock];
    if(self.audio.playing){
        [self loadAudio];
    }

}

-(void)monitorClock{
    dispatch_async(bgMonitor, ^(void) {
        NSLog(@"%f", [ClockSkew monitorClock]);
    });
    dispatch_async(bgMonitor, ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            NSLog(@"********LOST SYNC******");
            NSLog(@"-- resyncing --");
            self.quoteText.text = @"resyncing...";
            [self syncClock];
            if(self.audio.playing){
                [self loadAudio];
            }
            [self monitorClock];
        });
    });
}

-(void)syncClock{
    [self.progressBar startAnimating];
    dispatch_async(bgSync, ^(void) {
        self.clockSkew = [ClockSkew calculate];
    });
    dispatch_async(bgSync, ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            if(self.clockSkew==NULL){
                self.quoteText.text = @"Connectivity problem...";
                [NSThread sleepForTimeInterval:1];
                [self syncClock];
            }else{
                self.quoteText.text = @"";
                [self.activityView removeFromSuperview];
                [self.progressBar stopAnimating];
                NSLog(@"Syncing Complete - Skew: %@",self.clockSkew);
            }
        });
    });
}

-(void)loadAudio{
    
    [[self view] addSubview:self.progressBar];
    self.progressBar.center = self.view.center;
    [self.progressBar startAnimating];
    
    NSData* response = [Network httpGet:@"http://chielo.herokuapp.com/song_info"];
    if(response == NULL){
        self.quoteText.text = @"Connectivity problem...";
        [self.progressBar stopAnimating];
        [self.progressBar removeFromSuperview];
        return;
    };
    
    NSDictionary* songData = [JSON parse: response];
    self.quoteText.text = [NSString stringWithFormat:@"Song Title: %@", [songData objectForKey:@"title"]];
    
    double serverStartTime = [[songData objectForKey:@"serverStartTime"] doubleValue] ;
    double clientStartTime = serverStartTime - [self.clockSkew doubleValue];
    
    dispatch_async(bgLoadAudio, ^(void) {
        [self.audio = [[Audio alloc] init] load:[songData objectForKey:@"url"]];
    });
    
    dispatch_async(bgLoadAudio, ^{
       dispatch_async(dispatch_get_main_queue(), ^{
            [self.progressBar stopAnimating];
            [self.progressBar removeFromSuperview];
            [self.audio play:clientStartTime];
        });
   });

    
   }

@end
