//
//  MyCustomView.m
//  AnimationSandbox
//
//  Created by David Casserly on 23/02/2010.
//  Copyright 2010 devedup.com. All rights reserved.
//

#import "Canvas.h"
#import <QuartzCore/QuartzCore.h>

#define degreesToRadian(x) (M_PI * x / 180.0)
#define radiansToDegrees(x) {x * 180 / M_PI;
@interface Canvas ()
@end
@implementation Canvas

- (void) animateCicleAlongPath {
	//Prepare the animation - we use keyframe animation for animations of this complexity
	CAKeyframeAnimation *pathAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
	//Set some variables on the animation
	pathAnimation.calculationMode = kCAAnimationPaced;
	//We want the animation to persist - not so important in this case - but kept for clarity
	//If we animated something from left to right - and we wanted it to stay in the new position, 
	//then we would need these parameters
	pathAnimation.fillMode = kCAFillModeForwards;
	pathAnimation.removedOnCompletion = NO;
	pathAnimation.duration = 3.0;
	//Lets loop continuously for the demonstration
	pathAnimation.repeatCount = 1;
	
	//Setup the path for the animation - this is very similar as the code the draw the line
	//instead of drawing to the graphics context, instead we draw lines on a CGPathRef
	//CGPoint endPoint = CGPointMake(310, 450);
	CGMutablePathRef curvedPath = CGPathCreateMutable();
	CGPathMoveToPoint(curvedPath, NULL, 150, 150);
	CGPathAddQuadCurveToPoint(curvedPath, NULL, 150, 350, 200, 250);
	CGPathAddQuadCurveToPoint(curvedPath, NULL, 310, 10, 250, -30);
	
	//Now we have the path, we tell the animation we want to use this path - then we release the path
	pathAnimation.path = curvedPath;
	CGPathRelease(curvedPath);


    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(25, 25, 25, 25)];
    label.text = @"€";
    label.textColor=[UIColor whiteColor];
    label.font = [UIFont systemFontOfSize:30 weight:0.01];
    [self addSubview:label];
     pathAnimation.delegate=self;
	//Add the animation to the circleView - once you add the animation to the layer, the animation starts
	[label.layer addAnimation:pathAnimation forKey:@"moveTheSquare"];


}
-(void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    [self removeFromSuperview];
    self.completion();
}

//This draws a quadratic bezier curved line right across the screen
- (void) drawACurvedLine {
	//Create a bitmap graphics context, you will later get a UIImage from this
	UIGraphicsBeginImageContext(CGSizeMake(320,460));
	CGContextRef ctx = UIGraphicsGetCurrentContext();
	
	//Set variables in the context for drawing
	CGContextSetLineWidth(ctx, 1.5);
	CGContextSetStrokeColorWithColor(ctx, [UIColor whiteColor].CGColor);
	
	//Set the start point of your drawing
	CGContextMoveToPoint(ctx, 100, 200);
	//The end point of the line is 310,450 .... i'm also setting a reference point of 10,450
	//A quadratic bezier curve is drawn using these coordinates - experiment and see the results.
	CGContextAddQuadCurveToPoint(ctx, 150, 350, 200, 250);
	//Add another curve, the opposite of the above - finishing back where we started
	CGContextAddQuadCurveToPoint(ctx, 310, 10, 200, 50);
	
	//Draw the line 
	CGContextDrawPath(ctx, kCGPathStroke);
	
	//Get a UIImage from the current bitmap context we created at the start and then end the image context
	UIImage *curve = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	
	//With the image, we need a UIImageView
	UIImageView *curveView = [[UIImageView alloc] initWithImage:curve];
	//Set the frame of the view - which is used to position it when we add it to our current UIView
	curveView.frame = CGRectMake(1, 1, 320, 460);
	curveView.backgroundColor = [UIColor clearColor];
	[self addSubview:curveView];
}

- (id)initWithFrame:(CGRect)frame {
	if (self = [super initWithFrame:frame]) {
		//[self drawACurvedLine];
		[self animateCicleAlongPath];
    }
    return self;
}


@end
