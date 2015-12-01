//
//  BBYDeviceCell.m
//  BeatBoy
//
//  Created by Ronald Mannak on 4/19/14.
//  Copyright (c) 2014 Ronald Mannak. All rights reserved.
//

#import "BBYDeviceCell.h"
#import "BBYPeripheral.h"
#import "DEAAccelerometerService.h"
#import "DEAGyroscopeService.h"
#import "BBYAccelerometerFilter.h"

@interface BBYDeviceCell ()
@property (weak, nonatomic) IBOutlet UILabel *typeLabel;
@property (weak, nonatomic) IBOutlet UILabel *accelerometerLabel;
@property (weak, nonatomic) IBOutlet UILabel *gyroscopeLabel;
@property (weak, nonatomic) IBOutlet UILabel *averageUpdateLabel;
@property (weak, nonatomic) IBOutlet UILabel *lowpassFilterLabel;

@end

@implementation BBYDeviceCell

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
//        self.selectedBackgroundView.backgroundColor = [UIColor greenColor];

    }
    return self;
}
//
//- (UIView *)selectedBackgroundView
//{
//    UIView *view = [[UIView alloc] initWithFrame:self.bounds];
//    view.backgroundColor = [UIColor greenColor];
//    return view;
//}


- (void) updateCell
{
    self.typeLabel.text = self.peripheral.name;
    self.connectionLabel.text = self.peripheral.isConnected? @"Connected" : @"Sleeping";
    self.gyroscopeLabel.text = self.peripheral.cbPeripheral.identifier.UUIDString;
}

- (void)setPeripheral:(BBYPeripheral *)peripheral
{
    _peripheral = peripheral;
    [self updateCell];
}

- (void)addKVO
{
    if (!self.peripheral.isConnected) { return; }
    
    for (NSString *key in @[@"x", @"y", @"z", @"isOn", @"isEnabled", @"period"]) {
        [self.peripheral.accelerometer addObserver:self forKeyPath:key options:NSKeyValueObservingOptionNew context:NULL];
    }
}

- (void)removeKVO
{
    self.accelerometerLabel.text = @"accelerometer";
    @try {
        for (NSString *key in @[@"x", @"y", @"z", @"isOn", @"isEnabled", @"period"]) {
            [self.peripheral.accelerometer removeObserver:self forKeyPath:key];
        }
    }
    @catch (NSException *exception) {
        NSLog(@"Exception in %@: %@", self, exception);
    }
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([object isKindOfClass:[DEAAccelerometerService class]]) {
        
        // What are we reading here? is obsverve called for x, y and Z seperately? E.g. one reading is three calls to observe??
        
//        static NSTimeInterval timeInterval = 0;
//        static NSInteger count =
//        NSTimeInterval currentTime = [NSDate date].timeIntervalSince1970;
//        if (!timeInterval) {
//            timeInterval = currentTime;
//            return;
//        }
        
        
        
//        static NSTimeInterval totalTime = 0;
//        static NSInteger count = 0;
//        totalTime += currentTime - timeInterval? : currentTime;
//        NSLog(@"timeinterval for %@: %f (avg %f)", self, currentTime - timeInterval, totalTime / (double)++count);
//        timeInterval = currentTime;
        
        DEAAccelerometerService *accelerometer = (DEAAccelerometerService *)object;
        
        self.accelerometerLabel.text = [NSString stringWithFormat:@"%0.2f, %0.2f, %0.2f, %dms", accelerometer.x, accelerometer.y, accelerometer.z, (int)accelerometer.period.floatValue * 10];
        self.averageUpdateLabel.text = [NSString stringWithFormat:@"%0.2f Hz", accelerometer.frequency];
        self.lowpassFilterLabel.text = [NSString stringWithFormat:@"lp: %0.2f, %0.2f, %0.2f", accelerometer.lowpassFilter.x, accelerometer.lowpassFilter.y, accelerometer.lowpassFilter.z];

        // Apply low pass filter
        
    }
    
//    DEAAccelerometerService *as = (DEAAccelerometerService *)object;
//    
//    if ([keyPath isEqualToString:@"x"]) {
//        self.accelXLabel.text = [NSString stringWithFormat:@"%0.2f", [as.x floatValue]];
//    } else if ([keyPath isEqualToString:@"y"]) {
//        self.accelYLabel.text = [NSString stringWithFormat:@"%0.2f", [as.y floatValue]];
//    } else if ([keyPath isEqualToString:@"z"]) {
//        self.accelZLabel.text = [NSString stringWithFormat:@"%0.2f", [as.z floatValue]];
//    } else if ([keyPath isEqualToString:@"isOn"]) {
//        [self.notifySwitch setOn:as.isOn animated:YES];
//    } else if ([keyPath isEqualToString:@"isEnabled"]) {
//        [self.notifySwitch setEnabled:as.isEnabled];
//        if (as.isEnabled) {
//            self.periodSlider.enabled = as.isEnabled;
//            [as requestReadPeriod];
//        }
//        
//    } else if ([keyPath isEqualToString:@"period"]) {
//        
//        int pvalue = (int)([as.period floatValue] * 10.0);
//        
//        self.periodLabel.text = [NSString stringWithFormat:@"%d ms", pvalue];
//        if (!self.hasReadPeriod) {
//            [self.periodSlider setValue:[as.period floatValue] animated:YES];
//            self.hasReadPeriod = YES;
//        }
//        
//    }
    
}

@end
