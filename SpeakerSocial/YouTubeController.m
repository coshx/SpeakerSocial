#import "YouTubeController.h"
#import "Gdata.h"

@interface YouTubeController()
@end

@implementation YouTubeController

- (void)viewDidLoad{
    [super viewDidLoad];
    self.service  = [[GDataServiceGoogleYouTube alloc] init];
    [self search];
}

-(void)search{

    NSURL *feedURL = [GDataServiceGoogleYouTube youTubeURLForFeedID:nil];
    GDataQueryYouTube* query = [GDataQueryYouTube  youTubeQueryWithFeedURL:feedURL];
        [query setVideoQuery:@"football"];
        [query setMaxResults:5];
    //GDataServiceTicket* ticket =
    [self.service fetchFeedWithQuery:query delegate:self didFinishSelector:@selector(searchCallback:finishedWithFeed:error:)];
}

- (void)searchCallback:(GDataServiceTicket *)ticket finishedWithFeed:(GDataFeedBase *)feed error:(NSError *)error {
    
    self.returnTicket = ticket ;
    for (GDataEntryBase *entry in feed) {
        NSLog(@"Title: %@", [[entry title] stringValue]);
    }
}

@end