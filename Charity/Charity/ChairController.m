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

        [self setUpCirculars];
    }

    return self;
}

- (void)slouchTimerStart:(BOOL)start {
    
}

- (void)setSedentaryTimer:(NSTimeInterval)slouchTimer {

}

- (void)setSlouchTimer:(NSTimeInterval)slouchTimer {
    self.progressLabelBadPositionTime.labelVCBlock = ^(KAProgressLabel *label) {
        label.text = [NSString stringWithFormat:@"%.0f%%", (label.progress * 100)];
    };

    [self.progressLabelBadPositionTime setProgress:0.5
                                            timing:TPPropertyAnimationTimingEaseOut
                                          duration:1.0
                                             delay:5.0];

    [self.progressLabelSedentaryTime setProgress:0.5
                                          timing:TPPropertyAnimationTimingEaseOut
                                        duration:1.0
                                           delay:5.0];
}

- (void)setUpCirculars {

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
