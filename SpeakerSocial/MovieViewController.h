#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>

@interface MovieViewController : UIViewController

@property (strong, nonatomic) MPMoviePlayerController *moviePlayer;
- (IBAction)playMovie:(id)sender;
@end