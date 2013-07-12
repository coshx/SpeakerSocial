#import "Audio.h"

@interface Audio()
@end
@implementation Audio : NSObject
//NSLog(@"\nfinal difference: %f", difference);

int syncCount = 0;

-(void)play:(double)clientStartTime{
    
    double now = [[NSDate date] timeIntervalSince1970]*1000;
    double songPosition = 0.001*(now - clientStartTime);
    [self.audioPlayer seekToTime:songPosition];
    double idealTime = songPosition *1000;
    double playerTime = 0.0;
    
    [self.audioPlayer progress:&playerTime];

    playerTime = playerTime * 1000;
    double difference = playerTime - idealTime;
    NSLog(@"difference: %f",difference);
    
    if(abs(difference)>10 || syncCount<5){
        syncCount++;
        [NSThread sleepForTimeInterval:0.02];
        [self play:clientStartTime];
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
    [self.audioPlayer start];
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


