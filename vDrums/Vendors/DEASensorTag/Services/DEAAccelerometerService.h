// 
// Copyright 2013-2014 Yummy Melon Software LLC
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
//
//  Author: Charles Y. Choi <charles.choi@yummymelon.com>
//

#import "DEABaseService.h"

@class BBYLowpassFilter, BBYHighpassFilter, DEAAccelerometerService;

typedef struct {
    double x;
    double y;
    double z;
} BBYvector;

typedef struct {
    BBYvector rawVector;
    BBYvector lowpassFilter;
    BBYvector highpassFilter;
} BBYvectorPacket;

@protocol DEAAccelerometerServiceProtocol <NSObject>

- (void)accelerometerService:(DEAAccelerometerService *)service
                   didUpdate:(BBYvectorPacket)vectors;
@end

/**
 TI SensorTag CoreBluetooth service definition for accelerometer.
 */
@interface DEAAccelerometerService : DEABaseService

@property (nonatomic, weak) id<DEAAccelerometerServiceProtocol>delegate;

/**
 Inherited property of DEABaseService.
 Keys: @"x", @"y" and @"z".
 */
@property (nonatomic, readonly) NSDictionary *sensorValues;

@property (nonatomic, readonly) double x;
@property (nonatomic, readonly) double y;
@property (nonatomic, readonly) double z;

/// Period
@property (nonatomic, strong, readonly) NSNumber *period;

@property (nonatomic, readonly) double frequency;

@property (strong, nonatomic) BBYLowpassFilter  *lowpassFilter;
@property (strong, nonatomic) BBYHighpassFilter *highpassFilter;
@property (nonatomic) BOOL                      enableLowpassFilter;
@property (nonatomic) BOOL                      enableHighpassFilter;



/**
 Configure accelerometer period.
 
 @param value unsigned byte value to set period
 */
- (void)configPeriod:(uint8_t)value;

/**
 Read accelerometer period.
 */
- (void)requestReadPeriod;

@end
