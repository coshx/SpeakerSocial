#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
@interface ViewController : UIViewController
@property (nonatomic, strong) IBOutlet UITextView *quoteText;
@property (strong, nonatomic) AVAudioPlayer *audioPlayer;

- (IBAction)subscribeButtonTapped:(id)sender;
- (IBAction)broadcastButtonTapped:(id)sender;
- (IBAction)pauseButtonTapped:(id)sender;

- (void)playAudio:(double)position;
- (void)loadAudio;
- (NSInteger)songDuration;
- (void)mute;
@end
