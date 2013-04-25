#import "YouTubeController.h"
#import "Gdata.h"

@interface YouTubeController()
@end

@implementation YouTubeController

NSArray *tableData;

- (void)viewDidLoad{
    [super viewDidLoad];
    self.service  = [[GDataServiceGoogleYouTube alloc] init];
     tableData = [NSArray arrayWithObjects:@"Egg Benedict", @"Mushroom Risotto", @"Full Breakfast", @"Hamburger", @"Ham and Egg Sandwich", @"Creme Brelee", @"White Chocolate Donut", @"Starbucks Coffee", @"Vegetable Curry", @"Instant Noodle with Egg", @"Noodle with BBQ Pork", @"Japanese Noodle with Pork", @"Green Tea", @"Thai Shrimp Cake", @"Angry Birds Cake", @"Ham and Cheese Panini", nil];
    
    //[self search];
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
    
    cell.textLabel.text = [self.tableData.entries objectAtIndex:indexPath.row];
    return cell;
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
    self.tableData = feed ;
    
    for (GDataEntryBase *entry in feed) {
        NSLog(@"Title: %@", [[entry title] stringValue]);
        
    }
}

@end