#import <Foundation/Foundation.h>
#import "ChairProtocol.h"

typedef NS_ENUM(NSUInteger, ConnectionState) {
    ConnectionStateSearchingForDevice,
    ConnectionStateFoundDevice,
    ConnectionStateStartedConnection,
    ConnectionStateConnetcting,
    ConnectionStateConnected,
    ConnectionStateError
};

typedef NS_ENUM(NSUInteger, TemperatureState) {
    TemperatureStateLow,
    TemperatureStateMedium,
    TemperatureStateHigh
};



@protocol ConnectionDelegate <NSObject>

- (void)newConnectionState:(ConnectionState)state;
- (void)newAmbientTemperature:(TemperatureState)ambientTemp;

@end


@interface ChairModel : NSObject

@property (nonatomic, weak) id <ChairProtocol> delegate;
@property (nonatomic, weak) id <ConnectionDelegate> connectionDelegate;

- (void)reconnect;

@end
