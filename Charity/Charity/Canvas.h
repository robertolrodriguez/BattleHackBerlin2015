//
//  MyCustomView.h
//  AnimationSandbox
//
//  Created by David Casserly on 23/02/2010.
//  Copyright 2010 devedup.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Canvas : UIView {
	UIImageView *lorenaView;
	UIImageView *lineView;
}
@property (nonatomic, copy) void (^completion)();
@end
