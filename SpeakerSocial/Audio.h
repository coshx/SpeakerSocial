#import <AVFoundation/AVFoundation.h>
@interface Audio: NSObject
@property (strong, nonatomic) AVAudioPlayer *audioPlayer;
- (void)play:(double)position;
- (void)load:(NSString*)url;
- (double)duration;
- (NSTimeInterval)currentTime;
- (void)mute;
@end