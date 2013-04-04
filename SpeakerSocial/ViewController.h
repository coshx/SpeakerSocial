#import <UIKit/UIKit.h>
#import <dispatch/dispatch.h>

#import "QuartzCore/QuartzCore.h"

#import "Audio.h"
@interface ViewController : UIViewController
@property (nonatomic, strong) IBOutlet UITextView *quoteText;
@property (strong, nonatomic) Audio* audio;
@property (strong, nonatomic) NSNumber* clockSkew;
@property (strong, nonatomic) UIActivityIndicatorView * activityView;
@property  (strong, nonatomic)  UIView *loadingView;
@property  (strong, nonatomic)  UILabel *loadingLabel;

- (IBAction)subscribeButtonTapped:(id)sender;
- (IBAction)broadcastButtonTapped:(id)sender;
- (IBAction)pauseButtonTapped:(id)sender;


@end
