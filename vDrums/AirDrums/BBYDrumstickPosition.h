//
//  BBYDrumstickPosition.h
//  AirDrums
//
//  Created by Ronald Mannak on 5/17/14.
//  Copyright (c) 2014 Ronald Mannak. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DEAAccelerometerService.h"

typedef NS_ENUM(NSInteger, BBYDrumstickPositionMap) {
    BBYDrumstickPositionMapUnknown,
    BBYDrumstickPositionMapForward,    // horizontal
    BBYDrumstickPositionMapUpwardSideways,   // vertical and sideways
    BBYDrumstickPositionMapUpward,         // vertical
    BBYDrumstickPositionMapDown,       // horizontal downward (to play bass drum w/o pedals)
    BBYDrumstickPositionMapNotHoovering,
};

typedef NS_ENUM(NSInteger, BBYDrumstickMotion) {
    BBYDrumstickMotionHover,
    BBYDrumstickMotionStroke,
    BBYDrumstickMotionSpecialMove,
};

typedef NS_ENUM(NSInteger, BBYDrumstickState) {
    BBYDrumstickStateUnknown, //...
};


@protocol BBYDrumKitPositiondDelegate <NSObject>
@required
- (void)drumKitPositionDetectedMotion:(BBYDrumstickMotion)motion
                              postion:(BBYDrumstickPositionMap)position
                                force:(double)force // 0.f to 1.f
                            certainty:(double)certainty;
@end

@interface BBYDrumstickPosition : NSObject

@property (nonatomic, readonly) double xAngle;
@property (nonatomic, readonly) double yAngle;
@property (nonatomic, readonly) double zAngle;
@property (nonatomic) BBYvector lowpass;
@property (nonatomic) BBYvector highpass;
@property (nonatomic) BOOL isHoverForward;
@property (nonatomic) BOOL isHoverUpward;
@property (nonatomic) BBYDrumstickPositionMap previousPosition;
@property (nonatomic, weak) id<BBYDrumKitPositiondDelegate>delegate;

- (BOOL)isHovering:(BBYvector)vector;

- (void)detectPosition:(BBYvectorPacket)vectorPacket isRightSidePeripheral:(BOOL)isRightSide;


@end
