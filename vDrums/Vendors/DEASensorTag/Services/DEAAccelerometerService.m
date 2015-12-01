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

#import "DEAAccelerometerService.h"
#import "YMSCBCharacteristic.h"
#import "BBYAccelerometerFilter.h"


double calcAccel(int16_t rawV) {
    double v;
    v = (double)rawV / 16.f; //((float)rawV + 1.0) / (256.0/4.0);
    return v;
}

@interface DEAAccelerometerService ()

@property (nonatomic) double x;
@property (nonatomic) double y;
@property (nonatomic) double z;
@property (nonatomic) NSNumber *period;
@property (nonatomic) double           frequency;

@end


@implementation DEAAccelerometerService {
    NSTimeInterval _lastTimeInterval;
}

- (instancetype)initWithName:(NSString *)oName
                      parent:(YMSCBPeripheral *)pObj
                      baseHi:(int64_t)hi
                      baseLo:(int64_t)lo
               serviceOffset:(int)serviceOffset {
    
    self = [super initWithName:oName
                        parent:pObj
                        baseHi:hi
                        baseLo:lo
                 serviceOffset:serviceOffset];

    if (self) {
        [self addCharacteristic:@"data" withOffset:kSensorTag_ACCELEROMETER_DATA];
        [self addCharacteristic:@"config" withOffset:kSensorTag_ACCELEROMETER_CONFIG];
        [self addCharacteristic:@"period" withOffset:kSensorTag_ACCELEROMETER_PERIOD];
        _lastTimeInterval = 0;

        self.lowpassFilter = [[BBYLowpassFilter alloc] initWithSampleRate:10 cutoffFrequency:4];
        self.highpassFilter = [[BBYHighpassFilter alloc] initWithSampleRate:10 cutoffFrequency:4];
        self.enableLowpassFilter = self.enableHighpassFilter = YES;
    }
    return self;
}


- (void)notifyCharacteristicHandler:(YMSCBCharacteristic *)yc error:(NSError *)error {
    
    if (error) {
        return;
    }
    
    if ([yc.name isEqualToString:@"data"]) {
        
        NSTimeInterval now = [NSDate date].timeIntervalSince1970;
        if (!_lastTimeInterval) {
            _lastTimeInterval = now;
        } else {
            NSTimeInterval delta = now - _lastTimeInterval;
            self.frequency = 1.f / delta;
//            NSLog(@"delta: %f", now - _lastTimeInterval);
            _lastTimeInterval = now;
        }
        
        NSData *data = yc.cbCharacteristic.value;
        char val[data.length];
        [data getBytes:&val length:data.length];
        
        int16_t xx = val[0];
        int16_t yy = val[1];
        int16_t zz = val[2];
        double x = calcAccel(xx);
        double y = calcAccel(yy);
        double z = calcAccel(zz);
        
        if (self.enableLowpassFilter) {
            [self.lowpassFilter addAccelerationX:x y:y z:z];
        }
        if (self.enableHighpassFilter) {
            [self.highpassFilter addAccelerationX:x y:y z:z];
        }

        __weak DEAAccelerometerService *this = self;
        _YMS_PERFORM_ON_MAIN_THREAD(^{
//            [self willChangeValueForKey:@"sensorValues"];
            this.x = x;
            this.y = y;
            this.z = z;
//            [self didChangeValueForKey:@"sensorValues"];
//            double vAccel = sqrt(pow(this.x.doubleValue, 2) + pow(this.y.doubleValue, 2) + pow(this.z.doubleValue, 2));
//            NSLog(@"V: %f", vAccel);
            
            BBYvector rawVector;
            rawVector.x = x;
            rawVector.y = y;
            rawVector.z = z;
            BBYvector lowpassVector;
            lowpassVector.x = self.lowpassFilter.x;
            lowpassVector.y = self.lowpassFilter.y;
            lowpassVector.z = self.lowpassFilter.z;
            BBYvector highpassFilter;
            highpassFilter.x = self.highpassFilter.x;
            highpassFilter.y = self.highpassFilter.y;
            highpassFilter.z = self.highpassFilter.z;
            BBYvectorPacket packet;
            packet.rawVector = rawVector;
            packet.lowpassFilter = lowpassVector;
            packet.highpassFilter = highpassFilter;
            
            [self.delegate accelerometerService:self didUpdate:packet];
            
//            http://www.starlino.com/imu_guide.html
//            http://tom.pycke.be/mav/69/accelerometer-to-attitude
        });
    }
}

- (void)configPeriod:(uint8_t)value {
        
    YMSCBCharacteristic *periodCt = self.characteristicDict[@"period"];
    __weak DEAAccelerometerService *this = self;
    [periodCt writeByte:value withBlock:^(NSError *error) {
        //NSLog(@"Set period to: %x", value);
        if (error) {
            NSLog(@"ERROR: %@", [error localizedDescription]);
            this.period = this.period;
        } else {
            this.period = @(value);
        }
    }];
}

- (void)requestReadPeriod {
    YMSCBCharacteristic *periodCt = self.characteristicDict[@"period"];
    
    __weak DEAAccelerometerService *this = self;
    
    [periodCt readValueWithBlock:^(NSData *data, NSError *error) {
        char val[data.length];
        [data getBytes:&val length:data.length];
        
        int16_t periodValue = val[0];
        
        _YMS_PERFORM_ON_MAIN_THREAD(^{
            this.period = @(periodValue);
        });
    }];
}

- (NSDictionary *)sensorValues
{
    return @{ @"x": @(self.x),
              @"y": @(self.y),
              @"z": @(self.z) };
}

@end
