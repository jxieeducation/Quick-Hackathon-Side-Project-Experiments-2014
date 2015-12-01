//
//  BBYCentralManager.h
//  BeatBoy
//
//  Created by Ronald Mannak on 4/18/14.
//  Copyright (c) 2014 Ronald Mannak. All rights reserved.
//

#import "YMSCBCentralManager.h"

@interface BBYCentralManager : YMSCBCentralManager

/**
 Return singleton instance.
 @param delegate UI delegate.
 */
+ (BBYCentralManager *)initSharedServiceWithDelegate:(id)delegate;

/**
 Return singleton instance.
 */

+ (BBYCentralManager *)sharedManager;


@end

// http://chris.cm/determine-whether-bluetooth-is-enabled-on-ios-passively/