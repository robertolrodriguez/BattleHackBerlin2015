//
//  ChairController.h
//  Charity
//
//  Created by Oktawian Chojnacki on 20.06.2015.
//  Copyright (c) 2015 BattleHack. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ChairProtocol.h"
#import "ChairControllerDelegate.h"

@class KAProgressLabel;
@class TimerViewController;

@interface ChairController : NSObject <ChairProtocol>

@property (nonatomic, assign) BOOL sat;
@property (nonatomic, assign) BOOL slouched;

@property (nonatomic, weak) id<ChairControllerDelegate> delegate;

- (instancetype)initWithSedentaryLabel:(KAProgressLabel *)sedentary
                           slouchLabel:(KAProgressLabel *)slouch
                        silhuetteImage:(UIImageView *)silhuette
                   workTimerController:(TimerViewController *)workController
               acceptableSedentaryTime:(NSTimeInterval)sedentaryTime
                  acceptableSlouchTime:(NSTimeInterval)slouchTime NS_DESIGNATED_INITIALIZER;

@end
