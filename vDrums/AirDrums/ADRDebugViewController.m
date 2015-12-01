

#import "ADRDebugViewController.h"

@interface ADRDebugViewController ()<BBYDrumstickDelegate>
@property (strong, nonatomic) IBOutlet ADRStickDebug *view;

@end

@implementation ADRDebugViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    
}

- (void)viewDidAppear:(BOOL)animated
{
    if(BBYCentralManager.sharedManager.count >= 1){
        BBYDrumstick * peripheralA = (BBYDrumstick *)[BBYCentralManager.sharedManager peripheralAtIndex:0];
        peripheralA.delegate = self;
        [_stickA setStick:peripheralA];
        
        if(BBYCentralManager.sharedManager.count >= 2){
            BBYDrumstick * peripheralB = (BBYDrumstick *)[BBYCentralManager.sharedManager peripheralAtIndex:1];
            peripheralB.delegate = self;
            [_stickB setStick:peripheralB];
            
        }
        NSLog(@"Setup stick(s) in debug view.");
    } else {
        NSLog(@"Failed to setup sticks in debug view - no sticks!");
    }
}

- (void)updateDisplay
{
    [[self stickB] performSelectorOnMainThread:@selector(setNeedsDisplay) withObject:0 waitUntilDone:NO];
    [[self stickA] performSelectorOnMainThread:@selector(setNeedsDisplay) withObject:0 waitUntilDone:NO];
}

#pragma mark - BBYDrumkitDelegate

- (void)drumstick:(BBYDrumstick *)drumStick
didStrikePosition:(BBYDrumstickPositionMap)position
{
    [self updateDisplay];
}

- (void)drumstick:(BBYDrumstick *)drumStick doesHoverOverPosition:(BBYDrumstickPositionMap)position
{
    [self updateDisplay];
}

@end
