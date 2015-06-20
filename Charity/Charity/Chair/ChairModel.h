#import <Foundation/Foundation.h>
#import "ChairProtocol.h"

@interface ChairModel : NSObject

@property (nonatomic, weak) id <ChairProtocol> delegate;

@end
