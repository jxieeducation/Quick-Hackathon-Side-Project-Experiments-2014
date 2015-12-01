
#import <UIKit/UIKit.h>
#import "ADRStickDebug.h"
#import "BBYDrumkit.h"
#import "BBYPeripheral.h"
#import "BBYCentralManager.h"

@interface ADRDebugViewController : UIViewController
@property (weak, nonatomic) IBOutlet ADRStickDebug *stickA;
@property (weak, nonatomic) IBOutlet ADRStickDebug *stickB;

@end
