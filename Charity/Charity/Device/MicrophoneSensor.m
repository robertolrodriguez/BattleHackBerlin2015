//
//  MicrophoneSensor.m
//  Charity
//
//  Created by Kamil Pyć on 6/20/15.
//  Copyright (c) 2015 BattleHack. All rights reserved.
//

#import "MicrophoneSensor.h"
#import <AVFoundation/AVFoundation.h>

@interface  MicrophoneSensor ()
@property (nonatomic, strong) 	AVAudioRecorder *recorder;
@property (nonatomic, strong) 	NSTimer *levelTimer;
@property (nonatomic, assign)   float lowPassResults;
@property (nonatomic, assign)   BOOL loud;

@end

@implementation MicrophoneSensor

-(instancetype)init {
    self = [super init];
    if (self) {
        [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];
        [[AVAudioSession sharedInstance] requestRecordPermission:^(BOOL granted) {
            if (granted) {
                NSURL *url = [NSURL fileURLWithPath:@"/dev/null"];
                
                NSDictionary *settings = [NSDictionary dictionaryWithObjectsAndKeys:
                                          [NSNumber numberWithFloat: 44100.0],                 AVSampleRateKey,
                                          [NSNumber numberWithInt: kAudioFormatAppleLossless], AVFormatIDKey,
                                          [NSNumber numberWithInt: 1],                         AVNumberOfChannelsKey,
                                          [NSNumber numberWithInt: AVAudioQualityMax],         AVEncoderAudioQualityKey,
                                          nil];
                
                NSError *error;
                
                self.recorder = [[AVAudioRecorder alloc] initWithURL:url settings:settings error:&error];
                
                if (self.recorder) {
                    [self.recorder prepareToRecord];
                    self.recorder.meteringEnabled = YES;
                    [self.recorder record];
                    self.levelTimer = [NSTimer scheduledTimerWithTimeInterval: 0.03 target: self selector: @selector(levelTimerCallback:) userInfo: nil repeats: YES];

                } else
                    NSLog(@"%@",[error description]);
            }
            else {
                NSLog(@"Permission denied");
            }
        }];
    }
    
    return self;
}

- (void)levelTimerCallback:(NSTimer *)timer {
    [self.recorder updateMeters];
    const double ALPHA = 0.05;
    double peakPowerForChannel = pow(10, (0.05 * [self.recorder peakPowerForChannel:0]));
    self.lowPassResults = ALPHA * peakPowerForChannel + (1.0 - ALPHA) * self.lowPassResults;
    if (self.lowPassResults > 0.95) {
        if(!self.loud) {
            self.loud = YES;
            [self.delegate setLoudSoundState];
        }
    } else if(self.loud) {
        self.loud = NO;
        [self.delegate setNormalSoundState];
    }
    
}


@end
