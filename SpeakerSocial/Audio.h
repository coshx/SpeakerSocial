#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import <CoreMedia/CoreMedia.h>
#import "AudioStreamer.h"


@interface Audio: NSObject
@property (strong, nonatomic) AudioStreamer *audioPlayer;
@property (strong, nonatomic) AudioStreamer *avPlayer;
-(void)load:(NSString*)urlString;
-(void)play:(double)clientStartTime;
-(BOOL)playing;
@end