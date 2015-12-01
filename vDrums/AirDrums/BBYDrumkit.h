//
//  BBYDrumkit.h
//  BeatBoy
//
//  Created by Ronald Mannak on 5/1/14.
//  Copyright (c) 2014 Ronald Mannak. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BBYPeripheral.h"

@class BBYDrumkitSounds;

/*
 Drum position mapping
 
 - Left drumstick:
 Sideways:   Splash cymbal
 Top:        Hi-hat (open/closed)
 Forward:    Snare drum
 Down:       Bass drum
 
 - Right drumstick:
 Sideways:   Ride cymbal
 Top:        Medium tom
 Forward:    Floor tom
 Down:       Bass drum
 */

typedef NS_ENUM(NSInteger, BBYDrum) {
    BBYDrumSplashCymbal,
    BBYDrumHiHatClosed,
    BBYDrumHiHatOpen,
    BBYDrumFootHiHat,
    BBYDrumSnareDrum,
    BBYDrumRideCymbal,
    BBYDrumMediumTom,
    BBYDrumFloorTom,
    BBYDrumBassDrum,
    bbydrumCowBell,
    BBYDrumNone,
};

typedef NS_ENUM(NSInteger, BBYDrumkitPeripheralType) {
    BBYDrumkitPeripheralTypeLeftDrumstick,
    BBYDrumkitPeripheralTypeRightDrumstick,
    BBYDrumkitPeripheralTypeLeftDrumpedal,
    BBYDrumkitPeripheralTypeRightDrumpedal,
};


@class BBYDrumkit;

@protocol BBYDrumKitProtocol <NSObject>
@required
- (void)drumkit:(BBYDrumkit *)drumkit
     peripheral:(BBYPeripheral *)peripheral
         didHit:(BBYDrum)drum
          force:(double)force;

- (void)drumkit:(BBYDrumkit *)drumkit
     peripheral:(BBYPeripheral *)peripheral
         didHoverOver:(BBYDrum)drum
          force:(double)force;
@end

@interface BBYDrumkit : NSObject

@property (nonatomic, strong, readonly) BBYDrumstick *leftDrumstick;
@property (nonatomic, strong, readonly) BBYDrumstick *rightDrumstick;

@property (nonatomic, strong, readonly) BBYDrumpedal *leftDrumpedal;
@property (nonatomic, strong, readonly) BBYDrumpedal *rightDrumpedal;

+ (instancetype)drumkitWithSounds:(BBYDrumkitSounds *)sounds
                    leftDrumstick:(BBYDrumstick *)leftDrumstick
                   rightDrumstick:(BBYDrumstick *)rightDrumstick
                    leftDrumpedal:(BBYDrumpedal *)leftDrumpedal
                   rightDrumpedal:(BBYDrumpedal *)rightDrumpedal
                         delegate:(id<BBYDrumKitProtocol>)delegate;
@end
