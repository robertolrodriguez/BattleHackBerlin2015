//
//  ViewController.m
//  Charity
//
//  Created by Kamil Pyć on 6/20/15.
//  Copyright (c) 2015 BattleHack. All rights reserved.
//

#import "ViewController.h"
#import "Bank.h"
#import <KAProgressLabel/KAProgressLabel.h>
#import "BalanceView.h"
#import "TimerView.h"

@interface ViewController () <BankDelegate>
@property (nonatomic, weak) IBOutlet KAProgressLabel *progressLabelBadPositionTime;
@property (nonatomic, strong)Bank *bank;
@property (nonatomic, weak) IBOutlet KAProgressLabel *progressLabelSedentaryTime;
@property (nonatomic, weak) IBOutlet UIImageView *silhuetteImageView;
@property (weak, nonatomic) IBOutlet BalanceView *balanceView;
@property (strong, nonatomic) IBOutlet TimerView* timerView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.bank = [[Bank alloc] initWithViewController:self];
    self.bank.delegate = self;

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

    [self setUpCirculars];
    [self.balanceView updateBalance:self.bank.balance];


}

- (void)viewDidAppear:(BOOL)animated {
    
    [self.bank authorize];

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(10 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{

        [self.bank charge];
    });
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.timerView start];
        });
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(8 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.timerView stop];
        });
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(15 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.timerView start];
        });
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.timerView stop];
        });
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(28 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.timerView start];
        });
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(35 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.timerView stop];
        });
    });


}

- (void)balanceDidChange {

    [self.progressLabelBadPositionTime setProgress:0.5
                                            timing:TPPropertyAnimationTimingEaseOut
                                          duration:1.0
                                             delay:5.0];

    [self.progressLabelSedentaryTime setProgress:0.5
                                          timing:TPPropertyAnimationTimingEaseOut
                                        duration:1.0
                                           delay:5.0];

    [self setUpCirculars];

    [self.balanceView updateBalance:self.bank.balance];
}
- (void)paypalDidAuthorize {


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
