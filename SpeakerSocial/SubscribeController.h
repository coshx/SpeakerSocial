#import <UIKit/UIKit.h>
#import <dispatch/dispatch.h>
#import "Audio.h"

@interface SubscribeController : UIViewController
@property (nonatomic, strong) IBOutlet UITextView *quoteText;
@property (strong, nonatomic) Audio* audio;
@property (strong, nonatomic) NSNumber* clockSkew;
@property (strong, nonatomic) UIActivityIndicatorView * activityView;
@property  (strong, nonatomic)  UIView *loadingView;
@property  (strong, nonatomic)  UILabel *loadingLabel;

- (IBAction)subscribeButtonTapped:(id)sender;
- (IBAction)selectSongToBroadcast:(id)sender;


@end
