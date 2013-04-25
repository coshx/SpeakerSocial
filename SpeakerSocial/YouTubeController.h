#import "GData.h"

@interface YouTubeController : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) IBOutlet UITableView* tableView;

@property (strong, nonatomic) GDataFeedBase* tableData;
@property (strong, nonatomic) GDataServiceGoogleYouTube *service ;

@end
