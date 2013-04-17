#import "BroadcastController.h"
#import "Network.h"

@implementation BroadcastController

- (void)viewDidLoad{
    [super viewDidLoad];
    self.statusText.text = self.selectedSong;
}

-(IBAction)broadcastButtonTapped:(id)sender{
    NSString *params = [NSString stringWithFormat: @"title=%@&url=http://chielo.herokuapp.com/media/%@", self.selectedSong, self.selectedSong];
    [Network httpASyncPost:@"http://chielo.herokuapp.com/song_info" : params];
}

@end
