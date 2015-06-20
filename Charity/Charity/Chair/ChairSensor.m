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
#import "JSTIRSensor.h"

@interface ChairSensor ()<JSTBaseSensorDelegate>
@property(nonatomic, strong) JSTKeysSensor *sensorKeys;
@property(nonatomic, strong) JSTIRSensor *irSensor;
@property (nonatomic, strong) NSMutableArray *values;
@property (nonatomic, strong) NSNumber *lastAverage;

@end

const NSUInteger JSTValuesRange  = 3; // 0,1s/value
const NSUInteger JSTValuesRangeDifferentialThreshold  = 1;

@implementation ChairSensor

- (instancetype)initWithKeysSensor:(JSTKeysSensor *)keysSensor irSensor:(JSTIRSensor *)irSensor{
    self = [self init];
    
    if (self) {
//        self.sensorKeys = keysSensor;
//        self.sensorKeys.sensorDelegate = self;
//        [self.sensorKeys setNotificationsEnabled:YES];

        self.irSensor = irSensor;
        [self.irSensor configureWithValue:JSTSensorIRTemperatureEnabled];
        self.irSensor.sensorDelegate = self;
        [self.irSensor setNotificationsEnabled:YES];
        [self.irSensor setPeriodValue:10];

        
        self.values = [NSMutableArray arrayWithCapacity:JSTValuesRange];
        
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
    } else if ([sensor isKindOfClass:[JSTIRSensor class]]) {
        JSTIRSensor *irSensor = (JSTIRSensor *) sensor;
        [self.values addObject:@(irSensor.objectTemperature)];
        [self.chairSensorDelegate newAmbientTemperature:irSensor.ambientTemperature];
        [self estimateValues];
    }
}

- (void)estimateValues {
    if (self.values.count == JSTValuesRange) {
        NSNumber *average = [self.values valueForKeyPath:@"@avg.self"];
        
        NSLog(@"who: %@,last_avg: %@, avg: %@", self, self.lastAverage, average);
        [self.values removeAllObjects];
        if (self.lastAverage) {
            if ( fabsf (average.floatValue ) > 24.f ) {
              
                    if (!self.isTouching) {
                        self.isTouching = YES;
                        [self.chairSensorDelegate isTouching:self.isTouching sensor:self];
                    }
                
            } else {
                
                if (self.isTouching) {
                    self.isTouching = NO;
                    [self.chairSensorDelegate isTouching:self.isTouching sensor:self];
                }
                
                NSLog(@"IR UP");
            }
        }
        self.lastAverage = average;

    }
}

- (void)sensorDidFailCommunicating:(JSTBaseSensor *)sensor withError:(NSError *)error {
    NSLog(@"ERror!");
}

- (void)sensorDidFinishCalibration:(JSTBaseSensor *)sensor {
    
}

@end
