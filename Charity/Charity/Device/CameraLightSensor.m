//
//  CameraLightSensor.m
//  Charity
//
//  Created by Kamil Pyć on 6/21/15.
//  Copyright (c) 2015 BattleHack. All rights reserved.
//

#import "CameraLightSensor.h"

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



}

#pragma mark - Setup


- (void) setup {
    
    self.view.clipsToBounds = NO;
    self.view.backgroundColor = [UIColor blackColor];
    
    /*
     The layout has shifted in iOS 8 causing problems.  I realize that this isn't the best solution, so if you're looking at this, feel free to submit a Pull Request.  This is an older project.
     */
    CGRect screen = [UIScreen mainScreen].bounds;
    CGFloat currentWidth = CGRectGetWidth(screen);
    CGFloat currentHeight = CGRectGetHeight(screen);
    screenWidth = currentWidth < currentHeight ? currentWidth : currentHeight;
    screenHeight = currentWidth < currentHeight ? currentHeight : currentWidth;
    
    if (_imageStreamV == nil) _imageStreamV = [[UIView alloc]init];
    _imageStreamV.alpha = 0;
    _imageStreamV.frame = self.view.bounds;
    [self.view addSubview:_imageStreamV];
    
    if (_capturedImageV == nil) _capturedImageV = [[UIImageView alloc]init];
    _capturedImageV.frame = _imageStreamV.frame; // just to even it out
    _capturedImageV.backgroundColor = [UIColor clearColor];
    _capturedImageV.userInteractionEnabled = YES;
    _capturedImageV.contentMode = UIViewContentModeScaleAspectFill;
    [self.view insertSubview:_capturedImageV aboveSubview:_imageStreamV];
    
    // for focus
    UITapGestureRecognizer * focusTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapSent:)];
    focusTap.numberOfTapsRequired = 1;
    [_capturedImageV addGestureRecognizer:focusTap];
    
    // SETTING UP CAM
    if (_mySesh == nil) _mySesh = [[AVCaptureSession alloc] init];
    _mySesh.sessionPreset = AVCaptureSessionPresetPhoto;
    
    _captureVideoPreviewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:_mySesh];
    _captureVideoPreviewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    _captureVideoPreviewLayer.frame = _imageStreamV.layer.bounds; // parent of layer
    
    [_imageStreamV.layer addSublayer:_captureVideoPreviewLayer];
    
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
        [_delegate simpleCam:self didFinishWithImage:_capturedImageV.image];
    }
    
    [_mySesh addInput:input];
    
    _stillImageOutput = [[AVCaptureStillImageOutput alloc] init];
    NSDictionary * outputSettings = [[NSDictionary alloc] initWithObjectsAndKeys: AVVideoCodecJPEG, AVVideoCodecKey, nil];
    [_stillImageOutput setOutputSettings:outputSettings];
    [_mySesh addOutput:_stillImageOutput];
    
    
    [_mySesh startRunning];
    
    if (self.interfaceOrientation == UIInterfaceOrientationLandscapeLeft) {
        _captureVideoPreviewLayer.connection.videoOrientation = AVCaptureVideoOrientationLandscapeLeft;
    }
    else if (self.interfaceOrientation == UIInterfaceOrientationLandscapeRight) {
        _captureVideoPreviewLayer.connection.videoOrientation = AVCaptureVideoOrientationLandscapeRight;
    }
    
    if (_isSquareMode) {
        NSLog(@"SC: isSquareMode");
        _squareV = [[UIView alloc]init];
        _squareV.backgroundColor = [UIColor clearColor];
        _squareV.layer.borderWidth = 4;
        _squareV.layer.borderColor = [UIColor colorWithWhite:1 alpha:.8].CGColor;
        _squareV.bounds = CGRectMake(0, 0, screenWidth, screenWidth);
        _squareV.center = self.view.center;
        _squareV.userInteractionEnabled = NO;
        
        _squareV.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
        
        [self.view addSubview:_squareV];
    }
    
    // -- LOAD ROTATION COVERS BEGIN -- //
    /*
     Rotating causes a weird flicker, I'm in the process of looking for a better
     solution, but for now, this works.
     */
    
    // Stream Cover
    _rotationCover = [UIView new];
    _rotationCover.backgroundColor = [UIColor blackColor];
    _rotationCover.bounds = CGRectMake(0, 0, screenHeight * 3, screenHeight * 3); // 1 full screen size either direction
    _rotationCover.center = self.view.center;
    _rotationCover.autoresizingMask = UIViewAutoresizingNone;
    _rotationCover.alpha = 0;
    [self.view insertSubview:_rotationCover belowSubview:_imageStreamV];
    // -- LOAD ROTATION COVERS END -- //
    
    // -- PREPARE OUR CONTROLS -- //
    [self loadControls];
}

#pragma mark CAMERA CONTROLS

