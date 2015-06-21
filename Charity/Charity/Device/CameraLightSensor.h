//
//  CameraLightSensor.h
//  Charity
//
//  Created by Kamil Pyć on 6/21/15.
//  Copyright (c) 2015 BattleHack. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>


@protocol CameraLightSensorDelegate <NSObject>

- (void)setIsDark:(BOOL)isDark;

@end

@interface CameraLightSensor : NSObject
// AVFoundation Properties
@property (strong, nonatomic) AVCaptureSession * mySesh;
@property (strong, nonatomic) AVCaptureStillImageOutput *stillImageOutput;
@property (strong, nonatomic) AVCaptureDevice * myDevice;
@property (strong, nonatomic) AVCaptureVideoPreviewLayer * captureVideoPreviewLayer;
@property (nonatomic, weak) id <CameraLightSensorDelegate> delegate;

@end
