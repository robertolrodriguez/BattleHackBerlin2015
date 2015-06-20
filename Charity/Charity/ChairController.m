//
//  ChairController.m
//  Charity
//
//  Created by Oktawian Chojnacki on 20.06.2015.
//  Copyright (c) 2015 BattleHack. All rights reserved.
//

#import <KAProgressLabel/KAProgressLabel.h>

#import "ChairController.h"

@interface ChairController ()
@property (nonatomic, weak) KAProgressLabel *progressLabelBadPositionTime;
@property (nonatomic, weak) KAProgressLabel *progressLabelSedentaryTime;
@property (nonatomic, weak) UIImageView *silhuetteImageView;

@property (nonatomic, assign) NSTimeInterval slouchTime;
@property (nonatomic, assign) NSTimeInterval sedentaryTime;

@property (nonatomic, assign) NSTimeInterval acceptableSlouchTime;
@property (nonatomic, assign) NSTimeInterval acceptableSedentaryTime;

@property (nonatomic, strong) NSTimer *sedentaryTimer;
@property (nonatomic, strong) NSTimer *slouchingTimer;

@end

@implementation ChairController

- (instancetype)initWithSedentaryLabel:(KAProgressLabel *)sedentary
                           slouchLabel:(KAProgressLabel *)slouch
                        silhuetteImage:(UIImageView *)silhuette
               acceptableSedentaryTime:(NSTimeInterval)sedentaryTime
                  acceptableSlouchTime:(NSTimeInterval)slouchTime {

    self = [super init];

    if (self) {
        _progressLabelBadPositionTime = slouch;
        _progressLabelSedentaryTime = sedentary;
        _silhuetteImageView = silhuette;
        _acceptableSedentaryTime = sedentaryTime;
        _acceptableSlouchTime = slouchTime;

        [self setUpViews];
    }

    return self;
}

- (void)setSat:(BOOL)sat {
    if (_sat == sat) {
        return;
    }

    _sat = sat;

    [self sedentaryTimerStart:sat];
}

- (void)setSlouched:(BOOL)slouched {
    if (_slouched == slouched) {
        return;
    }

    _slouched = slouched;

    [self slouchTimerStart:slouched];
}


- (void)sedentaryTimerStart:(BOOL)start {

    if (start) {
        self.sedentaryTimer = [[NSTimer alloc] initWithFireDate:[NSDate date] interval:1.0 target:self selector:@selector(sedentaryTick) userInfo:nil repeats:YES];

        return;
    }

    [self.sedentaryTimer invalidate];
}

- (void)sedentaryTick {
    self.sedentaryTime += 1.0;
}

- (void)slouchTimerStart:(BOOL)start {



}

- (void)setSedentaryTime:(NSTimeInterval)sedentaryTime {

    _sedentaryTime = sedentaryTime;

    CGFloat percentage = (CGFloat) (sedentaryTime / self.acceptableSedentaryTime);

    self.progressLabelSedentaryTime.labelVCBlock = ^(KAProgressLabel *label) {
        label.text = [NSString stringWithFormat:@"%.0f%%", (label.progress * 100)];
    };

    [self.progressLabelSedentaryTime setProgress:percentage
                                          timing:TPPropertyAnimationTimingEaseOut
                                        duration:0.3
                                           delay:0.0];
}

- (void)setSlouchTime:(NSTimeInterval)slouchTime {
    self.progressLabelBadPositionTime.labelVCBlock = ^(KAProgressLabel *label) {
        label.text = [NSString stringWithFormat:@"%.0f%%", (label.progress * 100)];
    };

    [self.progressLabelBadPositionTime setProgress:0.5
                                            timing:TPPropertyAnimationTimingEaseOut
                                          duration:1.0
                                             delay:5.0];


}

- (void)setUpViews {

    self.silhuetteImageView.alpha = 0.5f;

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
