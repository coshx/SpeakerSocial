
#import "WebViewController.h"

@implementation WebViewController

NSString* selectedSong;

- (void)viewDidLoad {
    [super viewDidLoad];
    NSString *urlAddress = @"http://chielo.herokuapp.com";
    NSURL *url = [NSURL URLWithString:urlAddress];
    NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
    [self.viewWeb loadRequest:requestObj];
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    if ([request.URL.scheme isEqualToString:@"inapp"]) {
        //if ([request.URL.host isEqualToString:@"capture"]) {
        selectedSong = request.URL.host;
        [self performSegueWithIdentifier: @"SequeToBroadcast" sender: self];
        return NO;
    }
    return YES;

}

-(void)prepareForSegue:(UIStoryboardSegue*) segue sender:(id)sender{
    BroadcastController *destination = [segue destinationViewController];
    destination.selectedSong = selectedSong;
}



@end

