#import <UIKit/UIKit.h>
#import <dispatch/dispatch.h>
#import "Audio.h"

@interface SubscribeController : UIViewController

@property (nonatomic, strong) IBOutlet UITextView *quoteText;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView * progressBar;
@property (strong, nonatomic) IBOutlet UIView * activityView;
@property (strong, nonatomic) Audio* audio;
@property (strong, nonatomic) NSNumber* clockSkew;
@property  (strong, nonatomic)  UIView *loadingView;
@property  (strong, nonatomic)  UILabel *loadingLabel;

- (IBAction)subscribeButtonTapped:(id)sender;
- (IBAction)selectSongToBroadcast:(id)sender;


@end
