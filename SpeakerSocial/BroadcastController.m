#import "BroadcastController.h"
#import "Network.h"
#import "HCYoutubeParser.h"

@implementation BroadcastController

- (void)viewDidLoad{
    [super viewDidLoad];
    self.statusText.text = self.selectedSong;
}

-(IBAction)broadcastButtonTapped:(id)sender{
    [self broadcast];
}

-(void)broadcast{
   NSDictionary *mp4 = [HCYoutubeParser h264videosWithYoutubeURL:[NSURL URLWithString:self.selectedSong]];
   NSLog(@"selected: %@",self.selectedSong);
   NSLog(@"mp4: %@", mp4);
   NSString* url = [[mp4 objectForKey:@"medium"] stringByReplacingOccurrencesOfString:@"&" withString:@"_-_-_-_-_"];
   NSString *params = [NSString stringWithFormat: @"title=%@&url=%@", @"song tittle", url];
   [Network httpASyncPost:@"http://speakersocial.herokuapp.com/song_info" : params];
}

@end
