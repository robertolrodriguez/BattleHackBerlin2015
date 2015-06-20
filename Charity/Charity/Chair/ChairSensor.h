//
//  ChairSensor.h
//  Charity
//
//  Created by Kamil Pyć on 6/20/15.
//  Copyright (c) 2015 BattleHack. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ChairSensor, JSTKeysSensor, JSTIRSensor;
@protocol ChairSensor <NSObject>

-(void)isTouching:(BOOL)isTouching sensor:(ChairSensor *)sensor;

@end

@interface ChairSensor : NSObject

@property (nonatomic, weak) id <ChairSensor> chairSensorDelegate;
- (instancetype)initWithKeysSensor:(JSTKeysSensor *)keysSensor irSensor:(JSTIRSensor *)irSensor;
@property(nonatomic, assign) BOOL isTouching;


@end
