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

-(void)httpPost: (NSString*)url :(NSString*)data1{
    NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
    [theRequest setHTTPMethod:@"POST"];
    [theRequest setHTTPBody:[data1 dataUsingEncoding:NSUTF8StringEncoding]];
    NSURLResponse *resp = nil;
    NSError *err = nil;
    [NSURLConnection sendSynchronousRequest: theRequest returningResponse: &resp error: &err];
}

-(void)httpASyncPost: (NSString*)url :(NSString*)data2{
    NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
    [theRequest setHTTPMethod:@"POST"];
    [theRequest setHTTPBody:[data2 dataUsingEncoding:NSUTF8StringEncoding]];

    [NSURLConnection sendAsynchronousRequest:theRequest queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *error){
         //[self didLoadData:data];
    }];
}

@end