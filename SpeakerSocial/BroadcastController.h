
#import <UIKit/UIKit.h>

@interface BroadcastController : UIViewController
@property (strong, nonatomic) NSString* selectedSong;
@property (strong, nonatomic) NSString* selectedSongTitle;
@property (nonatomic, strong) IBOutlet UITextView *statusText;
- (IBAction)broadcastButtonTapped:(id)sender;
@end
