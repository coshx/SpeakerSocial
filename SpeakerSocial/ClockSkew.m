//[myColors objectAtIndex: i]
//[myColors addObject: @"Violet"];
//[myColors removeObjectAtIndex: 0];
//[myColors removeObject: @"Red"];
//[myColors removeObjectIdenticalTo: @"Red"]; //all
//[myColors removeAllObjects];
//[myColors removeLastObject];
//NSArray *sortedArray = [myColors sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
#import "ClockSkew.h"
#import "Network.h"
#import "JSON.h"
@interface ClockSkew()
@end

@implementation ClockSkew

NSNumber *numberOfSamples;

-(NSNumber*)calculate{
    numberOfSamples = [NSNumber numberWithInt:50];
    return [NSNumber numberWithInt:0];
}

-(double)mean:(NSArray*)values{
    double sum = [[values valueForKeyPath:@"@sum.self"] doubleValue]; //collection key-path operators
    double count = [[NSNumber numberWithInt:[values count]] doubleValue];
    return sum/count;
}
-(double)stdev:(NSArray*)values{
    double mean = [self mean:values];
    double count = [[NSNumber numberWithInt:[values count]] doubleValue];
    double squared_difference_sum = 0;
    for (NSNumber *val in values) {
        squared_difference_sum += pow([val doubleValue]-mean,2);
    }
    return sqrt(squared_difference_sum/count);
}
-(NSArray*)processData:(NSArray*)measurements{
    bool done = true ;
    NSMutableArray *newMeasurements;
    NSMutableArray *respPlusSkews;
    for (NSArray *measurement in measurements) {
        [respPlusSkews addObject: measurement.respPlusSkew];
    }
}
-(NSArray*)takeMeasurements{
    NSTimeInterval *currentTime;
    NSTimeInterval *roundTrip;
    double respPlusSkew ;
    NSTimeInterval clientRequestTime = [[NSDate date] timeIntervalSince1970]*1000;
    NSDictionary* songData = [JSON parse: [Network httpGet:@"http://chielo.herokuapp.com/time"]];
    NSTimeInterval serverStartTime = [[songData objectForKey:@"time"] doubleValue] ;
    roundTrip = currentTime - clientRequestTime ;
}

getMeasurement:function(){
    var clientRequestTime,currentTime,roundTrip,respPlusSkew ;
    clientRequestTime = Date.now();
    $.ajax({ url:  "/time", dataType: 'json', async: false, success: function(response){
        currentTime = Date.now();
        respPlusSkew = currentTime - response["time"] ;
        roundTrip = currentTime - clientRequestTime ;
        GateSync.measurements.push({respPlusSkew: respPlusSkew, roundTrip: roundTrip});
    }});
    if(GateSync.measurements.length < GateSync.maxRequests){
        GateSync.getMeasurement();
    }else{
        GateSync.calculateSkew();
    }
},

-(NSArray*):
typicalMeasurements:function(measurements){
    var done = true ;
    var new_measurements = [] ;
    var respPlusSkews = measurements.map(function(memo){return memo.respPlusSkew});
    var stdev = GateSync.stdev(respPlusSkews);
    var mean = GateSync.mean(respPlusSkews);
    _.each(measurements, function(measurement){
        var respPlusSkew = measurement.respPlusSkew ;
        if(respPlusSkew <= (mean + stdev) && respPlusSkew >= (mean - stdev) ){
            new_measurements.push(measurement);
        }else{
            done = false ;
        }
    });
    if(!done){
        return GateSync.typicalMeasurements(new_measurements);
    }else{
        return new_measurements ;
    }
},

@end
