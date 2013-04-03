#import <UIKit/UIKit.h>
#import "Audio.h"
@interface ViewController : UIViewController
@property (nonatomic, strong) IBOutlet UITextView *quoteText;
@property (strong, nonatomic) Audio* audio;
@property (strong, nonatomic) NSNumber* clockSkew;
@property (nonatomic, retain) UIActivityIndicatorView * activityView;

- (IBAction)subscribeButtonTapped:(id)sender;
- (IBAction)broadcastButtonTapped:(id)sender;
- (IBAction)pauseButtonTapped:(id)sender;


@end
