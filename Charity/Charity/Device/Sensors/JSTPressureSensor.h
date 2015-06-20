#import <Foundation/Foundation.h>
#import "JSTBaseSensor.h"

typedef enum {
    JSTSensorPressureDisabled          = 0x00,
    JSTSensorPressureEnabled           = 0x01,
    JSTSensorPressureReadCalibration   = 0x02,
} JSTSensorBarometerConfig;

@interface JSTPressureSensor : JSTBaseSensor
@property(nonatomic, readonly) float pressure;
@property(nonatomic, readonly) float temperature;

- (void)calibrate;
@end
