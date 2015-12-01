
#import <UIKit/UIKit.h>
#include "BBYDrumstickPosition.h"
#include "BBYPeripheral.h"

@interface ADRStickDebug : UIView{
    BBYPeripheral * stick;
}

-(void) setStick:(BBYPeripheral*)p;

@end
