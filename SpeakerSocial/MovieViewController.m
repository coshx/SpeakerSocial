#import "MovieViewController.h"

@interface MovieViewController ()
@end

@implementation MovieViewController

- (void)viewDidLoad{
    [super viewDidLoad];
}

-(void)playMovie:(id)sender{
    NSURL *url = [NSURL URLWithString:@"http://r3---sn-jvhj5nu-p5qe.c.youtube.com/videoplayback?ms=au&mv=m&upn=YbO8XZ6j5iQ&source=youtube&cp=U0hVTFBOTl9FTkNONV9ISFJEOkpMZnhlY1NfV1FR&id=d9aff810a2c1b3d3&fexp=916604,919374,914045,916625,932000,932004,906383,904479,902000,901208,929903,925714,929119,931202,900821,900823,912518,911416,904476,908529,930807,919373,906836,929602,930101,900824,912711,910075&expire=1367030304&ratebypass=yes&sver=3&mt=1367008164&itag=18&ipbits=8&sparams=cp,id,ip,ipbits,itag,ratebypass,source,upn,expire&newshard=yes&ip=67.166.180.68&key=yt1&signature=4B3593B184984BDF8E030F4D2CC45ED7230961F3.377B2A336F23C64362B8EFB7F392854919E04E98"];
    
    self.moviePlayer =  [[MPMoviePlayerController alloc] initWithContentURL:url];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(moviePlayBackDidFinish:)
                                                 name:MPMoviePlayerPlaybackDidFinishNotification
                                               object:_moviePlayer];
    
    _moviePlayer.controlStyle = MPMovieControlStyleDefault;
    _moviePlayer.shouldAutoplay = YES;
    [self.view addSubview:_moviePlayer.view];
    [_moviePlayer setFullscreen:NO animated:YES];
    
    _moviePlayer.initialPlaybackTime = 2000.0;
}

- (void) moviePlayBackDidFinish:(NSNotification*)notification {
    MPMoviePlayerController *player = [notification object];
    [[NSNotificationCenter defaultCenter]
     removeObserver:self
     name:MPMoviePlayerPlaybackDidFinishNotification
     object:player];
    
    if ([player
         respondsToSelector:@selector(setFullscreen:animated:)])
    {
        [player.view removeFromSuperview];
    }
}

@end