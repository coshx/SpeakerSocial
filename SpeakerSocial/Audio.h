#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import <CoreMedia/CoreMedia.h>

@interface Audio: NSObject
@property (strong, nonatomic) AVAudioPlayer *audioPlayer;
@property (strong, nonatomic) AVAudioPlayer *avPlayer;
-(void)load:(NSString*)urlString;
-(void)play:(double)clientStartTime;
-(BOOL)playing;
@end