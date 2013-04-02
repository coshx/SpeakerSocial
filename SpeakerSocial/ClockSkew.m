#import "ClockSkew.h"
#import "Network.h"
#import "JSON.h"
@interface ClockSkew()
@end
@implementation ClockSkew

NSNumber *numberOfSamples;

-(void)calculate{
    NSMutableArray* samples;
    NSMutableArray *respPlusSkews;
    NSMutableArray *respMinusSkews;
    const int CLIENT_REQUEST_TIME = 0;
    const int CLIENT_RESPONSE_TIME = 1;
    const int SERVER_TIME = 2;
    numberOfSamples = [NSNumber numberWithInt:25];
    samples = [self takeSamples:samples];
    
    for (NSArray *sample in samples) {
        double reqplusskew = [[sample objectAtIndex:SERVER_TIME] doubleValue] - [[sample objectAtIndex:CLIENT_REQUEST_TIME] doubleValue];
        [respPlusSkews addObject: [NSNumber numberWithDouble:reqplusskew]];
    }
    for (NSArray *sample in samples) {
        double respminusskew = [[sample objectAtIndex:CLIENT_RESPONSE_TIME ]doubleValue] - [[sample objectAtIndex:SERVER_TIME] doubleValue];
        [respMinusSkews addObject: [NSNumber numberWithDouble:respminusskew]];
    }
    double sumReqPlusSkew = [[respPlusSkews valueForKeyPath:@"@sum.self"] doubleValue]; 
    double sumRespMinusSkew = [[respMinusSkews valueForKeyPath:@"@sum.self"] doubleValue];
    double avgReqPlusSkew = sumReqPlusSkew/[samples count];
    double avgRespMinusSkew = sumRespMinusSkew/[samples count];
    self.clockSkew = [NSNumber numberWithDouble:(avgReqPlusSkew - ((avgReqPlusSkew+avgRespMinusSkew)/2))];
}

-(NSMutableArray*)takeSamples:(NSMutableArray*)sampleArray{
    NSTimeInterval clientRequestTime = [[NSDate date] timeIntervalSince1970]*1000;
    NSDictionary* songData = [JSON parse: [Network httpGet:@"http://chielo.herokuapp.com/time"]];
    NSTimeInterval clientResponseTime = [[NSDate date] timeIntervalSince1970]*1000;
    NSTimeInterval serverTime = [[songData objectForKey:@"time"] doubleValue] ;
    NSArray* sample =[NSArray arrayWithObjects:
                      [NSNumber numberWithDouble:clientRequestTime],
                      [NSNumber numberWithDouble:clientResponseTime],
                      [NSNumber numberWithDouble:serverTime], nil];
    [sampleArray addObject:sample];
    
    if([NSNumber numberWithInt:[sampleArray count]] < numberOfSamples){
        [self takeSamples:sampleArray];
    }
    return sampleArray;
}

@end















