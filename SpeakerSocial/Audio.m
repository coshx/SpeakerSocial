#import "Audio.h"
@interface Audio()
@end
@implementation Audio : NSObject

-(void)play:(double)clientStartTime{
    
    double now = [[NSDate date] timeIntervalSince1970]*1000;
    double songPosition = 0.001*(now - clientStartTime);
    self.audioPlayer.currentTime = songPosition;
    [self.audioPlayer play];
    
    double idealTime = songPosition *1000;
    double playerTime = [self.audioPlayer currentTime]*1000;
    double difference = playerTime - idealTime;
    
    NSLog(@"\ndifference: %f", difference);
   
    if(abs(difference)>.1){
        NSLog(@"\ndifference: %f", difference);
        
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
    self.audioPlayer.volume = 0;
}

-(double)duration{
    return self.audioPlayer.duration;
}
-(NSTimeInterval)currentTime{
    return self.audioPlayer.currentTime;
}

-(void)mute{
    self.audioPlayer.volume = 0.0;
    //[self.audioPlayer pause];  //[audioPlayer stop];
}




@end
