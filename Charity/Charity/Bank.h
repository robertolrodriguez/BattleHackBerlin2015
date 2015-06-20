//
//  Bank.h
//  Charity
//
//  Created by Michal Banasiak on 20.06.2015.
//  Copyright (c) 2015 BattleHack. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@protocol BankDelegate <NSObject>

- (void)balanceDidChange;
- (void)paypalDidAuthorize;

@end

@interface Bank : NSObject

@property(nonatomic, assign, readonly) CGFloat balance;
@property(nonatomic, weak) id<BankDelegate> delegate;

- (instancetype)initWithViewController:(UIViewController*)vc;

- (void)authorize;

- (void)charge;

@end
