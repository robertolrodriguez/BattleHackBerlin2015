#import "ChairModel.h"
#import "JSTSensorManager.h"

@interface ChairModel ()<JSTSensorManagerDelegate>


@property(nonatomic, strong) JSTSensorManager *sensorManager;

@end


NSString *deviceBackID = @"CEC309C3-ACAB-5589-4221-5B148E243DD9";

@implementation ChairModel

- (instancetype)init {
    if (self = [super init]) {
        self.sensorManager = [JSTSensorManager sharedInstance];
        self.sensorManager.delegate = self;
    }
    
    return self;
}

- (void)manager:(JSTSensorManager *)manager didConnectSensor:(JSTSensorTag *)sensor {
    
}

- (void)manager:(JSTSensorManager *)manager didDisconnectSensor:(JSTSensorTag *)sensor error:(NSError *)error {
    
}

- (void)manager:(JSTSensorManager *)manager didFailToConnectToSensorWithError:(NSError *)error {
    
}

- (void)manager:(JSTSensorManager *)manager didDiscoverSensor:(JSTSensorTag *)sensor {
    [self ]
}

- (void)manager:(JSTSensorManager *)manager didChangeStateTo:(CBCentralManagerState)state {
    if (manager.state == CBCentralManagerStatePoweredOn) {
        [manager startScanning];
    }
}

@end
