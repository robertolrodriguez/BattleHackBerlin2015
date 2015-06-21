//
//  CameraLightSensor.m
//  Charity
//
//  Created by Kamil Pyć on 6/21/15.
//  Copyright (c) 2015 BattleHack. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CameraLightSensor.h"


@interface CameraLightSensor ()
@property (nonatomic, strong) 	NSTimer *levelTimer;

@end

@implementation CameraLightSensor


- (void)setup {
    // rear camera: 0 front camera: 1
    NSArray *devices = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
    if (devices.count==0) {
        NSLog(@"SC: No devices found (for example: simulator)");
        return;
    }
    _myDevice = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo][0];
    
    if ([_myDevice isFlashAvailable] && _myDevice.flashActive && [_myDevice lockForConfiguration:nil]) {
        //NSLog(@"SC: Turning Flash Off ...");
        _myDevice.flashMode = AVCaptureFlashModeOff;
        [_myDevice unlockForConfiguration];
    }
    
    NSError * error = nil;
    AVCaptureDeviceInput * input = [AVCaptureDeviceInput deviceInputWithDevice:_myDevice error:&error];
    
    if (!input) {
        // Handle the error appropriately.
        NSLog(@"SC: ERROR: trying to open camera: %@", error);
    }
    
    [_mySesh addInput:input];
    
    _stillImageOutput = [[AVCaptureStillImageOutput alloc] init];
    NSDictionary * outputSettings = [[NSDictionary alloc] initWithObjectsAndKeys: AVVideoCodecJPEG, AVVideoCodecKey, nil];
    [_stillImageOutput setOutputSettings:outputSettings];
    [_mySesh addOutput:_stillImageOutput];
    
    
    [_mySesh startRunning];
    
    
    self.levelTimer = [NSTimer scheduledTimerWithTimeInterval: 0.3 target: self selector: @selector(capturePhoto) userInfo: nil repeats: YES];

    
}

-(instancetype)init {
    self = [super init];
    
    
    if (self) {
        // Thanks: http://stackoverflow.com/a/24684021/2611971
        AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    
        switch (status) {
            case AVAuthorizationStatusAuthorized:
                [self setup];
                break;
            case AVAuthorizationStatusNotDetermined:
            {
                [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
                    if(granted){
                        [self setup];
                    }
                }];
            }
                break;
                
            default:
                break;
        }
        
        
    }
    
    return self;
    
}

#pragma mark - Setup

- (void) capturePhoto {
 
    AVCaptureConnection *videoConnection = nil;
    for (AVCaptureConnection *connection in _stillImageOutput.connections)
    {
        for (AVCaptureInputPort *port in [connection inputPorts])
        {
            if ([[port mediaType] isEqual:AVMediaTypeVideo] )
            {
                videoConnection = connection;
                break;
            }
        }
        if (videoConnection) { break; }
    }
    
    
    
    if (!videoConnection) {
        return;
    }
    
    [_stillImageOutput captureStillImageAsynchronouslyFromConnection:videoConnection completionHandler: ^(CMSampleBufferRef imageSampleBuffer, NSError *error)
     {
         if(!CMSampleBufferIsValid(imageSampleBuffer))
         {
             return;
         }
         NSData *imageData = [AVCaptureStillImageOutput jpegStillImageNSDataRepresentation:imageSampleBuffer];
         
         UIImage * capturedImage = [[UIImage alloc]initWithData:imageData scale:1];
         
         if (_myDevice == [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo][0]) {
             // rear camera active
       
                 CGImageRef cgRef = capturedImage.CGImage;
                 capturedImage = [[UIImage alloc] initWithCGImage:cgRef scale:1.0 orientation:UIImageOrientationDown];
         }
         else if (_myDevice == [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo][1]) {
             // front camera active
          
                     capturedImage = [UIImage imageWithCGImage:capturedImage.CGImage scale:capturedImage.scale orientation:UIImageOrientationUpMirrored];
             
         }
         [self analyzeLight:capturedImage];
         imageData = nil;
         
     }];
}


-(void)analyzeLight:(UIImage *)image {
    
}

@end
