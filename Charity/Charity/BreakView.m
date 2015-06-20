//
//  BreakView.m
//  Charity
//
//  Created by Michal Banasiak on 20.06.2015.
//  Copyright (c) 2015 BattleHack. All rights reserved.
//

#import "BreakView.h"
#import <KAProgressLabel/KAProgressLabel.h>

@interface BreakView ()
@property (weak, nonatomic) IBOutlet KAProgressLabel *progressLabel;
@property (nonatomic, assign) NSTimeInterval slouchTime;
@property (nonatomic, strong) NSTimer *slouchingTimer;

@property (nonatomic, assign) NSTimeInterval acceptableSlouchTime;
@end
@implementation BreakView

+ (instancetype)breakView {
  BreakView* v = [[NSBundle mainBundle] loadNibNamed:@"BreakView" owner:nil
                                     options:nil][0];

    UIBlurEffect* blur = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
    UIView *view = [[UIVisualEffectView alloc] initWithEffect:blur];
    view.frame = CGRectMake(0, 0, 1000, 1000);
    view.translatesAutoresizingMaskIntoConstraints=NO;
//    blurView.setTranslatesAutoresizingMaskIntoConstraints(false)
//    view.insertSubview(blurView, atIndex: 0)
    v.backgroundColor=[UIColor clearColor];
    [v insertSubview:view atIndex:0];
    [v start];

    return v;
}

- (void)start {
    self.progressLabel.progressColor = [UIColor colorWithRed:0.360784f green:0.905882f blue:0.956863f alpha:1.0f];
    self.progressLabel.trackColor = [UIColor colorWithRed:0.226120f green:0.586848f blue:0.624792f alpha:1.0f];
    self.progressLabel.trackWidth = self.progressLabel.progressWidth = self.progressLabel.roundedCornersWidth = 20.0;

    [self slouchTimerStart:YES];
}

- (NSTimeInterval)acceptableSlouchTime {
    return 30.0;
}

- (void)slouchTimerStart:(BOOL)start {
    [self slouchTick:nil];

        self.slouchingTimer = [NSTimer scheduledTimerWithTimeInterval:1.0
                                                               target:self
                                                             selector:@selector(slouchTick:)
                                                             userInfo:nil
                                                              repeats:YES];

        

}

- (void)slouchTick:(id)info {
    self.slouchTime += 1.0;
}
- (void)setSlouchTime:(NSTimeInterval)slouchTime {

    _slouchTime = slouchTime;

    CGFloat percentage = (CGFloat) 1.0 - (slouchTime / self.acceptableSlouchTime);

    [self setLabel:self.progressLabel withTime:self.acceptableSlouchTime - slouchTime percentage:percentage];

    if (slouchTime >= self.acceptableSlouchTime) {
        //[self slouchTimerStart:NO];
        _slouchTime = 0.0;
        [self.slouchingTimer invalidate];
        [self removeFromSuperview];
    }
}

- (void)setLabel:(KAProgressLabel *)label withTime:(NSTimeInterval)time percentage:(CGFloat)percentage {

    NSInteger ti = (NSInteger)time;
    NSInteger seconds = ti % 60;
    NSInteger minutes = (ti / 60) % 60;

    label.text = [NSString stringWithFormat:@"%02ld:%02ld", (long)minutes, (long)seconds];

    [label setProgress:percentage
                timing:TPPropertyAnimationTimingEaseOut

              duration:1

                 delay:0.0];
}

@end
