//
//  BBYDevicesViewController.m
//  BeatBoy
//
//  Created by Ronald Mannak on 4/19/14.
//  Copyright (c) 2014 Ronald Mannak. All rights reserved.
//

#import "BBYDevicesViewController.h"
#import "BBYDeviceCell.h"
#import "BBYCentralManager.h"
#import "BBYPeripheral.h"
#import "BBYIntroViewController.h"

@interface BBYDevicesViewController ()
@property (weak, nonatomic) IBOutlet UIBarButtonItem *scanButton;

@end

@implementation BBYDevicesViewController

#pragma mark - Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    BBYCentralManager *centralManager = [BBYCentralManager sharedManager];
    centralManager.delegate = self;
    [centralManager addObserver:self
                     forKeyPath:@"isScanning"
                        options:NSKeyValueObservingOptionNew
                        context:NULL];
    
    for (BBYDeviceCell *cell in self.collectionView.visibleCells) {
//        cell.peripheral.delegate = self;
    }
    [self.collectionView reloadData];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    BBYCentralManager *centralManager = [BBYCentralManager sharedManager];
    centralManager.delegate = nil;
    [centralManager stopScan];
    [centralManager removeObserver:self forKeyPath:@"isScanning" context:NULL];
}

#pragma mark - UI

- (IBAction)scanButtonTapped:(UIBarButtonItem *)sender
{
    BBYCentralManager *centralManager = [BBYCentralManager sharedManager];
    
    if (centralManager.isScanning == NO) {
        [centralManager startScan];
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    }
    else {
        [centralManager stopScan];
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        
//        for (DEAPeripheralTableViewCell *cell in [self.peripheralsTableView visibleCells]) {
//            if (cell.yperipheral.cbPeripheral.state == CBPeripheralStateDisconnected) {
//                cell.rssiLabel.text = @"—";
//                cell.peripheralStatusLabel.text = @"QUIESCENT";
//                [cell.peripheralStatusLabel setTextColor:[[DEATheme sharedTheme] bodyTextColor]];
//            }
//        }
        
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // remove KVO from cells
    for (BBYDeviceCell *cell in self.collectionView.visibleCells) {
        [cell removeKVO];
    }
    
    BBYIntroViewController *vc = (BBYIntroViewController *)segue.destinationViewController;
    NSMutableArray *drumsticks = [NSMutableArray arrayWithCapacity:2];
    NSMutableArray *drumpedals = [NSMutableArray arrayWithCapacity:2];
    
    for (NSUInteger i = 0; i < BBYCentralManager.sharedManager.count; i++) {
        BBYPeripheral *peripheral = (BBYPeripheral *)[BBYCentralManager.sharedManager peripheralAtIndex:i];
        if ([peripheral isKindOfClass:[BBYDrumstick class]]) {
            [drumsticks addObject:peripheral];
        } else if ([peripheral isKindOfClass:[BBYDrumpedal class]]) {
            [drumpedals addObject:peripheral];
        }
    }
    vc.drumSticks = drumsticks;
    vc.drumPedals = drumpedals;
}

#pragma mark - KVO

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context
{
    BBYCentralManager *centralManager = [BBYCentralManager sharedManager];
    
    if (object == centralManager) {
        if ([keyPath isEqualToString:@"isScanning"]) {
            if (centralManager.isScanning) {
                self.scanButton.title = @"Stop Scanning";
            } else {
                self.scanButton.title = @"Scan";
            }
        }
    }
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return BBYCentralManager.sharedManager.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    BBYDeviceCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"DeviceCell" forIndexPath:indexPath];
    cell.peripheral = (BBYPeripheral *)[BBYCentralManager.sharedManager peripheralAtIndex:indexPath.row];

    NSAssert(cell, @"cell is nil");
    return cell;
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    BBYDeviceCell *cell = (BBYDeviceCell *)[collectionView cellForItemAtIndexPath:indexPath];
    if (cell.peripheral.isConnected) {
        [cell.peripheral disconnect];
        cell.connectionLabel.text = @"Disconnecting...";
        [cell removeKVO];
    } else {
        [cell.peripheral connect];
        cell.connectionLabel.text = @"Connecting...";
    }
}

#pragma mark - CBCentralManagerDelegate

- (void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral
{
    BBYCentralManager *centralManager = [BBYCentralManager sharedManager];
    BBYPeripheral *beatboyPeripheral = (BBYPeripheral *) [centralManager findPeripheral:peripheral];
//    beatboyPeripheral.delegate = self;

    for (BBYDeviceCell *cell in self.collectionView.visibleCells) {
        if (cell.peripheral == beatboyPeripheral) {
            [cell updateCell];
            [cell addKVO];
            break;
        }
    }
}

- (void)centralManager:(CBCentralManager *)central didDisconnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error
{
    for (BBYDeviceCell *cell in self.collectionView.visibleCells) {
        [cell updateCell];
    }
}

- (void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary *)advertisementData RSSI:(NSNumber *)RSSI
{
    
    BBYCentralManager *centralManager = [BBYCentralManager sharedManager];
    
    YMSCBPeripheral *yp = [centralManager findPeripheral:peripheral];
    if (yp.isRenderedInViewCell == NO) {
        [self.collectionView reloadData];
        yp.isRenderedInViewCell = YES;
    }
    
//    if (centralManager.isScanning) {
//        for (DEAPeripheralTableViewCell *cell in [self.peripheralsTableView visibleCells]) {
//            if (cell.yperipheral.cbPeripheral == peripheral) {
//                if (peripheral.state == CBPeripheralStateDisconnected) {
//                    cell.rssiLabel.text = [NSString stringWithFormat:@"%d", [RSSI integerValue]];
//                    cell.peripheralStatusLabel.text = @"ADVERTISING";
//                    [cell.peripheralStatusLabel setTextColor:[[DEATheme sharedTheme] advertisingColor]];
//                } else {
//                    continue;
//                }
//            }
//        }
//    }
}


- (void)centralManager:(CBCentralManager *)central didRetrievePeripherals:(NSArray *)peripherals
{
    BBYCentralManager *centralManager = [BBYCentralManager sharedManager];
    
    for (CBPeripheral *peripheral in peripherals) {
        YMSCBPeripheral *yp = [centralManager findPeripheral:peripheral];
        if (yp) {
//            yp.delegate = self;
        }
    }
    [self.collectionView reloadData];
}


- (void)centralManager:(CBCentralManager *)central didRetrieveConnectedPeripherals:(NSArray *)peripherals
{
    BBYCentralManager *centralManager = [BBYCentralManager sharedManager];
    
    for (CBPeripheral *peripheral in peripherals) {
        YMSCBPeripheral *yp = [centralManager findPeripheral:peripheral];
        if (yp) {
            yp.delegate = self;
        }
    }
    
    [self.collectionView reloadData];
}

@end
