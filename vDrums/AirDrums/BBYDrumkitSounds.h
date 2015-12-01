//
//  BBYDrumkitSounds.h
//  BeatBoy
//
//  Created by Ronald Mannak on 5/3/14.
//  Copyright (c) 2014 Ronald Mannak. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BBYDrumkit.h"

@import AudioToolbox;

typedef NS_ENUM(NSInteger, BBYDrumKitType) {
    BBYDrumKitTypeDefault,
    BBYDrumKitTypeElectronic,
};

@interface BBYDrumkitSounds : NSObject {
    SystemSoundID _splashCymbalSoundID;
    SystemSoundID _hiHatClosedSoundID;
    SystemSoundID _hiHatOpenSoundID;
    SystemSoundID _footHiHatSoundID;
    SystemSoundID _snareDrumSoundID;
    SystemSoundID _rideCymbalSoundID;
    SystemSoundID _mediumTomSoundID;
    SystemSoundID _floorTomSoundID;
    SystemSoundID _bassDrumSoundID;
    SystemSoundID _cowbellSoundID;
}

+ (instancetype)drumkitWithType:(BBYDrumKitType)type;

- (void)playSoundForPosition:(BBYDrum)drum;

@end

@interface BBYDrumkitSoundsDefault : BBYDrumkitSounds

@end

@interface BBYDrumkitSoundsElectronic : BBYDrumkitSounds

@end

//
@interface BBYDrumkitSoundsRubberDuckie : BBYDrumkitSounds

@end