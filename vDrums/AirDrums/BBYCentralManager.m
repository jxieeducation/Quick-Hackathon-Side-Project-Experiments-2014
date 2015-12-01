//
//  BBYCentralManager.m
//  BeatBoy
//
//  Created by Ronald Mannak on 4/18/14.
//  Copyright (c) 2014 Ronald Mannak. All rights reserved.
//

#import "BBYCentralManager.h"
#import "DEASensorTag.h"
#import "YMSCBStoredPeripherals.h"
#import "BBYPeripheral.h"
#import "TISensorTag.h"

static BBYCentralManager *sharedCentralManager;

@implementation BBYCentralManager

+ (BBYCentralManager *)initSharedServiceWithDelegate:(id)delegate {
    if (sharedCentralManager == nil) {
        dispatch_queue_t queue = dispatch_queue_create("com.ronaldmannak.beatboy", 0);
        
        NSArray *nameList = @[@"TI BLE Sensor Tag", @"SensorTag"];
        sharedCentralManager = [[super allocWithZone:NULL] initWithKnownPeripheralNames:nameList
                                                                                  queue:queue
                                                                   useStoredPeripherals:YES
                                                                               delegate:delegate];
    }
    return sharedCentralManager;
    
}

+ (BBYCentralManager *)sharedManager {
    if (sharedCentralManager == nil) {
        [self initSharedServiceWithDelegate:nil];
//        NSLog(@"ERROR: must call initSharedServiceWithDelegate: first.");
    }
    return sharedCentralManager;
}

- (BBYPeripheral *)findPeripheral:(CBPeripheral *)peripheral
{
    return (BBYPeripheral *)[super findPeripheral:peripheral];
}

- (void)startScan {
    /*
     Setting CBCentralManagerScanOptionAllowDuplicatesKey to YES will allow for repeated updates of the RSSI via advertising.
     */
    
    NSDictionary *options = @{ CBCentralManagerScanOptionAllowDuplicatesKey: @YES };
    // NOTE: TI SensorTag firmware does not included services in advertisementData.
    // This prevents usage of serviceUUIDs array to filter on.
    
    /*
     Note that in this implementation, handleFoundPeripheral: is implemented so that it can be used via block callback or as a
     delagate handler method. This is an implementation specific decision to handle discovered and retrieved peripherals identically.
     
     This may not always be the case, where for example information from advertisementData and the RSSI are to be factored in.
     */

    __weak typeof(self) weakSelf = self;
    [self scanForPeripheralsWithServices:nil
                                 options:options
                               withBlock:^(CBPeripheral *peripheral, NSDictionary *advertisementData, NSNumber *RSSI, NSError *error) {
                                   
                                   __strong typeof(self) strongSelf = weakSelf;
                                   if (error) {
                                       NSLog(@"Something bad happened with scanForPeripheralWithServices:options:withBlock:");
                                       return;
                                   }
                                   
                                   NSLog(@"DISCOVERED: %@, %@, %@ db", peripheral, peripheral.name, RSSI);
                                   [strongSelf handleFoundPeripheral:peripheral];
                               }];
}

- (void)handleFoundPeripheral:(CBPeripheral *)peripheral
{
    YMSCBPeripheral *yp = [self findPeripheral:peripheral];
    
    if (yp == nil) {
        for (NSString *pname in self.knownPeripheralNames) {
            if ([pname isEqualToString:peripheral.name]) {
                
                BBYDrumstick *drumstick = (BBYDrumstick *)[BBYPeripheral peripheralWithCBPeripheral:peripheral central:self type:BBYPeripheralTypeDrumstick];
                [self addPeripheral:drumstick];

                break;
            }
        }
    }
}

- (void)managerPoweredOnHandler {
    // TODO: Determine if peripheral retrieval works on stock Macs with BLE support.
    /*
     Using iMac with Cirago BLE USB adapter, retreival with return a CBPeripheral instance without properties
     correctly populated such as name. This behavior is not exhibited when running on iOS.
     */
    
    if (self.useStoredPeripherals) {
#if TARGET_OS_IPHONE
        NSArray *identifiers = [YMSCBStoredPeripherals genIdentifiers];
        [self retrievePeripheralsWithIdentifiers:identifiers];
#endif
    }
}


#pragma mark - CBCentralManagerDelegate

//- (void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral
//{
//    [super centralManager:central didConnectPeripheral:peripheral];
//    
//}


@end
