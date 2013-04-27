#import "YouTubeController.h"
#import "HCYoutubeParser.h"

@interface YouTubeController()
@end

@implementation YouTubeController

NSString* selectedSong;
NSArray *tableData;
NSString* lastSearch;

- (void)viewDidLoad{
    [super viewDidLoad];
    self.tableView.delegate = self;
    self.tableView.allowsSelection = YES;
    [self.searchBar becomeFirstResponder];
    self.service  = [[GDataServiceGoogleYouTube alloc] init];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.tableData.entries count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    static NSString *simpleTableIdentifier = @"SimpleTableItem";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    GDataEntryBase *entry = [self.tableData.entries objectAtIndex:indexPath.row];
    cell.textLabel.text = [[entry title] stringValue];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    GDataEntryBase *entry = [self.tableData.entries objectAtIndex:indexPath.row];
    selectedSong = entry.HTMLLink.href;
    [self performSegueWithIdentifier: @"YouTubeToBroadcastSeque" sender: self];
}

-(void)prepareForSegue:(UIStoryboardSegue*) segue sender:(id)sender{
    BroadcastController *destination = [segue destinationViewController];
    destination.selectedSong = selectedSong;
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [self youTubeSearch:searchBar.text];
    [self.searchBar setShowsCancelButton:YES animated:YES];
    [searchBar resignFirstResponder];
}

-(void)youTubeSearch:(NSString*)searchString{
    lastSearch = searchString;
    NSURL *feedURL = [GDataServiceGoogleYouTube youTubeURLForFeedID:nil];
    GDataQueryYouTube* query = [GDataQueryYouTube  youTubeQueryWithFeedURL:feedURL];
        [query setVideoQuery:searchString];
        [query setMaxResults:20];
    [self.service fetchFeedWithQuery:query delegate:self didFinishSelector:@selector(searchCallback:finishedWithFeed:error:)];
}

- (void)searchCallback:(GDataServiceTicket *)ticket finishedWithFeed:(GDataFeedBase *)feed error:(NSError *)error {
    NSMutableArray* entries = [[NSMutableArray alloc] init];
    for (GDataEntryBase *entry in feed){
         if([HCYoutubeParser videoAvailable:[NSURL URLWithString: entry.HTMLLink.href]]){
             [entries addObject:entry];
             feed.entries = entries;
             self.tableData = feed ;
             [self.tableView reloadData];
         }
    }
}

@end