- (void) loadControls {
    
    // -- LOAD BUTTON IMAGES BEGIN -- //
    UIImage * previousImg = [UIImage imageNamed:@"Previous.png"];
    UIImage * downloadImg = [UIImage imageNamed:@"Download.png"];
    UIImage * lighteningImg = [UIImage imageNamed:@"Lightening.png"];
    UIImage * cameraRotateImg = [UIImage imageNamed:@"CameraRotate.png"];
    // -- LOAD BUTTON IMAGES END -- //
    
    // -- LOAD BUTTONS BEGIN -- //
    _backBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    [_backBtn addTarget:self action:@selector(backBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
    [_backBtn setImage:previousImg forState:UIControlStateNormal];
    [_backBtn setTintColor:[self redColor]];
    [_backBtn setImageEdgeInsets:UIEdgeInsetsMake(9, 10, 9, 13)];
    
    _flashBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    [_flashBtn addTarget:self action:@selector(flashBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
    [_flashBtn setImage:lighteningImg forState:UIControlStateNormal];
    [_flashBtn setTintColor:[self redColor]];
    [_flashBtn setImageEdgeInsets:UIEdgeInsetsMake(6, 9, 6, 9)];
    
    _switchCameraBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    [_switchCameraBtn setImage:cameraRotateImg forState:UIControlStateNormal];
    [_switchCameraBtn setTintColor:[self blueColor]];
    [_switchCameraBtn setImageEdgeInsets:UIEdgeInsetsMake(9.5, 7, 9.5, 7)];
    
    _saveBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    [_saveBtn addTarget:self action:@selector(saveBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
    [_saveBtn setImage:downloadImg forState:UIControlStateNormal];
    [_saveBtn setTintColor:[self blueColor]];
    [_saveBtn setImageEdgeInsets:UIEdgeInsetsMake(7, 10.5, 7, 10.5)];
    
    _captureBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    [_captureBtn addTarget:self action:@selector(captureBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
    [_captureBtn setTitle:NSLocalizedString(@"C\nA\nP\nT\nU\nR\nE", @"SimpleCam CAPTURE button for horizontal") forState:UIControlStateNormal];
    [_captureBtn setTitleColor:[self darkGreyColor] forState:UIControlStateNormal];
    _captureBtn.titleLabel.font = [UIFont systemFontOfSize:12.5];
    _captureBtn.titleLabel.numberOfLines = 0;
    _captureBtn.titleLabel.minimumScaleFactor = .5;
    // -- LOAD BUTTONS END -- //
    
    // Stylize buttons
    for (UIButton * btn in @[_backBtn, _captureBtn, _flashBtn, _switchCameraBtn, _saveBtn])  {
        
        btn.bounds = CGRectMake(0, 0, 40, 40);
        btn.backgroundColor = [UIColor colorWithWhite:1 alpha:.96];
        btn.alpha = optionAvailableAlpha;
        btn.hidden = YES;
        
        btn.layer.shouldRasterize = YES;
        btn.layer.rasterizationScale = [UIScreen mainScreen].scale;
        btn.layer.cornerRadius = 4;
        
        btn.layer.borderColor = [UIColor lightGrayColor].CGColor;
        btn.layer.borderWidth = 0.5;
        
        [self.view addSubview:btn];
    }
    
    // If a device doesn't have multiple cameras, fade out button ...
    if ([AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo].count == 1) {
        _switchCameraBtn.alpha = optionUnavailableAlpha;
    }
    else {
        [_switchCameraBtn addTarget:self action:@selector(switchCameraBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    // Draw camera controls
    [self drawControls];
}

- (void) drawControls {
    
    if (self.hideAllControls) {
        
        // In case they want to hide after they've been displayed
        // for (UIButton * btn in @[_backBtn, _captureBtn, _flashBtn, _switchCameraBtn, _saveBtn]) {
        // btn.hidden = YES;
        // }
        return;
    }
    
    static int offsetFromSide = 10;
    static int offsetBetweenButtons = 20;
    
    static CGFloat portraitFontSize = 16.0;
    static CGFloat landscapeFontSize = 12.5;
    
    [UIView animateWithDuration:self.controlAnimateDuration delay:0 options:UIViewAnimationOptionCurveEaseOut  animations:^{
        
        if (UIInterfaceOrientationIsPortrait(self.interfaceOrientation)) {
            
            CGFloat centerY = screenHeight - 8 - 20; // 8 is offset from bottom (portrait), 20 is half btn height
            
            _backBtn.center = CGPointMake(offsetFromSide + (_backBtn.bounds.size.width / 2), centerY);
            
            // offset from backbtn is '20'
            [_captureBtn setTitle:NSLocalizedString(@"CAPTURE", @"SimpleCam CAPTURE button") forState:UIControlStateNormal];
            _captureBtn.titleLabel.font = [UIFont systemFontOfSize:portraitFontSize];
            _captureBtn.bounds = CGRectMake(0, 0, 120, 40);
            _captureBtn.center = CGPointMake(_backBtn.center.x + (_backBtn.bounds.size.width / 2) + offsetBetweenButtons + (_captureBtn.bounds.size.width / 2), centerY);
            
            // offset from capturebtn is '20'
            _flashBtn.center = CGPointMake(_captureBtn.center.x + (_captureBtn.bounds.size.width / 2) + offsetBetweenButtons + (_flashBtn.bounds.size.width / 2), centerY);
            
            // offset from flashBtn is '20'
            _switchCameraBtn.center = CGPointMake(_flashBtn.center.x + (_flashBtn.bounds.size.width / 2) + offsetBetweenButtons + (_switchCameraBtn.bounds.size.width / 2), centerY);
            
        }
        else {
            CGFloat centerX = screenHeight - 8 - 20; // 8 is offset from side(landscape), 20 is half btn height
            
            // offset from side is '10'
            _backBtn.center = CGPointMake(centerX, offsetFromSide + (_backBtn.bounds.size.height / 2));
            
            // offset from backbtn is '20'
            [_captureBtn setTitle:NSLocalizedString(@"C\nA\nP\nT\nU\nR\nE", @"SimpleCam CAPTURE button for horizontal") forState:UIControlStateNormal];
            _captureBtn.titleLabel.font = [UIFont systemFontOfSize:landscapeFontSize];
            _captureBtn.bounds = CGRectMake(0, 0, 40, 120);
            _captureBtn.center = CGPointMake(centerX, _backBtn.center.y + (_backBtn.bounds.size.height / 2) + offsetBetweenButtons + (_captureBtn.bounds.size.height / 2));
            
            // offset from capturebtn is '20'
            _flashBtn.center = CGPointMake(centerX, _captureBtn.center.y + (_captureBtn.bounds.size.height / 2) + offsetBetweenButtons + (_flashBtn.bounds.size.height / 2));
            
            // offset from flashBtn is '20'
            _switchCameraBtn.center = CGPointMake(centerX, _flashBtn.center.y + (_flashBtn.bounds.size.height / 2) + offsetBetweenButtons + (_switchCameraBtn.bounds.size.height / 2));
        }
        
        // just so it's ready when we need it to be.
        _saveBtn.frame = _switchCameraBtn.frame;
        
        /*
         Show the proper controls for picture preview and picture stream
         */
        
        // If camera preview -- show preview controls / hide capture controls
        if (_capturedImageV.image) {
            // Hide
            for (UIButton * btn in @[_captureBtn, _flashBtn, _switchCameraBtn]) btn.hidden = YES;
            // Show
            _saveBtn.hidden = NO;
            
            
            // Force User Preference
            _backBtn.hidden = _hideBackButton;
        }
        // ELSE camera stream -- show capture controls / hide preview controls
        else {
            // Show
            for (UIButton * btn in @[_flashBtn, _switchCameraBtn]) btn.hidden = NO;
            // Hide
            _saveBtn.hidden = YES;
            
            // Force User Preference
            _captureBtn.hidden = _hideCaptureButton;
            _backBtn.hidden = _hideBackButton;
        }
        
        [self evaluateFlashBtn];
        
    } completion:nil];
}

- (void) capturePhoto {
    if (isCapturingImage) {
        return;
    }
    isCapturingImage = YES;
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
             if (self.interfaceOrientation == UIInterfaceOrientationLandscapeRight) {
                 CGImageRef cgRef = capturedImage.CGImage;
                 capturedImage = [[UIImage alloc] initWithCGImage:cgRef scale:1.0 orientation:UIImageOrientationUp];
             }
             else if (self.interfaceOrientation == UIInterfaceOrientationLandscapeLeft) {
                 CGImageRef cgRef = capturedImage.CGImage;
                 capturedImage = [[UIImage alloc] initWithCGImage:cgRef scale:1.0 orientation:UIImageOrientationDown];
             }
         }
         else if (_myDevice == [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo][1]) {
             // front camera active
             
             // flip to look the same as the camera
             if (UIInterfaceOrientationIsPortrait(self.interfaceOrientation)) capturedImage = [UIImage imageWithCGImage:capturedImage.CGImage scale:capturedImage.scale orientation:UIImageOrientationLeftMirrored];
             else {
                 if (self.interfaceOrientation == UIInterfaceOrientationLandscapeRight)
                     capturedImage = [UIImage imageWithCGImage:capturedImage.CGImage scale:capturedImage.scale orientation:UIImageOrientationDownMirrored];
                 else if (self.interfaceOrientation == UIInterfaceOrientationLandscapeLeft)
                     capturedImage = [UIImage imageWithCGImage:capturedImage.CGImage scale:capturedImage.scale orientation:UIImageOrientationUpMirrored];
             }
             
         }
         
         isCapturingImage = NO;
         _capturedImageV.image = capturedImage;
         imageData = nil;
         
         // If we have disabled the photo preview directly fire the delegate callback, otherwise, show user a preview
         _disablePhotoPreview ? [self photoCaptured] : [self drawControls];
     }];
}ļ


@end
