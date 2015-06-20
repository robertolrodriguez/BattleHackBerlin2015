//
//  Bank.m
//  Charity
//
//  Created by Michal Banasiak on 20.06.2015.
//  Copyright (c) 2015 BattleHack. All rights reserved.
//

#import "Bank.h"
#import <PayPal-iOS-SDK/PayPalMobile.h>

@interface Bank () <PayPalFuturePaymentDelegate>

@property(nonatomic, assign, readwrite) CGFloat balance;
@property(nonatomic, strong) PayPalConfiguration *payPalConfig;
@property(nonatomic, weak) UIViewController *vc;

@end

@implementation Bank

- (instancetype)initWithViewController:(UIViewController *)vc {
  self = [super init];

  if (self) {
    _vc = vc;

    // Set up payPalConfig
    _payPalConfig = [[PayPalConfiguration alloc] init];
    _payPalConfig.acceptCreditCards = YES;
    _payPalConfig.merchantName = @"CHAIRity";
    _payPalConfig.merchantPrivacyPolicyURL = [NSURL
        URLWithString:@"https://www.paypal.com/webapps/mpp/ua/privacy-full"];
    _payPalConfig.merchantUserAgreementURL =
        [NSURL URLWithString:
                   @"https://www.paypal.com/webapps/mpp/ua/useragreement-full"];

    // Setting the languageOrLocale property is optional.
    //
    // If you do not set languageOrLocale, then the PayPalPaymentViewController
    // will present
    // its user interface according to the device's current language setting.
    //
    // Setting languageOrLocale to a particular language (e.g., @"es" for
    // Spanish) or
    // locale (e.g., @"es_MX" for Mexican Spanish) forces the
    // PayPalPaymentViewController
    // to use that language/locale.
    //
    // For full details, including a list of available languages and locales,
    // see PayPalPaymentViewController.h.

    _payPalConfig.languageOrLocale = [NSLocale preferredLanguages][0];

    // Setting the payPalShippingAddressOption property is optional.
    //
    // See PayPalConfiguration.h for details.

    _payPalConfig.payPalShippingAddressOption =
        PayPalShippingAddressOptionPayPal;

    // Do any additional setup after loading the view, typically from a nib.

    // self.successView.hidden = YES;

    // use default environment, should be Production in real life
    // self.environment = kPayPalEnvironment;

    NSLog(@"PayPal iOS SDK version: %@", [PayPalMobile libraryVersion]);
  }

  return self;
}

- (void)payPalFuturePaymentViewController:
            (PayPalFuturePaymentViewController *)futurePaymentViewController
                didAuthorizeFuturePayment:
                    (NSDictionary *)futurePaymentAuthorization {
  [futurePaymentViewController dismissViewControllerAnimated:YES
                                                  completion:nil];
  [self.delegate paypalDidAuthorize];
}

- (void)payPalFuturePaymentDidCancel:
    (PayPalFuturePaymentViewController *)futurePaymentViewController {
  [futurePaymentViewController dismissViewControllerAnimated:YES
                                                  completion:nil];
}

- (void)
payPalFuturePaymentViewController:
    (PayPalFuturePaymentViewController *)futurePaymentViewController
       willAuthorizeFuturePayment:(NSDictionary *)futurePaymentAuthorization
                  completionBlock:(PayPalFuturePaymentDelegateCompletionBlock)
                                      completionBlock {
  if (completionBlock)
    completionBlock();
}

- (void)authorize {
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    PayPalFuturePaymentViewController *fpViewController;
    fpViewController = [[PayPalFuturePaymentViewController alloc]
        initWithConfiguration:self.payPalConfig
                     delegate:self];

    // Present the PayPalFuturePaymentViewController
    [self.vc presentViewController:fpViewController
                          animated:YES
                        completion:nil];
  });
}

- (void)charge {
  self.balance += 0.4;
  [self.delegate balanceDidChange];
}

- (CGFloat)balance {
  return 0;
}

@end
