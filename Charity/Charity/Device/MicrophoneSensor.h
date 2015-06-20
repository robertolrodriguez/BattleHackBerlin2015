//
//  MicrophoneSensor.h
//  Charity
//
//  Created by Kamil Pyć on 6/20/15.
//  Copyright (c) 2015 BattleHack. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol MicroPhoneSensorDelegate <NSObject>

- (void)setLoudSoundState;
- (void)setNormalSoundState;

@end


@interface MicrophoneSensor : NSObject

@property (nonatomic, weak) id <MicroPhoneSensorDelegate>delegate;

@end
