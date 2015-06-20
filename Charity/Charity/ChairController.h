//
//  ChairController.h
//  Charity
//
//  Created by Oktawian Chojnacki on 20.06.2015.
//  Copyright (c) 2015 BattleHack. All rights reserved.
//

#import <UIKit/UIKit.h>

@class KAProgressLabel;

@interface ChairController : NSObject

- (instancetype)initWithSedentaryLabel:(KAProgressLabel *)sedentary
                           slouchLabel:(KAProgressLabel *)slouch
                        silhuetteImage:(UIImageView *)silhuette
               acceptableSedentaryTime:(NSTimeInterval)sedentaryTime
                  acceptableSlouchTime:(NSTimeInterval)slouchTime NS_DESIGNATED_INITIALIZER;

@end
