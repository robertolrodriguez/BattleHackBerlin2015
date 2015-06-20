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
#import "ChairController.h"

@interface ViewController () <BankDelegate>
@property (nonatomic, strong) Bank *bank;
@property (nonatomic, weak) IBOutlet KAProgressLabel *progressLabelBadPositionTime;
@property (nonatomic, weak) IBOutlet KAProgressLabel *progressLabelSedentaryTime;
@property (nonatomic, weak) IBOutlet UIImageView *silhuetteImageView;
@property (weak, nonatomic) IBOutlet BalanceView *balanceView;

@property (nonatomic, strong) ChairController *chairController;

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

    [self.balanceView updateBalance:self.bank.balance];
}

- (void)viewDidAppear:(BOOL)animated {

    [self.bank authorize];

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(10 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.bank charge];
        self.chairController.sat = YES;
    });
}

- (void)setSedentaryTime:(NSTimeInterval)time {

}

- (void)balanceDidChange {


    [self.balanceView updateBalance:self.bank.balance];
}
- (void)paypalDidAuthorize {


}

@end
