#import "JSON.h"
@interface JSON()
@end
@implementation JSON
- (NSDictionary*)parse:(NSData*)data {
    NSError* error;
    NSDictionary* json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    return json;
}
@end
