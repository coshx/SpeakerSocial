#import "BroadcastController.h"
#import "Network.h"

@implementation BroadcastController

- (void)viewDidLoad{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    self.statusText.text = self.selectedSong;
}
-(IBAction)broadcastButtonTapped:(id)sender{
    NSString *params = [NSString stringWithFormat: @"title=%@&url=http://chielo.herokuapp.com/media/%@", self.selectedSong, self.selectedSong];
    [Network httpPost:@"http://chielo.herokuapp.com/song_info" : params];
}

@end
