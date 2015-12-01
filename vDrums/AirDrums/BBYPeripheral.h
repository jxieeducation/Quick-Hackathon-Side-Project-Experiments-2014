//
//  BBYPeripheral.h
//  BeatBoy
//
//  Created by Ronald Mannak on 4/19/14.
//  Copyright (c) 2014 Ronald Mannak. All rights reserved.
//

#import "DEASensorTag.h"
#import "BBYDrumstickPosition.h"

typedef NS_ENUM(NSInteger, BBYPeripheralType) {
    BBYPeripheralTypeUnknown,
    BBYPeripheralTypeDrumstick,
    BBYPeripheralTypeDrumpedal,
    BBYPeripheralTypeGuitarpick,
};

typedef NS_ENUM(NSInteger, BBYPeripheralSide) {
    BBYPeripheralSideUnknown,
    BBYPeripheralSideLeft,
    BBYPeripheralSideRight,
};

typedef NS_ENUM(NSInteger, BBYDrumpedalPosition) {
    BBYDrumpedalPositionClosed,
    BBYDrumpedalPositionOpen,
};

@interface BBYPeripheral : DEASensorTag

@property (nonatomic, readonly) BBYPeripheralType type;
@property (nonatomic, readonly) NSString *name;
@property (nonatomic) BBYPeripheralSide side;
@property (nonatomic) BBYvectorPacket vectors;
@property (nonatomic) BBYDrumstickPosition* position;
+ (instancetype)peripheralWithCBPeripheral:(CBPeripheral *)CBperipheral central:(YMSCBCentralManager *)owner type:(BBYPeripheralType)type;

@end

@class BBYDrumstick;
@protocol BBYDrumstickDelegate <NSObject>
@required
- (void)drumstick:(BBYDrumstick *)drumStick doesHoverOverPosition:(BBYDrumstickPositionMap)position withForce:(double)force;
- (void)drumstick:(BBYDrumstick *)drumStick didStrikePosition:(BBYDrumstickPositionMap)position
        withForce:(double)normalizedForce; // 0.f to 1.f
@end

@interface BBYDrumstick : BBYPeripheral
@property (nonatomic, weak)id<BBYDrumstickDelegate>delegate;
@end

@interface BBYDrumpedal : BBYPeripheral
@property (nonatomic, readonly) BBYDrumpedalPosition pedalPosition;
@end

@interface BBYGuitarpick : BBYPeripheral

@end


// How to set the accelerometer sampling rate to 100Hz?
// http://www.byteworks.us/Byte_Works/Blog/Entries/2012/10/31_Controlling_the_TI_SensorTag_with_techBASIC.html
// http://processors.wiki.ti.com/index.php/SensorTag_User_Guide#Accelerometer_2
// http://mike.saunby.net/2013/04/raspberry-pi-and-ti-cc2541-sensortag.html
// https://devzone.nordicsemi.com/index.php/what-is-connection-parameters


// http://tom.pycke.be/mav/70/gyroscope-to-roll-pitch-and-yaw