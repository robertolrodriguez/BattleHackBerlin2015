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

#import "ChairController.h"
#import "TimerView.h"
#import "ChairModel.h"

@interface ViewController () <BankDelegate>
@property (nonatomic, strong) Bank *bank;
@property (nonatomic, weak) IBOutlet KAProgressLabel *progressLabelBadPositionTime;
@property (nonatomic, weak) IBOutlet KAProgressLabel *progressLabelSedentaryTime;
@property (nonatomic, weak) IBOutlet UIImageView *silhuetteImageView;

@property (weak, nonatomic) IBOutlet TimerView*timerView;
@property (nonatomic, strong) ChairModel *chairModel;

@property (nonatomic, strong) ChairController *chairController;
@property (weak, nonatomic) IBOutlet UILabel *balanceLabel;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.bank = [[Bank alloc] initWithViewController:self];
    self.bank.delegate = self;

    self.chairController = [[ChairController alloc] initWithSedentaryLabel:self.progressLabelSedentaryTime
                                                               slouchLabel:self.progressLabelBadPositionTime
                                                            silhuetteImage:self.silhuetteImageView
                                                   acceptableSedentaryTime:20.0f
                                                      acceptableSlouchTime:5.0f];


    [self updateBalance:self.bank.balance];

    self.chairModel = [ChairModel new];
    self.chairModel.delegate = self.chairController;
}

- (void)updateBalance:(CGFloat)balance {
    self.balanceLabel.text = [NSString stringWithFormat:@"Current balance: %.2f$", balance];
}

- (void)viewDidAppear:(BOOL)animated {

    [self.bank authorize];

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(10 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.bank charge];
        self.chairController.sat = YES;
    });

    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(10 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.timerView start];
        });
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(13 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.timerView stop];
        });
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(18 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.timerView start];
        });
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(20 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.timerView stop];
        });
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(26 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.timerView start];
        });
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(36 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.timerView stop];
        });
    });
}

- (void)setSedentaryTime:(NSTimeInterval)time {

}

- (void)balanceDidChange {


    [self updateBalance:self.bank.balance];
}
- (void)paypalDidAuthorize {


}

@end
