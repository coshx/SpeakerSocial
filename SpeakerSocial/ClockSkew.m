#import "ClockSkew.h"
#import "Network.h"
#import "JSON.h"
@interface ClockSkew()
@end
@implementation ClockSkew

int numberOfSamples;

-(NSNumber*)calculate{
    numberOfSamples = 25;
    NSMutableArray* samples = [[NSMutableArray alloc] initWithCapacity:numberOfSamples];
    NSMutableArray *respPlusSkews = [[NSMutableArray alloc] initWithCapacity:numberOfSamples];
    NSMutableArray *respMinusSkews= [[NSMutableArray alloc] initWithCapacity:numberOfSamples];
    double sumReqPlusSkew = 0.0;
    double sumRespMinusSkew= 0.0;
    double avgReqPlusSkew;
    double avgRespMinusSkew;
    const int CLIENT_REQUEST_TIME = 0;
    const int CLIENT_RESPONSE_TIME = 1;
    const int SERVER_TIME = 2;
    
    samples = [self takeSamples:samples];
    
    for (NSArray *sample in samples) {
        double reqplusskew = [[sample objectAtIndex:SERVER_TIME] doubleValue] - [[sample objectAtIndex:CLIENT_REQUEST_TIME] doubleValue];
        [respPlusSkews addObject: [NSNumber numberWithDouble:reqplusskew]];
    }
    for (NSArray *sample in samples) {
        double respminusskew = [[sample objectAtIndex:CLIENT_RESPONSE_TIME ]doubleValue] - [[sample objectAtIndex:SERVER_TIME] doubleValue];
        [respMinusSkews addObject: [NSNumber numberWithDouble:respminusskew]];
    }
    for (NSNumber *respPlusSkew in respPlusSkews) {
        sumReqPlusSkew+=[respPlusSkew doubleValue];
    }
    for (NSNumber *respMinusSkew in respMinusSkews) {
        sumRespMinusSkew+=[respMinusSkew doubleValue];
    }
    avgReqPlusSkew = sumReqPlusSkew/[samples count];
    avgRespMinusSkew = sumRespMinusSkew/[samples count];
    NSNumber* skew = [NSNumber numberWithDouble:(avgReqPlusSkew - ((avgReqPlusSkew+avgRespMinusSkew)/2))];
    return skew;
}
-(NSMutableArray*)takeSamples:(NSMutableArray*)samples{
    double clientRequestTime = [[NSDate date] timeIntervalSince1970]*1000;
    NSDictionary* serverResponse = [JSON parse: [Network httpGet:@"http://chielo.herokuapp.com/time"]];
    double clientResponseTime = [[NSDate date] timeIntervalSince1970]*1000;
    double serverTime = [[serverResponse objectForKey:@"time"] doubleValue] ;
    NSArray* sample =[NSArray arrayWithObjects:
                         [NSNumber numberWithDouble:clientRequestTime],
                         [NSNumber numberWithDouble:clientResponseTime],
                         [NSNumber numberWithDouble:serverTime],
                      nil];
    [samples addObject:sample];
    if([samples count] < numberOfSamples){
        [self takeSamples:samples];
    }
    return samples;
}
@end















