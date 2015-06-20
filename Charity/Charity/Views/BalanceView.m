//
//  BalanceView.m
//  Charity
//
//  Created by Michal Banasiak on 20.06.2015.
//  Copyright (c) 2015 BattleHack. All rights reserved.
//

#import "BalanceView.h"

@interface BalanceView ()
{
    UILabel *label;
}


@end


@implementation BalanceView

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];

    if (self) {
        label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
        [self addSubview:label];
    }

    return self;
}

- (void)updateBalance:(CGFloat)balance {
    [label setText:[NSString stringWithFormat:@"Current balance: %.2f $", balance]];
    [label sizeToFit];
}

@end
