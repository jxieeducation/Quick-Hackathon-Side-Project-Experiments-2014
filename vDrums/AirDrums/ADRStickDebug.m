

#import "ADRStickDebug.h"
#include <sys/time.h>

@implementation ADRStickDebug

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (double) ADRTime
{
    struct timeval time;
    gettimeofday(&time, NULL);
    double result = (double)(time.tv_sec) + ((double)(time.tv_usec) / 1000000.0);
    return result;
}


- (void)drawRect:(CGRect)rect
{
    float w = [self bounds].size.width;
    float h = [self bounds].size.height;
    float drumRadius  = w/4.0f;
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    //CGContextSetShouldAntialias (context,false);
    //CGContextSetLineWidth(context, 1.5f);

    //clear background
    CGContextSetFillColorWithColor(context, [UIColor blackColor].CGColor);
    CGContextFillRect(context, self.bounds);

    //draw lines
    CGContextSetLineWidth(context, 1.0f);
    CGContextSetStrokeColorWithColor(context, [UIColor blueColor].CGColor);
    
    CGContextMoveToPoint(context, w/2.0f, h/2.0f);
    CGContextAddLineToPoint(context, (w/2.0f)*stick.position.xAngle, (h/2.0f)*stick.position.yAngle);

    CGContextStrokePath(context);

    CGContextSetLineWidth(context, 3.0f);
    CGContextSetStrokeColorWithColor(context, [UIColor redColor].CGColor);

    //top drum
    CGContextBeginPath(context);
    CGContextAddArc(context, w/2.0f, h*.25f, drumRadius, 0, 2*M_PI, 0);
    CGContextStrokePath(context);
    
    if(stick.position.isHoverUpward){
        //draw center "highpass" point
        CGContextBeginPath(context);
        CGContextAddArc(context, w/2.0f, h*.25f, 6, 0, 2*M_PI, 0);
        CGContextStrokePath(context);
    }
    
    //bottom drum
    CGContextBeginPath(context);
    CGContextAddArc(context, w/2.0f + stick.position.highpass.x, h*.75f + stick.position.highpass.z, drumRadius, 0, 2*M_PI, 0);
    CGContextStrokePath(context);
    
    if(stick.position.isHoverForward){
        //draw center "highpass" point
        CGContextBeginPath(context);
        CGContextAddArc(context, w/2.0f + stick.position.highpass.x, h*.75f + stick.position.highpass.z, 6, 0, 2*M_PI, 0);
        CGContextStrokePath(context);
    }
    
    
    
}

-(void) setStick:(BBYPeripheral*)p{
    stick = p;
}


@end
