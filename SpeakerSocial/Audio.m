#import "Audio.h"
@interface Audio()
@end
@implementation Audio : NSObject
//NSLog(@"\nfinal difference: %f", difference);

int syncCount = 0;

-(void)play:(double)clientStartTime{
    
    double now = [[NSDate date] timeIntervalSince1970]*1000;
    double songPosition = 0.001*(now - clientStartTime);
    self.audioPlayer.currentTime = songPosition;
    double idealTime = songPosition *1000;
    double playerTime = [self.audioPlayer currentTime]*1000;
    double difference = playerTime - idealTime;
    //NSLog(@"difference: %f",difference);
    
    if(abs(difference)>1 || syncCount<5){
        syncCount++;
        [NSThread sleepForTimeInterval:0.200];
        [self play:clientStartTime];
    }else{
        self.audioPlayer.volume = 1.0;
    }
}

-(void)load:(NSString*)urlString{
    NSURL *url = [NSURL URLWithString:urlString];
    NSData *data = [NSData dataWithContentsOfURL:url];
    self.audioPlayer = [[AVAudioPlayer alloc] initWithData:data error:nil];
	[self.audioPlayer prepareToPlay];
    [self.audioPlayer play];
    self.audioPlayer.volume = 0;
}

-(double)duration{
    return self.audioPlayer.duration;
}
-(NSTimeInterval)currentTime{
    return self.audioPlayer.currentTime;
}
-(BOOL)playing{
    return self.audioPlayer.playing;
}

-(void)mute{
    self.audioPlayer.volume = 0.0;
    //[self.audioPlayer pause];  //[audioPlayer stop];
}


@end
