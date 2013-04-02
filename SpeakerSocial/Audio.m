#import "Audio.h"
@interface Audio()
@end
@implementation Audio : NSObject
-(void)play:(double)position{
    self.audioPlayer.volume = 1.0;
    self.audioPlayer.currentTime = position;
}
-(void)load{
    NSURL *url = [NSURL URLWithString:@"http://chielo.herokuapp.com/media/Meter.mp3"];
    NSData *data = [NSData dataWithContentsOfURL:url];
    self.audioPlayer = [[AVAudioPlayer alloc] initWithData:data error:nil];
	self.audioPlayer.numberOfLoops = 1;
    if (self.audioPlayer == nil)
        NSLog(@"%@",@"Error loadAudio - Unable to load audio");
    else{
        [self.audioPlayer play];
        self.audioPlayer.volume = 0.0;
    }
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
