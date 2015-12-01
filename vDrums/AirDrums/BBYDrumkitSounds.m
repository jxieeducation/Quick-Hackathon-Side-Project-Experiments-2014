//
//  BBYDrumkitSounds.m
//  BeatBoy
//
//  Created by Ronald Mannak on 5/3/14.
//  Copyright (c) 2014 Ronald Mannak. All rights reserved.
//

#import "BBYDrumkitSounds.h"

@interface BBYDrumkitSounds ()

@end

@implementation BBYDrumkitSounds

+ (instancetype)drumkitWithType:(BBYDrumKitType)type
{
    BBYDrumkitSounds *sounds = nil;
    switch (type) {
        case BBYDrumKitTypeDefault:
            sounds = [[BBYDrumkitSoundsDefault alloc] init];
            break;
        case BBYDrumKitTypeElectronic:
            sounds = [[BBYDrumkitSoundsElectronic alloc] init];
        default:
            break;
    }
    return sounds;
}

- (void)playSoundForPosition:(BBYDrum)drum
{
    switch (drum) {
        case BBYDrumSplashCymbal:
            [self playSound:_splashCymbalSoundID];
            break;
            
        case BBYDrumHiHatClosed:
            [self playSound:_hiHatClosedSoundID];
            break;
            
        case BBYDrumHiHatOpen:
            [self playSound:_hiHatOpenSoundID];
            break;
            
        case BBYDrumFootHiHat:
            [self playSound:_footHiHatSoundID];
            break;
            
        case BBYDrumSnareDrum:
            [self playSound:_snareDrumSoundID];
            break;
            
        case BBYDrumRideCymbal:
            [self playSound:_rideCymbalSoundID];
            break;
            
        case BBYDrumMediumTom:
            [self playSound:_mediumTomSoundID];
            break;
            
        case BBYDrumFloorTom:
            [self playSound:_floorTomSoundID];
            break;
            
        case BBYDrumBassDrum:
            [self playSound:_bassDrumSoundID];
            break;
            
        case bbydrumCowBell:
            [self playSound:_cowbellSoundID];
            
        default:
//            [self playSound:_hiHatClosedSoundID];
            NSLog(@"Unknown drum: %li", (long)drum);
            break;
    }
}

- (void)playSound:(SystemSoundID)systemSoundID
{

    AudioServicesPlaySystemSound(systemSoundID);
}

- (void)createSystemSound:(SystemSoundID *)systemSoundID forFilename:(NSString *)filename
{
    NSString *drumPath = [[NSBundle mainBundle]
                          pathForResource:filename ofType:@"wav"];
    NSURL *drumURL = [NSURL fileURLWithPath:drumPath];
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)drumURL, systemSoundID);
}

@end

@implementation BBYDrumkitSoundsDefault

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self createSystemSound:&_splashCymbalSoundID forFilename:@"crash"];
        [self createSystemSound:&_hiHatClosedSoundID forFilename:@"hihat_closed"];
        [self createSystemSound:&_hiHatOpenSoundID forFilename:@"hihat_open"];
        [self createSystemSound:&_footHiHatSoundID forFilename:@"hihat_closed"];
        [self createSystemSound:&_snareDrumSoundID forFilename:@"snare"];
        [self createSystemSound:&_rideCymbalSoundID forFilename:@"crash"];
        [self createSystemSound:&_mediumTomSoundID forFilename:@"snare"];
        [self createSystemSound:&_floorTomSoundID forFilename:@"snare"];
        [self createSystemSound:&_bassDrumSoundID forFilename:@"bass"];
        [self createSystemSound:&_cowbellSoundID forFilename:@"bell"];
    }
    return self;
}
@end

@implementation BBYDrumkitSoundsElectronic

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self createSystemSound:&_splashCymbalSoundID forFilename:@"crash"];
        [self createSystemSound:&_hiHatClosedSoundID forFilename:@"hihat_closed"];
        [self createSystemSound:&_hiHatOpenSoundID forFilename:@"hihat_open"];
        [self createSystemSound:&_footHiHatSoundID forFilename:@"hihat_closed"];
        [self createSystemSound:&_snareDrumSoundID forFilename:@"snare"];
        [self createSystemSound:&_rideCymbalSoundID forFilename:@"crash"];
        [self createSystemSound:&_mediumTomSoundID forFilename:@"snare"];
        [self createSystemSound:&_floorTomSoundID forFilename:@"snare"];
        [self createSystemSound:&_bassDrumSoundID forFilename:@"bass"];
        [self createSystemSound:&_cowbellSoundID forFilename:@"bell"];
    }
    return self;
}

@end
