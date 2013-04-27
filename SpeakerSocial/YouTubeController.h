#import "GData.h"
#import "BroadcastController.h"

@interface YouTubeController : UIViewController <UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate>
@property (nonatomic, strong) IBOutlet UITableView* tableView;
@property (strong, nonatomic) GDataFeedBase* tableData;
@property (strong, nonatomic) GDataServiceGoogleYouTube *service;
@property (strong, nonatomic) UISearchBar *searchBar;
@end
