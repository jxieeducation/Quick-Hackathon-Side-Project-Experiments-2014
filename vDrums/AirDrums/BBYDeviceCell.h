//
//  BBYDeviceCell.h
//  BeatBoy
//
//  Created by Ronald Mannak on 4/19/14.
//  Copyright (c) 2014 Ronald Mannak. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BBYPeripheral;

@interface BBYDeviceCell : UICollectionViewCell

@property (nonatomic, weak) BBYPeripheral *peripheral;
@property (weak, nonatomic) IBOutlet UILabel *connectionLabel;


- (void)updateCell;

- (void)addKVO;
- (void)removeKVO;

@end
