#import "ClockSkew.h"
#import "Network.h"
#import "JSON.h"
@interface ClockSkew()
@end
@implementation ClockSkew

const int numberOfSamples = 15 ;
const int CLIENT_REQUEST_TIME = 0;
const int CLIENT_RESPONSE_TIME = 1;
const int SERVER_TIME = 2;
const int ROUND_TRIP = 3;

-(NSNumber*)calculate{
    NSMutableArray* samples = [[NSMutableArray alloc] initWithCapacity:numberOfSamples];
    samples = [self takeSamples:samples];
    NSArray* bestSample = [self getSampleWithMinRoundTrip:samples];
    double roundTrip = [self roundTrip:bestSample];
    NSLog(@"best roundTrip:%f",roundTrip);
    double reqPlusSkew = [[bestSample objectAtIndex:SERVER_TIME] doubleValue] - [[bestSample objectAtIndex:CLIENT_REQUEST_TIME] doubleValue];
    NSNumber* skew = [NSNumber numberWithDouble:(reqPlusSkew - (roundTrip/2))];
    return skew;
}

-(NSMutableArray*)takeSamples:(NSMutableArray*)samples{
    double clientRequestTime = [[NSDate date] timeIntervalSince1970]*1000;
    NSDictionary* serverResponse = [JSON parse: [Network httpGet:@"http://chielo.herokuapp.com/time"]];
    double clientResponseTime = [[NSDate date] timeIntervalSince1970]*1000;
    double serverTime = [[serverResponse objectForKey:@"time"] doubleValue] ;
    double roundTrip = clientResponseTime - clientRequestTime;
    NSArray* sample =@[ @(clientRequestTime), @(clientResponseTime), @(serverTime), @(roundTrip)]; //{}?
    [samples addObject:sample];
    if([samples count] < numberOfSamples){
     [NSThread sleepForTimeInterval:.1];
        [self takeSamples:samples];
    }
    return samples;
}

-(NSArray*)getSampleWithMinRoundTrip:(NSMutableArray*)samples{
    
    NSArray* minRoundTripSample = [NSMutableArray alloc] ;
    double minRoundTrip = [self roundTrip:[samples objectAtIndex:0]];
    double thisRoundTrip;
    
    for (NSArray *sample in samples) {
        thisRoundTrip = [self roundTrip:sample];
        if (abs(thisRoundTrip)<abs(minRoundTrip)){
            minRoundTripSample = sample ;
            minRoundTrip = thisRoundTrip;
        }
    }

    return minRoundTripSample;
}

-(double)roundTrip:(NSArray*)sample{
    double respMinusSkew = [[sample objectAtIndex:CLIENT_RESPONSE_TIME ] doubleValue] - [[sample objectAtIndex:SERVER_TIME] doubleValue];
    double reqPlusSkew = [[sample objectAtIndex:SERVER_TIME] doubleValue] - [[sample objectAtIndex:CLIENT_REQUEST_TIME] doubleValue];
    return reqPlusSkew+respMinusSkew;
}

-(double)monitorClock{
    while(true){
        double start_time = [[NSDate date] timeIntervalSince1970]*1000 ;
        [NSThread sleepForTimeInterval:1];
        double current_time = [[NSDate date] timeIntervalSince1970]*1000 ;
        if(current_time - start_time < 950 || current_time - start_time>1010){
            return current_time - start_time;
        }
    }
}

@end















