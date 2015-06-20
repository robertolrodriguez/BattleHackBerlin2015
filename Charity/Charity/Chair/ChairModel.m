#import "ChairModel.h"
#import "JSTSensorManager.h"
#import "JSTSensorTag.h"
#import "ChairSensor.h"

@interface ChairModel ()<JSTSensorManagerDelegate, ChairSensor>

@property(nonatomic, strong) JSTSensorManager *sensorManager;
@property(nonatomic, strong) NSArray *sensors;
@property(nonatomic, strong) ChairSensor *upperSensor;
@property(nonatomic, strong) ChairSensor *lowerSensor;
@property(nonatomic, assign) BOOL currentState;

@end


NSString *deviceBackID = @"F9478D87-4FC2-0F34-E522-9B02EED5D211";
NSString *deviceAssID = @"3D561BD7-53FC-FAAA-811C-A4EA4CC401DA";

@implementation ChairModel

-(void)isTouching:(BOOL)isTouching sensor:(ChairSensor *)sensor {
    [self updateState];
}

- (void)updateState {
    dispatch_async(dispatch_get_main_queue(), ^{
        if (self.lowerSensor.isTouching && self.upperSensor.isTouching) {
            //Good position
            NSLog(@"Good position");
            [self.delegate setSat:YES];
            [self.delegate setSlouched:NO];
        } else if (!self.lowerSensor.isTouching) {
            //Up position
            [self.delegate setSat:NO];
            [self.delegate setSlouched:NO];
        } else {
            NSLog(@"Wrong position");
            [self.delegate setSat:YES];
            [self.delegate setSlouched:YES];
        }
    });
}

- (instancetype)init {
    if (self = [super init]) {
        self.sensorManager = [JSTSensorManager sharedInstance];
        self.sensorManager.delegate = self;
    }
    
    return self;
}

- (void)manager:(JSTSensorManager *)manager didConnectSensor:(JSTSensorTag *)sensor {
    BOOL allSensorsConnected = YES;
    if (!self.upperSensor && [[sensor.peripheral.identifier UUIDString] isEqualToString:deviceBackID]) {
        self.upperSensor = [[ChairSensor alloc]initWithKeysSensor:sensor.keysSensor irSensor:sensor.irSensor];
        self.upperSensor.chairSensorDelegate = self;
    } else if (!self.lowerSensor && [[sensor.peripheral.identifier UUIDString] isEqualToString:deviceAssID]) {
        self.lowerSensor = [[ChairSensor alloc]initWithKeysSensor:sensor.keysSensor irSensor:sensor.irSensor];
        self.lowerSensor.chairSensorDelegate = self;
    }
    for (JSTSensorTag *sensorTag in self.sensors) {
        allSensorsConnected &= (sensorTag.peripheral.state == CBPeripheralStateConnected);
    }
    if (allSensorsConnected) {
        NSLog(@"All conneteced!");
        [self.connectionDelegate newConnectionState:ConnectionStateConnected];

    } else {
        JSTSensorTag *next = nil;
        for (JSTSensorTag *sensorTag in self.sensors) {
            if (sensorTag.peripheral.state != CBPeripheralStateConnected) {
                next = sensorTag;
                break;
            }
        }
        [self.connectionDelegate newConnectionState:ConnectionStateConnetcting];

        [self.sensorManager connectSensorWithUUID:next.peripheral.identifier];
    }
}

- (void)manager:(JSTSensorManager *)manager didDisconnectSensor:(JSTSensorTag *)sensor error:(NSError *)error {
    
}

- (void)manager:(JSTSensorManager *)manager didFailToConnectToSensorWithError:(NSError *)error {
    dispatch_async(dispatch_get_main_queue(), ^{
        [[[UIAlertView alloc] initWithTitle:@"Error" message:error.localizedDescription delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
    });
    [self.connectionDelegate newConnectionState:ConnectionStateError];

}

- (void)tryToConnectToSensors:(NSArray *)sensors {
    self.sensors = sensors;
    [self.connectionDelegate newConnectionState:ConnectionStateStartedConnection];
    [self.sensorManager connectSensorWithUUID:((JSTSensorTag *)[self.sensors firstObject]).peripheral.identifier];
}

- (void)manager:(JSTSensorManager *)manager didDiscoverSensor:(JSTSensorTag *)sensor {
    if (self.sensorManager.sensors.count == 2) {
        [self tryToConnectToSensors:self.sensorManager.sensors];
        [self.connectionDelegate newConnectionState:ConnectionStateFoundDevice];

        [manager stopScanning];
    }
}

- (void)manager:(JSTSensorManager *)manager didChangeStateTo:(CBCentralManagerState)state {
    if (manager.state == CBCentralManagerStatePoweredOn) {
        //[manager startScanning:@[[CBUUID UUIDWithString:deviceAssID],[CBUUID UUIDWithString: deviceBackID]]];
        [self.connectionDelegate newConnectionState:ConnectionStateSearchingForDevice];
        [manager startScanning:nil];
    }

}

@end
