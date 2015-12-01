//
//  BBYDrumstickPosition.m
//  AirDrums
//
//  Created by Ronald Mannak on 5/17/14.
//  Copyright (c) 2014 Ronald Mannak. All rights reserved.
//

#import "BBYDrumstickPosition.h"


// rename drumstickmotion?

static const double vectorMargin = 30.f; // degrees
static const double strokeThreshold = .9f;

@interface BBYDrumstickPosition ()
@property (nonatomic) double vector;
@property (nonatomic) double xAngle;
@property (nonatomic) double yAngle;
@property (nonatomic) double zAngle;
@end

@implementation BBYDrumstickPosition

- (BOOL)isHovering:(BBYvector)vector
{
    // need to factor out gravity
//    double vectorLength = sqrt(vector.x * vector.x + vector.y * vector.y + vector.z * vector.z);
//
//    DLog(@"vectorLength: %f", vectorLength);
    
    return [self vectorForce:vector] < strokeThreshold;
}

- (double)vectorForce:(BBYvector)vector
{
    return sqrt(vector.x * vector.x + vector.y * vector.y + vector.z * vector.z);
}

- (BBYvector) transformVector:(BBYvector) vec{
    BBYvector nVec;
    //This transform function will be helpful to quickly change the mapping if you move the sensor oritation relative to the stick.
    nVec.x = vec.x;
    nVec.y = vec.y;
    nVec.z = vec.z;
    return vec;
}

- (BBYvector)transformFromRightStickToLeftStick:(BBYvector)vector
{
    BBYvector leftVector;
    leftVector.x = -vector.x;
    leftVector.y = vector.y;
    leftVector.z = vector.z;
    return leftVector;
}

// we should refactor this to call the delegate whenever a stroke or hover is detected
- (void)detectPosition:(BBYvectorPacket)vectorPacket isRightSidePeripheral:(BOOL)isRightSide
{
    if (!isRightSide) {
        vectorPacket.highpassFilter = [self transformFromRightStickToLeftStick:vectorPacket.highpassFilter];
        vectorPacket.lowpassFilter = [self transformFromRightStickToLeftStick:vectorPacket.lowpassFilter];
        vectorPacket.rawVector = [self transformFromRightStickToLeftStick:vectorPacket.rawVector];
    }
    
    self.lowpass = [self transformVector:vectorPacket.lowpassFilter];
    self.highpass = [self transformVector:vectorPacket.highpassFilter];
    self.vector = [self vectorForce:vectorPacket.highpassFilter];
    
    double vector = sqrt(pow(self.lowpass.x, 2) + pow(self.lowpass.y, 2) + pow(self.lowpass.z, 2));
    double xAngle = acos(self.lowpass.x / vector) * 180 / M_PI;
    double yAngle = acos(self.lowpass.y / vector) * 180 / M_PI;
    double zAngle = acos(self.lowpass.z / vector) * 180 / M_PI;
    
    self.xAngle = xAngle;
    self.yAngle = yAngle;
    self.zAngle = zAngle;
    
    self.isHoverUpward = false;
    self.isHoverForward = false;
    
    BBYDrumstickMotion motion = BBYDrumstickMotionHover;
    
    if ([self isHovering:self.highpass]) {
        if ([self isHoveringForwardXAngle:xAngle yAngle:yAngle zAngle:zAngle]) {
//            DLog(@"hovering forward");
            self.isHoverForward = true;
            self.previousPosition = BBYDrumstickPositionMapForward;
        } else if ([self isHoveringUpward:xAngle yAngle:yAngle zAngle:zAngle]) {
//            DLog(@"hovering upward");
            self.isHoverUpward = true;
            self.previousPosition = BBYDrumstickPositionMapUpward;
        } else if ([self isHoveringUpwardSideways:xAngle yAngle:yAngle zAngle:zAngle]) {
//            DLog(@"hovering upward sideways");
            self.previousPosition = BBYDrumstickPositionMapUpwardSideways;
        } else if ([self isHoveringDown:self.lowpass]) {
            self.previousPosition = BBYDrumstickPositionMapDown;
//            DLog(@"hovering down");
        } else {
//            DLog(@"hovering unknown position");
//            self.previousPosition = BBYDrumstickPositionMapUnknown;
        }
    } else {
        NSLog(@"HIT");
        motion = BBYDrumstickMotionStroke;
//        NSAssert(self.previousPosition != BBYDrumstickPositionMapUnknown, @"");
//        BBYvector direction = [self vectorForce:<#(BBYvector)#>]
        
        
        // use current force and previous position
        // to do: calculate direction of force
    }
    [self.delegate drumKitPositionDetectedMotion:motion
                                         postion:self.previousPosition
                                           force:self.vector/strokeThreshold
                                       certainty:1.f];

}


- (BOOL)isHoveringUpwardSideways:(double)xAngle yAngle:(double)yAngle zAngle:(double)zAngle
{
    if (xAngle < 90 - vectorMargin || xAngle > 90 + vectorMargin) {
        return NO;
    }
    if (yAngle < 145 - vectorMargin || yAngle > 145 + vectorMargin) {
        return NO;
    }
    if (zAngle < 60 - vectorMargin || zAngle > 60 + vectorMargin) {
        return NO;
    }
    return YES;
}

- (BOOL)isHoveringUpward:(double)xAngle yAngle:(double)yAngle zAngle:(double)zAngle
{
    if (xAngle < 115 - vectorMargin || xAngle > 115 + vectorMargin) {
        return NO;
    }
    if (yAngle < 160 - vectorMargin || yAngle > 145 + vectorMargin) {
        return NO;
    }
    if (zAngle < 90 - vectorMargin || zAngle > 90 + vectorMargin) {
        return NO;
    }
    return YES;
}

- (BOOL)isHoveringForwardXAngle:(double)xAngle yAngle:(double)yAngle zAngle:(double)zAngle
{
    if (xAngle < 150 - vectorMargin || xAngle > 150 + vectorMargin) {
        return NO;
    }
    if (yAngle < 120 - vectorMargin || yAngle > 120 + vectorMargin) {
        return NO;
    }
    if (zAngle < 80 - vectorMargin || zAngle > 80 + vectorMargin) {
        return NO;
    }
    return YES;
}

- (BOOL)isHoveringDown:(BBYvector)vector
{
    return NO;
}

@end
