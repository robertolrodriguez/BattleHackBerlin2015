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
#import "ChairControllerDelegate.h"
#import "ChairController.h"
#import "TimerViewController.h"
#import "ChairModel.h"

@interface ViewController () <BankDelegate , ChairControllerDelegate>
@property (nonatomic, strong) Bank *bank;
@property (nonatomic, weak) IBOutlet KAProgressLabel *progressLabelBadPositionTime;
@property (nonatomic, weak) IBOutlet KAProgressLabel *progressLabelSedentaryTime;
@property (nonatomic, weak) IBOutlet UIImageView *silhuetteImageView;

@property (strong, nonatomic) IBOutlet TimerViewController*timerViewController;
@property (nonatomic, strong) ChairModel *chairModel;

@property (nonatomic, strong) ChairController *chairController;
@property (weak, nonatomic) IBOutlet UILabel *balanceLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeOfWorkLabel;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.bank = [[Bank alloc] initWithViewController:self];
    self.bank.delegate = self;

    self.chairController = [[ChairController alloc] initWithSedentaryLabel:self.progressLabelSedentaryTime
                                                               slouchLabel:self.progressLabelBadPositionTime
                                                            silhuetteImage:self.silhuetteImageView
                                                   acceptableSedentaryTime:60.0 * 1.0
                                                      acceptableSlouchTime:10.0];


    [self updateBalance:self.bank.balance];

    self.chairModel = [ChairModel new];
    self.chairModel.delegate = self.chairController;
    self.timerViewController = [[TimerViewController alloc] initWithLabel:self.timeOfWorkLabel];
}

- (void)updateBalance:(CGFloat)balance {
    self.balanceLabel.text = [NSString stringWithFormat:@"Current balance: %.2f$", balance];
}

- (void)slouchingTimeExceeded {
    [self.bank charge];
}

- (void)sedentaryTimeExceeded {

}

- (void)viewDidAppear:(BOOL)animated {

    [self.bank authorize];

    self.chairController.sat = YES;
    self.chairController.slouched = YES;

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(10 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.bank charge];
        self.chairController.sat = NO;
    });

    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(10 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.timerViewController start];
        });
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(13 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.timerViewController stop];
        });
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(18 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.timerViewController start];
        });
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(20 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.timerViewController stop];
        });
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(26 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.timerViewController start];
        });
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(36 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.timerViewController stop];
        });
    });
}

- (void)balanceDidChange {


    [self updateBalance:self.bank.balance];
}
- (void)paypalDidAuthorize {


}

@end
