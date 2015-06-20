//
//  ViewController.m
//  Charity
//
//  Created by Kamil Pyć on 6/20/15.
//  Copyright (c) 2015 BattleHack. All rights reserved.
//

#import "ViewController.h"
#import "Bank.h"

@interface ViewController () <BankDelegate>
@property (nonatomic, strong)Bank *bank;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.bank = [[Bank alloc] initWithViewController:self];
    self.bank.delegate = self;
}

- (void)viewDidAppear:(BOOL)animated {
    
    [self.bank authorize];
}

- (void)balanceDidChange {

}

- (void)paypalDidAuthorize {

}

@end
