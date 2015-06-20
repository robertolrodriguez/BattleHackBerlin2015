//
//  ChairSensor.m
//  Charity
//
//  Created by Kamil Pyć on 6/20/15.
//  Copyright (c) 2015 BattleHack. All rights reserved.
//

#import "ChairSensor.h"
#import "JSTBaseSensor.h"
#import "JSTKeysSensor.h"

@interface ChairSensor ()<JSTBaseSensorDelegate>
@property(nonatomic, strong) JSTKeysSensor *sensorKeys;
@end

@implementation ChairSensor

- (instancetype)initWithKeysSensor:(JSTKeysSensor *)keysSensor {
    self = [self init];
    
    if (self) {
        self.sensorKeys = keysSensor;
    }
    return self;
}


- (void)sensorDidUpdateValue:(JSTBaseSensor *)sensor {
    
    if ([sensor isKindOfClass:[JSTKeysSensor class]]) {
        JSTKeysSensor *keysSensor = (JSTKeysSensor *) sensor;
        
        if (keysSensor.pressedLeftButton || keysSensor.pressedRightButton) {
            if (!self.isTouching) {
                self.isTouching = YES;
                [self.chairSensorDelegate isTouching:self.isTouching sensor:self];
            }
        } else if (self.isTouching) {
                self.isTouching = NO;
                [self.chairSensorDelegate isTouching:self.isTouching sensor:self];
        }
    }
}

- (void)sensorDidFailCommunicating:(JSTBaseSensor *)sensor withError:(NSError *)error {
    NSLog(@"ERror!");
}

- (void)sensorDidFinishCalibration:(JSTBaseSensor *)sensor {
    
}

@end
