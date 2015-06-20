//
//  TimerView.m
//  Charity
//
//  Created by Michal Banasiak on 20.06.2015.
//  Copyright (c) 2015 BattleHack. All rights reserved.
//

#import "TimerView.h"

@interface TimerView () {
  NSTimer *timer;
  NSTimeInterval time;
    UILabel*label;
}
@end

@implementation TimerView

- (void)start {

  timer = [NSTimer scheduledTimerWithTimeInterval:1
                                           target:self
                                         selector:@selector(timerDidTick:)
                                         userInfo:nil
                                          repeats:YES];
    if (!label) {
        label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
        label.textAlignment = NSTextAlignmentCenter;
        [self addSubview:label];
        label.textColor = [UIColor whiteColor];
    }
}

- (void)stop {
  [timer invalidate];
  timer = nil;
}

- (void)timerDidTick:(id)timer {
  time += 1;
  NSUInteger total = (NSUInteger)time;

  NSUInteger minutes = total / 60;
  NSUInteger seconds = total % 60;
  NSUInteger hours = minutes / 60;
  minutes = minutes % 60;

    NSString* timeString = [NSString stringWithFormat:@"%.1lu:%.2lu:%.2lu", (unsigned long)hours, (unsigned long)minutes, (unsigned long)seconds];
    NSLog(@"%@", timeString);
    label.text = timeString;
    [label sizeToFit];
}

@end
