
#import "WebViewController.h"

@implementation WebViewController

NSString* selectedSong;

- (void)viewDidLoad {
    [super viewDidLoad];
    [self load];
}

-(void)load{
    NSString *urlAddress = @"http://speakersocial.herokuapp.com";
    NSURL *url = [NSURL URLWithString:urlAddress];
    NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
    [self.viewWeb loadRequest:requestObj];   
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    
    if(request == NULL){
        [self load];
        return NO;
    }else if ([request.URL.scheme isEqualToString:@"inapp"]) {
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

