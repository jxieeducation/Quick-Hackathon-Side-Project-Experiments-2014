//
//  BBYAccelerometerFilter.m
//  BeatBoy
//
//  Created by Ronald Mannak on 4/27/14.
//  Copyright (c) 2014 Ronald Mannak. All rights reserved.
//

#import "BBYAccelerometerFilter.h"

#define kAccelerometerMinStep				0.02
#define kAccelerometerNoiseAttenuation		3.0

double Norm(double x, double y, double z)
{
	return sqrt(x * x + y * y + z * z);
}

double Clamp(double v, double min, double max)
{
	if(v > max)
		return max;
	else if(v < min)
		return min;
	else
		return v;
}

#pragma mark - BBYAccelerometerFilter

@interface BBYAccelerometerFilter ()
@property (nonatomic) double x;
@property (nonatomic) double y;
@property (nonatomic) double z;
@end

@implementation BBYAccelerometerFilter

- (void)addAccelerationX:(double)x y:(double)y z:(double)z
{
    _x = x;
    _y = y;
    _z = z;
}


- (NSString *)name
{
	return @"You should not see this";
}

@end


#pragma mark - BBYLowpassFilter

// See http://en.wikipedia.org/wiki/Low-pass_filter for details low pass filtering
@implementation BBYLowpassFilter

- (id)initWithSampleRate:(double)rate cutoffFrequency:(double)freq
{
	self = [super init];
	if(self != nil)
	{
		double dt = 1.0 / rate;
		double RC = 1.0 / freq;
		filterConstant = dt / (dt + RC);
	}
	return self;
}

- (void)addAccelerationX:(double)x y:(double)y z:(double)z;
{
	double alpha = filterConstant;
	
	if(self.adaptive)
	{
		double d = Clamp(fabs(Norm(self.x, self.y, self.z) - Norm(x, y, z)) / kAccelerometerMinStep - 1.0, 0.0, 1.0);
		alpha = (1.0 - d) * filterConstant / kAccelerometerNoiseAttenuation + d * filterConstant;
	}
	
	self.x = x * alpha + self.x * (1.0 - alpha);
	self.y = y * alpha + self.y * (1.0 - alpha);
	self.z = z * alpha + self.z * (1.0 - alpha);
}

- (NSString *)name
{
	return self.adaptive ? @"Adaptive Lowpass Filter" : @"Lowpass Filter";
}

@end

#pragma mark - BBYHighpassFilter

// See http://en.wikipedia.org/wiki/High-pass_filter for details on high pass filtering
@implementation BBYHighpassFilter

- (id)initWithSampleRate:(double)rate cutoffFrequency:(double)freq
{
	self = [super init];
	if (self != nil)
	{
		double dt = 1.0 / rate;
		double RC = 1.0 / freq;
		filterConstant = RC / (dt + RC);
	}
	return self;
}

- (void)addAccelerationX:(double)x y:(double)y z:(double)z;
{
	double alpha = filterConstant;
	
	if (self.adaptive)
	{
		double d = Clamp(fabs(Norm(self.x, self.y, self.z) - Norm(x, y, z)) / kAccelerometerMinStep - 1.0, 0.0, 1.0);
		alpha = d * filterConstant / kAccelerometerNoiseAttenuation + (1.0 - d) * filterConstant;
	}
	
	self.x = alpha * (self.x + x - lastX);
	self.y = alpha * (self.y + y - lastY);
	self.z = alpha * (self.z + z - lastZ);
	
	lastX = x;
	lastY = y;
	lastZ = z;
}

- (NSString *)name
{
	return self.adaptive ? @"Adaptive Highpass Filter" : @"Highpass Filter";
}

@end