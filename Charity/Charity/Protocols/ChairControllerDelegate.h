//
//  Created by Oktawian Chojnacki on 20.06.2015.
//  Copyright (c) 2015 BattleHack. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol ChairControllerDelegate <NSObject>
- (void)slouchingTimeExceeded;
- (void)sedentaryTimeExceeded;
@end
