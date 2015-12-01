//
//  BBYPeripheral.m
//  BeatBoy
//
//  Created by Ronald Mannak on 4/19/14.
//  Copyright (c) 2014 Ronald Mannak. All rights reserved.
//

#import "BBYPeripheral.h"
#import "TISensorTag.h"
#import "DEAAccelerometerService.h"

@interface BBYPeripheral()<DEAAccelerometerServiceProtocol>

@end

@interface BBYDrumstick()<BBYDrumKitPositiondDelegate>
@property (nonatomic, strong) BBYDrumstickPosition *position;
@end


@implementation BBYPeripheral

+ (instancetype)peripheralWithCBPeripheral:(CBPeripheral *)CBperipheral central:(YMSCBCentralManager *)owner type:(BBYPeripheralType)type
{
    BBYPeripheral *peripheral = nil;
    
    switch (type) {
        case BBYPeripheralTypeDrumstick: {
            peripheral = [[BBYDrumstick alloc] initWithCBPeripheral:CBperipheral central:owner type:type];
            ((BBYDrumstick *)peripheral).position = [BBYDrumstickPosition new];
            ((BBYDrumstick *)peripheral).position.delegate = (BBYDrumstick *)peripheral;
            break;
        }
    
        case BBYPeripheralTypeDrumpedal:
            peripheral = [[BBYDrumpedal alloc] initWithCBPeripheral:CBperipheral central:owner type:type];
            break;
            
        case BBYPeripheralTypeGuitarpick:
            peripheral = [[BBYGuitarpick alloc] initWithCBPeripheral:CBperipheral central:owner type:type];
            break;
            
        default:
            peripheral = [[BBYPeripheral alloc] initWithCBPeripheral:CBperipheral central:owner type:type];
            break;
    }
    peripheral.accelerometer.delegate = peripheral;
    return peripheral;
}

- (instancetype)initWithCBPeripheral:(CBPeripheral *)CBperipheral central:(YMSCBCentralManager *)owner type:(BBYPeripheralType)type
{
    self = [super initWithPeripheral:CBperipheral central:owner baseHi:kSensorTag_BASE_ADDRESS_HI baseLo:kSensorTag_BASE_ADDRESS_LO];
    if (self) {
        _type = type;
    }
    return self;
}

- (NSString *)name
{
    switch (self.type) {
        case BBYPeripheralTypeDrumstick:
            return @"Drum Stick";
            break;
            
        case BBYPeripheralTypeDrumpedal:
            return @"Drum Pedal";
            break;
            
        case BBYPeripheralTypeGuitarpick:
            return @"Guitar Pick";
            break;
            
        default:
            return @"Unknown";
            break;
    }
}


#pragma mark - DEAAccelerometerServiceProtocol

- (void)accelerometerService:(DEAAccelerometerService *)service didUpdate:(BBYvectorPacket)vectors
{
    // Implement in subclass
    [self doesNotRecognizeSelector:_cmd];
}

@end

@implementation BBYDrumstick

- (void)accelerometerService:(DEAAccelerometerService *)service didUpdate:(BBYvectorPacket)vectors
{
    NSAssert(self.position, @"no position object set");
    [self.position detectPosition:vectors isRightSidePeripheral:self.side == BBYPeripheralSideRight];
    self.vectors = vectors;
    // wait for position to call drumKitPosistion
}

#pragma mark - BBYDrumKitPositiondDelegate

- (void)drumKitPositionDetectedMotion:(BBYDrumstickMotion)motion postion:(BBYDrumstickPositionMap)position force:(double)force certainty:(double)certainty
{
//    NSLog(@"delegate is nil");
//    NSAssert(self.delegate, @"delegate is nil");
    if (motion == BBYDrumstickMotionHover) {
        // Tell BBYDrumKit object that stick hovers over position
        [self.delegate drumstick:self doesHoverOverPosition:position withForce:force];
    } else if (motion == BBYDrumstickMotionStroke) {
        // Tell BBYDrumKit object that we hit a position
        [self.delegate drumstick:self didStrikePosition:position withForce:force];
    }
}

@synthesize delegate = _delegate;
- (void)setDelegate:(id<BBYDrumstickDelegate>)delegate
{
    NSAssert(delegate, @"trying to set delegate to nil");
    _delegate = delegate;
}

@end

@implementation BBYDrumpedal

- (void)accelerometerService:(DEAAccelerometerService *)service didUpdate:(BBYvectorPacket)vectors
{
    // if static either open or closed, and open/close property is set, do nothing
    // if hit and 
//    DLog(@"update acc vectors from drumpedal");
    
}

@end

@implementation BBYGuitarpick


@end