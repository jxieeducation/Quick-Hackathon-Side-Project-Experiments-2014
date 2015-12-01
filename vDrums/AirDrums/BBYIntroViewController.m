//
//  BBYIntroViewController.m
//  BeatBoy
//
//  Created by Ronald Mannak on 4/18/14.
//  Copyright (c) 2014 Ronald Mannak. All rights reserved.
//

#import "BBYIntroViewController.h"
#import "BBYCentralManager.h"
#import "DEAAccelerometerService.h"
#import "DEAGyroscopeService.h"
#import "BBYPeripheral.h"
#import <math.h>
#import "BBYAccelerometerFilter.h"

#import "BBYDrumkit.h"
#import "BBYDrumkitSounds.h"
#import "ADRDrumForceView.h"
@import AudioToolbox;
/*
 5 piece drum kit
 
 1  2  3  4
 5  6  7  8
 
 1 = Crash Cymbal 1
 2 = Small Tom
 3 = Medium Tom (not in 4 piece set)
 4 = Ride Cymbal
 5 = Hi-hat
 6 = Snare Drum
 7 = Floor Tom
 8 = Crash Cymbal 2
 
 */

static const double vectorMargin = 30.f; // degrees

@interface BBYIntroViewController ()<BBYDrumKitProtocol>

@property (strong, nonatomic) BBYDrumkit *drumkit;

/**
 *  Views
 *
 */

@property (weak, nonatomic) ADRDrumForceView *lastLeftView;
@property (weak, nonatomic) ADRDrumForceView *lastRightView;

// Left stick
@property (weak, nonatomic) IBOutlet ADRDrumForceView *splashCymbal;
@property (weak, nonatomic) IBOutlet ADRDrumForceView *hihat;
@property (weak, nonatomic) IBOutlet ADRDrumForceView *snareDrum;
@property (weak, nonatomic) IBOutlet ADRDrumForceView *bassDrum;

// Right stick
@property (weak, nonatomic) IBOutlet ADRDrumForceView *crashCymbal; // should be ride cymbal??
@property (weak, nonatomic) IBOutlet ADRDrumForceView *bell;
@property (weak, nonatomic) IBOutlet ADRDrumForceView *floorTom;

// All drums
@property (strong, nonatomic) IBOutletCollection(UIView) NSArray *allDrums;

@property (weak, nonatomic) IBOutlet UILabel *xLabel;
@property (weak, nonatomic) IBOutlet UILabel *yLabel;
@property (weak, nonatomic) IBOutlet UILabel *zLabel;

@property (weak, nonatomic) IBOutlet UILabel *rxLabel;
@property (weak, nonatomic) IBOutlet UILabel *ryLabel;
@property (weak, nonatomic) IBOutlet UILabel *rzLabel;
@property (weak, nonatomic) IBOutlet UILabel *VectorLabel;

@property (weak, nonatomic) IBOutlet UILabel *rollLabel;
@property (weak, nonatomic) IBOutlet UILabel *pitchLabel;
@property (weak, nonatomic) IBOutlet UILabel *yawLabel;

@end

@implementation BBYIntroViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // determine which stick is left and right
    
    NSAssert(self.drumSticks.count == 2, @"count not 2");
    
    self.drumkit = [BBYDrumkit drumkitWithSounds:[BBYDrumkitSoundsDefault new]
                                   leftDrumstick:self.drumSticks.firstObject
                                  rightDrumstick:self.drumSticks.lastObject
                                   leftDrumpedal:nil
                                  rightDrumpedal:nil
                                        delegate:self];
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)determineLeftAndRightStick
{
    
}

#pragma mark - BBYDrumKitProtocol 

- (void)drumkit:(BBYDrumkit *)drumkit
     peripheral:(BBYPeripheral *)peripheral
         didHit:(BBYDrum)drum
          force:(double)force
{
    ADRDrumForceView *targetView = [self targetViewForDrum:drum];
    
    for (ADRDrumForceView *forceView in self.allDrums) {
        if (forceView == targetView) {
            targetView.force = force;
        } else {
            targetView.force = 0.f;
        }
    }
}

- (void)drumkit:(BBYDrumkit *)drumkit
     peripheral:(BBYPeripheral *)peripheral
   didHoverOver:(BBYDrum)drum
          force:(double)force
{
    ADRDrumForceView *targetView = [self targetViewForDrum:drum];
    if (peripheral.side == BBYPeripheralSideLeft) {
        self.lastLeftView = targetView;
    } else {
        self.lastRightView = targetView;
    }
    
    for (ADRDrumForceView *forceView in self.allDrums) {
        if (forceView == targetView) {
            forceView.force = force;
            forceView.alpha = .5;
            forceView.backgroundColor = peripheral.side == BBYPeripheralSideRight? [UIColor blueColor] : [UIColor redColor];
        } else {
            if (peripheral.side == BBYPeripheralSideLeft && forceView != self.lastRightView) {
                forceView.alpha = 0.f;
            } else if (peripheral.side == BBYPeripheralSideRight && forceView != self.lastLeftView) {
                forceView.alpha = 0.f;
            }
        }
    }
}

- (ADRDrumForceView *)targetViewForDrum:(BBYDrum)drum
{
    switch (drum) {
        case BBYDrumSplashCymbal:
            NSLog(@"splash");
            return self.splashCymbal;
        case BBYDrumHiHatClosed:
        case BBYDrumHiHatOpen:
        case BBYDrumFootHiHat:
            NSLog(@"hihat");
            return self.hihat;
        case BBYDrumSnareDrum:
            NSLog(@"snare");
            return self.snareDrum;
        case BBYDrumRideCymbal:
            NSLog(@"crash");
            return self.crashCymbal;
        case bbydrumCowBell:
            NSLog(@"cowbell");
            return self.bell;
        case BBYDrumFloorTom:
            NSLog(@"floor");
            return self.floorTom;
        case BBYDrumBassDrum:
            return self.bassDrum;
        default:
//            NSLog(@"targetviewfordrum %li not found", drum);
            return nil;;
    }
}

@end
