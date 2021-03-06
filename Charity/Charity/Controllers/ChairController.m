//
//  ChairController.m
//  Charity
//
//  Created by Oktawian Chojnacki on 20.06.2015.
//  Copyright (c) 2015 BattleHack. All rights reserved.
//

#import <KAProgressLabel/KAProgressLabel.h>
#import <AudioToolbox/AudioToolbox.h>
#import <AVFoundation/AVFoundation.h>
#import "TimerViewController.h"
#import "ChairController.h"

@interface ChairController ()
@property (nonatomic, weak) KAProgressLabel *progressLabelBadPositionTime;
@property (nonatomic, weak) KAProgressLabel *progressLabelSedentaryTime;
@property (nonatomic, weak) UIImageView *silhuetteImageView;
@property (nonatomic, weak) TimerViewController *timerViewController;

@property (nonatomic, assign) NSTimeInterval slouchTime;
@property (nonatomic, assign) NSTimeInterval sedentaryTime;

@property (nonatomic, assign) NSTimeInterval acceptableSlouchTime;
@property (nonatomic, assign) NSTimeInterval acceptableSedentaryTime;

@property (nonatomic, strong) NSTimer *sedentaryTimer;
@property (nonatomic, strong) NSTimer *slouchingTimer;

@property (nonatomic, strong) AVAudioPlayer *player;

@end

@implementation ChairController

- (instancetype)initWithSedentaryLabel:(KAProgressLabel *)sedentary
                           slouchLabel:(KAProgressLabel *)slouch
                        silhuetteImage:(UIImageView *)silhuette
                   workTimerController:(TimerViewController *)workController
               acceptableSedentaryTime:(NSTimeInterval)sedentaryTime
                  acceptableSlouchTime:(NSTimeInterval)slouchTime {

    self = [super init];

    if (self) {
        _progressLabelBadPositionTime = slouch;
        _progressLabelSedentaryTime = sedentary;
        _silhuetteImageView = silhuette;
        _acceptableSedentaryTime = sedentaryTime;
        _acceptableSlouchTime = slouchTime;
        _timerViewController = workController;

        [self setUpViews];
    }

    return self;
}

- (void)setSat:(BOOL)sat {

    if (_sat == sat) {
        return;
    }

    _sat = sat;

    if (sat) {
         [self.timerViewController start];
    } else {
        [self.timerViewController stop];
        [self.player stop];
    }

    if (self.slouched) {
        [self slouchTimerStart:sat & self.slouched];
    }

    self.silhuetteImageView.image = [self imageForSat:sat slouched:self.slouched];

//    [UIView animateWithDuration:0.3 animations:^{
//        self.silhuetteImageView.alpha = sat ? 0.8f : 0.4f;
//    }];

    [self sedentaryTimerStart:sat];
}

-(void) playSound {

    UInt32 doChangeDefaultRoute = 1;
    AudioSessionSetProperty(kAudioSessionProperty_OverrideCategoryDefaultToSpeaker, sizeof(doChangeDefaultRoute), &doChangeDefaultRoute);


    NSString *path;

    NSURL *url;


    path = [[NSBundle mainBundle] pathForResource:@"0899" ofType:@"mp3"];

    url = [NSURL fileURLWithPath:path];


    self.player = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:NULL];


    [self.player setVolume:1.0];
    [self.player play];

    AudioServicesPlayAlertSound(kSystemSoundID_Vibrate);
    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
}

-(void) playSoundCoin {

    UInt32 doChangeDefaultRoute = 1;
    AudioSessionSetProperty(kAudioSessionProperty_OverrideCategoryDefaultToSpeaker, sizeof(doChangeDefaultRoute), &doChangeDefaultRoute);

    NSString *path;

    NSURL *url;


    path = [[NSBundle mainBundle] pathForResource:@"0339" ofType:@"mp3"];

    url = [NSURL fileURLWithPath:path];


    self.player = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:NULL];


    [self.player setVolume:1.0];
    [self.player play];

    AudioServicesPlayAlertSound(kSystemSoundID_Vibrate);
    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
}

-(void) playSoundCar {

    UInt32 doChangeDefaultRoute = 1;
    AudioSessionSetProperty(kAudioSessionProperty_OverrideCategoryDefaultToSpeaker, sizeof(doChangeDefaultRoute), &doChangeDefaultRoute);

    NSString *path;

    NSURL *url;


    path = [[NSBundle mainBundle] pathForResource:@"0850" ofType:@"mp3"];

    url = [NSURL fileURLWithPath:path];


    self.player = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:NULL];


    [self.player setVolume:1.0];
    [self.player play];

    AudioServicesPlayAlertSound(kSystemSoundID_Vibrate);
    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
}

- (void)setSlouched:(BOOL)slouched {

    if (_slouched == slouched) {
        return;
    }

    _slouched = slouched;

    if (!slouched) {
        [self.player stop];
    }

    self.silhuetteImageView.image = [self imageForSat:self.sat slouched:slouched];

    if (self.sat) {
        [self slouchTimerStart:slouched];
    }
}

