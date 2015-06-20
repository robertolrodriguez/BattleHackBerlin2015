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
#import "BreakView.h"
#import "MicrophoneSensor.h"

@interface ViewController () <BankDelegate, ChairControllerDelegate,
                              ConnectionDelegate, MicroPhoneSensorDelegate>
@property (nonatomic, strong) Bank *bank;
@property (nonatomic, strong) TimerViewController *timerViewController;
@property (nonatomic, strong) ChairModel *chairModel;
@property (nonatomic, strong) ChairController *chairController;

@property (nonatomic, weak) IBOutlet KAProgressLabel *progressLabelBadPositionTime;
@property (nonatomic, weak) IBOutlet KAProgressLabel *progressLabelSedentaryTime;
@property (nonatomic, weak) IBOutlet UIImageView *silhuetteImageView;
@property (nonatomic, weak) IBOutlet UILabel *balanceLabel;
@property (nonatomic, weak) IBOutlet UILabel *timeOfWorkLabel;
@property (nonatomic, weak) IBOutlet UILabel *statusLabel;

@property (nonatomic, weak) IBOutlet UILabel *noiseLevelLabel;
@property (nonatomic, weak) IBOutlet UILabel *lightLevelLabel;
@property (nonatomic, weak) IBOutlet UILabel *temperatureLabel;
@property(nonatomic, strong) MicrophoneSensor *microphone;

@end

@implementation ViewController

- (void)viewDidLoad {
  [super viewDidLoad];

  self.bank = [[Bank alloc] initWithViewController:self];
  self.bank.delegate = self;
    self.microphone = [[MicrophoneSensor alloc] init];
    self.microphone.delegate = self;
  self.timerViewController =
      [[TimerViewController alloc] initWithLabel:self.timeOfWorkLabel];
  self.chairController = [[ChairController alloc]
       initWithSedentaryLabel:self.progressLabelSedentaryTime
                  slouchLabel:self.progressLabelBadPositionTime
               silhuetteImage:self.silhuetteImageView
          workTimerController:self.timerViewController
      acceptableSedentaryTime:30.0
         acceptableSlouchTime:20.0];
  self.chairController.delegate = self;

  [self updateBalance:self.bank.balance];

  self.chairModel = [ChairModel new];
  self.chairModel.delegate = self.chairController;
  self.chairModel.connectionDelegate = self;
}

- (IBAction)sit:(id)sender {
  self.chairController.sat = !self.chairController.sat;
}

- (IBAction)slouch:(id)sender {
  self.chairController.slouched = !self.chairController.slouched;
}

- (void)updateBalance:(CGFloat)balance {
  self.balanceLabel.text =
      [NSString stringWithFormat:@"Donated: %.2f €", balance];
}

- (void)slouchingTimeExceeded {
  [self.bank charge];
}

- (void)sedentaryTimeExceeded {
    [self showBreakView];
}

- (void)viewDidAppear:(BOOL)animated {
  //[self.bank authorize];

}

- (void)showBreakView {
    BreakView *v = [BreakView breakView];
    [self.view addSubview:v];
    v.frame = CGRectMake(0, 0, self.view.bounds.size.width - 0,
                         self.view.bounds.size.height - 0);
}

- (void)balanceDidChange {

  [self updateBalance:self.bank.balance];
}
- (void)paypalDidAuthorize {
}

- (void)newConnectionState:(ConnectionState)state {
  dispatch_async(dispatch_get_main_queue(), ^{

    self.statusLabel.textColor = [UIColor orangeColor];
    switch (state) {
    case ConnectionStateConnected:
      self.statusLabel.text = @"Connected!";
      self.statusLabel.textColor = [UIColor greenColor];

      break;
    case ConnectionStateConnetcting:
      self.statusLabel.text = @"Connecting...";
      break;
    case ConnectionStateFoundDevice:
      self.statusLabel.text = @"Found device";
      break;
    case ConnectionStateError:
      self.statusLabel.text = @"Error :-(";
      self.statusLabel.textColor = [UIColor redColor];

      break;
    case ConnectionStateSearchingForDevice:
      self.statusLabel.text = @"Searching for device";
      break;
    case ConnectionStateStartedConnection:
      self.statusLabel.text = @"Started connecting";
      break;
    default:
      break;
    }
  });
}

-(void)setLoudSoundState {
    self.noiseLevelLabel.text = @"High";
    self.noiseLevelLabel.textColor = [UIColor orangeColor];
}

-(void)setNormalSoundState {
    self.noiseLevelLabel.text = @"Low";
    self.noiseLevelLabel.textColor = [UIColor whiteColor];

}

- (void)newAmbientTemperature:(TemperatureState)ambientTemp {
    dispatch_async(dispatch_get_main_queue(), ^{

    switch (ambientTemp) {
        case TemperatureStateHigh:
            self.temperatureLabel.text = @"High";
            self.temperatureLabel.textColor = [UIColor orangeColor];
            break;
        case TemperatureStateMedium:
            self.temperatureLabel.text = @"Good";
            self.temperatureLabel.textColor = [UIColor whiteColor];
            break;
        case TemperatureStateLow:
            self.temperatureLabel.text = @"Low";
            self.temperatureLabel.textColor = [UIColor blueColor];
            break;
            
        default:
            break;
    }
    });
}

@end
