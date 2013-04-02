#import "Network.h"
@interface Network()
@end
@implementation Network
-(NSData*)httpGet: (NSString*)url{
    NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
    NSURLResponse *resp = nil;
    NSError *err = nil;
    NSData *response = [NSURLConnection sendSynchronousRequest: theRequest returningResponse: &resp error: &err];
    //NSString * response_string = [[NSString alloc] initWithData:response encoding:NSUTF8StringEncoding];
    return response;
}
-(void)httpPost: (NSString*)url :(NSString*)data{
    NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
    [theRequest setHTTPMethod:@"POST"];
    [theRequest setHTTPBody:[data dataUsingEncoding:NSUTF8StringEncoding]];
    NSURLResponse *resp = nil;
    NSError *err = nil;
    [NSURLConnection sendSynchronousRequest: theRequest returningResponse: &resp error: &err];
}
@end