- (UIImage *)imageForSat:(BOOL)sat slouched:(BOOL)slouched {
    return slouched && sat ? [UIImage imageNamed:@"silhuette-red"]
                           : ( sat ? [UIImage imageNamed:@"silhuette"]
                                   : [UIImage imageNamed:@"silhuette-empty"] ) ;
}

- (void)sedentaryTimerStart:(BOOL)start {

    if (start) {
        self.sedentaryTimer = [NSTimer scheduledTimerWithTimeInterval:1.0
                                                               target:self
                                                             selector:@selector(sedentaryTick:)
                                                             userInfo:nil
                                                              repeats:YES];
        return;
    }

    [self.sedentaryTimer invalidate];

    self.sedentaryTime = 0.0;
}

- (void)sedentaryTick:(id)info {
    self.sedentaryTime += 1.0;
}

- (void)slouchTimerStart:(BOOL)start {

    if (start) {
        self.slouchingTimer = [NSTimer scheduledTimerWithTimeInterval:1.0
                                                               target:self
                                                             selector:@selector(slouchTick:)
                                                             userInfo:nil
                                                              repeats:YES];

        [self playSoundCar];

        return;
    }

    [self.slouchingTimer invalidate];

    self.slouchTime = 0.0;
}

- (void)slouchTick:(id)info {
    self.slouchTime += 1.0;
}

- (void)setSedentaryTime:(NSTimeInterval)sedentaryTime {

    _sedentaryTime = sedentaryTime;

    CGFloat percentage = (CGFloat) 1.0 - (sedentaryTime / self.acceptableSedentaryTime);

    [self setLabel:self.progressLabelSedentaryTime withTime:self.acceptableSedentaryTime - sedentaryTime percentage:percentage];

    if (sedentaryTime >= self.acceptableSedentaryTime) {
        [self sedentaryTimerStart:NO];
        _sedentaryTime = 0.0;
        [self.delegate sedentaryTimeExceeded];
        [self playSound];
    }
}

- (void)setSlouchTime:(NSTimeInterval)slouchTime {

    _slouchTime = slouchTime;

    CGFloat percentage = (CGFloat) 1.0 - (slouchTime / self.acceptableSlouchTime);

    [self setLabel:self.progressLabelBadPositionTime
          withTime:self.acceptableSlouchTime - slouchTime
        percentage:percentage];

    if (slouchTime >= self.acceptableSlouchTime) {
        [self slouchTimerStart:NO];
        _slouchTime = 0.0;
        [self.delegate slouchingTimeExceeded];
        [self playSoundCoin];
    }
}

- (void)setLabel:(KAProgressLabel *)label withTime:(NSTimeInterval)time percentage:(CGFloat)percentage {

    NSInteger ti = (NSInteger)time;
    NSInteger seconds = ti % 60;
    NSInteger minutes = (ti / 60) % 60;

    label.text = [NSString stringWithFormat:@"%02ld:%02ld", (long)minutes, (long)seconds];

    [label setProgress:percentage
                timing:TPPropertyAnimationTimingEaseOut
              duration:0.3
                 delay:0.0];
}

- (void)setUpViews {

    self.silhuetteImageView.alpha = 1.0f;

    self.silhuetteImageView.image = [self imageForSat:self.sat slouched:self.slouched];

    [self setLabel:self.progressLabelBadPositionTime withTime:self.acceptableSlouchTime percentage:1.0];
    [self setLabel:self.progressLabelSedentaryTime withTime:self.acceptableSedentaryTime percentage:1.0];

    self.progressLabelBadPositionTime.fillColor = [UIColor clearColor];
    self.progressLabelBadPositionTime.trackColor = [UIColor colorWithRed:0.149020 green:0.031373 blue:0.062745 alpha:1.0];
    self.progressLabelBadPositionTime.progressColor = [UIColor colorWithRed:0.984314 green:0.000000 blue:0.047059 alpha:1.0];

    self.progressLabelBadPositionTime.trackWidth = 8.0f;         // Defaults to 5.0
    self.progressLabelBadPositionTime.progressWidth = 8.0f;        // Defaults to 5.0
    self.progressLabelBadPositionTime.roundedCornersWidth = 8.0f; // Defaults to 0

    self.progressLabelSedentaryTime.fillColor = [UIColor clearColor];
    self.progressLabelSedentaryTime.trackColor = [UIColor colorWithRed:0.129412 green:0.200000 blue:0.015686 alpha:1.0];
    self.progressLabelSedentaryTime.progressColor = [UIColor colorWithRed:0.560784 green:1.000000 blue:0.035294 alpha:1.0];

    self.progressLabelSedentaryTime.trackWidth = 8.0f;         // Defaults to 5.0
    self.progressLabelSedentaryTime.progressWidth = 8.0f;        // Defaults to 5.0
    self.progressLabelSedentaryTime.roundedCornersWidth = 8.0f; // Defaults to 0
}

@end
