//
//  BBYAccelerometerFilter.h
//  BeatBoy
//
//  Created by Ronald Mannak on 4/27/14.
//  Copyright (c) 2014 Ronald Mannak. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BBYAccelerometerFilter : NSObject

// Add a UIAcceleration to the filter.
- (void)addAccelerationX:(double)x y:(double)y z:(double)z;

@property (nonatomic, readonly) double x;
@property (nonatomic, readonly) double y;
@property (nonatomic, readonly) double z;

@property (nonatomic, getter=isAdaptive) BOOL adaptive;
@property (unsafe_unretained, nonatomic, readonly) NSString *name;

@end

// A filter class to represent a lowpass filter
@interface BBYLowpassFilter : BBYAccelerometerFilter
{
	double filterConstant;
	double lastX, lastY, lastZ;
}

// Rate in Hz
- (id)initWithSampleRate:(double)rate cutoffFrequency:(double)freq;

@end

// A filter class to represent a highpass filter.
@interface BBYHighpassFilter : BBYAccelerometerFilter
{
	double filterConstant;
	double lastX, lastY, lastZ;
}

- (id)initWithSampleRate:(double)rate cutoffFrequency:(double)freq;

@end