//
//  TimerView.h
//  Charity
//
//  Created by Michal Banasiak on 20.06.2015.
//  Copyright (c) 2015 BattleHack. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TimerViewController : NSObject

- (id)initWithLabel:(UILabel*)label;

- (void)start;
- (void)stop;

@end
