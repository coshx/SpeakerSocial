#import "Audio.h"

@interface Audio()
@end
@implementation Audio : NSObject
//NSLog(@"\nfinal difference: %f", difference);

int syncCount = 0;

-(void)play {
    [self.audioPlayer start];
}

-(void)sync:(double)clientStartTime{
    NSLog(@"start of Audio.sync");
    double now = [[NSDate date] timeIntervalSince1970]*1000;
    double songPosition = 0.001*(now - clientStartTime);
    NSLog(@"position: %f",songPosition);
    [self.audioPlayer seekToTime:songPosition];
    
    double idealTime = songPosition *1000;
    double playerTime = 0.0;
    
    [self.audioPlayer progress:&playerTime];

    playerTime = playerTime * 1000;
    NSLog(@"player time: %f", playerTime);
    double difference = playerTime - idealTime;
    NSLog(@"difference: %f",difference);
    NSLog(@"sync count: %d", syncCount);
    if(abs(difference)>10 || syncCount<5){
        syncCount++;
        [NSThread sleepForTimeInterval:0.02];
        [self sync:clientStartTime];
    } else {
        syncCount = 0;
        self.audioPlayer.volume = 1.0;
    }
}

-(void)load:(NSString*)urlString{
    NSURL *url = [NSURL URLWithString:urlString];
    NSLog(@"URL: %@", url);
    //NSData *data = [NSData dataWithContentsOfURL:url];
    self.audioPlayer = [AudioStreamer streamWithURL:url];
   // [self.audioPlayer prepareToPlay];
    //[self.audioPlayer start];
    self.audioPlayer.volume = 0;
}


-(double)duration{
    double dur;
    [self.audioPlayer duration:&dur];
    return dur;
}
-(NSTimeInterval)currentTime{
    double prog;
    [self.audioPlayer progress:&prog];
    return prog;
}
-(BOOL)playing{
    return self.audioPlayer.isPlaying;
}

-(void)mute{
    self.audioPlayer.volume = 0.0;
    //[self.audioPlayer pause]; //[audioPlayer stop];
}


@end


