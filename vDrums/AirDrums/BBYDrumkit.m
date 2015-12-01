//
//  BBYDrumkit.m
//  BeatBoy
//
//  Created by Ronald Mannak on 5/1/14.
//  Copyright (c) 2014 Ronald Mannak. All rights reserved.
//

#import "BBYDrumkit.h"
#import "BBYDrumkitSounds.h"

@interface BBYDrumkit ()<BBYDrumstickDelegate>

@property (nonatomic, strong) BBYDrumkitSounds *sounds;

@property (nonatomic, strong) BBYDrumstick *leftDrumstick;
@property (nonatomic, strong) BBYDrumstick *rightDrumstick;

@property (nonatomic, strong) BBYDrumpedal *leftDrumpedal;
@property (nonatomic, strong) BBYDrumpedal *rightDrumpedal;

@property (nonatomic, weak) id<BBYDrumKitProtocol>delegate;

@end

@implementation BBYDrumkit

+ (instancetype)drumkitWithSounds:(BBYDrumkitSounds *)sounds
                    leftDrumstick:(BBYDrumstick *)leftDrumstick
                   rightDrumstick:(BBYDrumstick *)rightDrumstick
                    leftDrumpedal:(BBYDrumpedal *)leftDrumpedal
                   rightDrumpedal:(BBYDrumpedal *)rightDrumpedal
                         delegate:(id<BBYDrumKitProtocol>)delegate
{
    BBYDrumkit *drumkit = [BBYDrumkit new];
    drumkit.leftDrumstick = leftDrumstick;
    drumkit.rightDrumstick = rightDrumstick;
    drumkit.leftDrumpedal = leftDrumpedal;
    drumkit.rightDrumpedal = rightDrumpedal;
    drumkit.delegate = delegate;
    drumkit.sounds = sounds;
    return drumkit;
}

#pragma mark - BBYDrumstickDelegate

- (void)drumstick:(BBYDrumstick *)drumStick
doesHoverOverPosition:(BBYDrumstickPositionMap)position
        withForce:(double)force
{
    BBYDrum drum = [self positionToDrum:position forDrumstick:drumStick];
    [self.delegate drumkit:self
                peripheral:drumStick
              didHoverOver:drum
                     force:force];
}

- (void)drumstick:(BBYDrumstick *)drumStick
didStrikePosition:(BBYDrumstickPositionMap)position
        withForce:(double)normalizedForce
{
    if ([self canPlaySound]) {
        BBYDrum drum = [self positionToDrum:position forDrumstick:drumStick];
        [self.sounds playSoundForPosition:drum];
        [self.delegate drumkit:self
                    peripheral:drumStick
                        didHit:drum
                         force:normalizedForce];
    }
}

- (BBYDrum)positionToDrum:(BBYDrumstickPositionMap)position
             forDrumstick:(BBYDrumstick *)drumstick
{
    if (drumstick.side == BBYPeripheralSideLeft) {
        switch (position) {
            case BBYDrumstickPositionMapUpward:
                return BBYDrumHiHatClosed;
            case BBYDrumstickPositionMapUpwardSideways:
                return BBYDrumRideCymbal;
            case BBYDrumstickPositionMapForward:
                // check position pedal for open/closed hihat
                return BBYDrumBassDrum;
            case BBYDrumstickPositionMapDown:
                return BBYDrumBassDrum;
            case BBYDrumstickPositionMapUnknown:
            case BBYDrumstickPositionMapNotHoovering:
                return BBYDrumNone;
        }
    } else if (drumstick.side == BBYPeripheralSideRight) {
        switch (position) {
            case BBYDrumstickPositionMapUpward:
                return bbydrumCowBell;
            case BBYDrumstickPositionMapUpwardSideways:
                return BBYDrumSplashCymbal;
            case BBYDrumstickPositionMapForward:
                return BBYDrumSnareDrum;
            case BBYDrumstickPositionMapDown:
                return BBYDrumBassDrum;
            case BBYDrumstickPositionMapUnknown:
            case BBYDrumstickPositionMapNotHoovering:
                return BBYDrumNone;
                
                // drum roll with tom...
        }
    }
    return BBYDrumNone;
}

#pragma mark - Getters and Setters

- (void)setLeftDrumstick:(BBYDrumstick *)leftDrumstick
{
    _leftDrumstick = leftDrumstick;
    leftDrumstick.side = BBYPeripheralSideLeft;
    leftDrumstick.delegate = self;
}

- (void)setRightDrumstick:(BBYDrumstick *)rightDrumstick
{
    _rightDrumstick = rightDrumstick;
    rightDrumstick.side = BBYPeripheralSideRight;
    rightDrumstick.delegate = self;
}

- (void)setLeftDrumpedal:(BBYDrumpedal *)leftDrumpedal
{
    _leftDrumpedal = leftDrumpedal;
    leftDrumpedal.side = BBYPeripheralSideLeft;
//    leftDrumpedal.delegate = self;
}

- (void)setRightDrumpedal:(BBYDrumpedal *)rightDrumpedal
{
    _rightDrumpedal = rightDrumpedal;
    rightDrumpedal.side = BBYPeripheralSideRight;
//    rightDrumpedal.delegate = self;
}

// Returns YES if last played sound was .25 seconds ago or more
// To make sure we only play one sound per hit
// Move to drumkit so we can add double bass drum etc
- (BOOL)canPlaySound
{
    static NSTimeInterval timeInterval = 0;
    NSTimeInterval currentTime = [NSDate date].timeIntervalSince1970;
    if (currentTime - timeInterval < .15f) {
        NSLog(@"canPlaySound returning NO");
        timeInterval = currentTime;
        return NO;
    }
    //    NSLog(@"timeinterval: %f", currentTime - timeInterval);
    timeInterval = currentTime;
    return YES;
}
// drum roll, double bassdrum: we need to store the last time someone hit the drums here

@end
