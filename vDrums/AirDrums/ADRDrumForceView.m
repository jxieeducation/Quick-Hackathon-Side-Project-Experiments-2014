//
//  ADRDrumForceView.m
//  AirDrums
//
//  Created by Ronald Mannak on 5/18/14.
//  Copyright (c) 2014 Ronald Mannak. All rights reserved.
//

#import "ADRDrumForceView.h"

@interface ADRDrumForceView ()
@property (nonatomic, weak) UIImageView *forceView;
@property (nonatomic, weak) UIImageView *hitForceView;
@end

@implementation ADRDrumForceView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UIImageView *forceView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"DrumForceOrange"]];
        [self addSubview:forceView];
        self.forceView = forceView;
        
        UIImageView *hitForceView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"DrumForce"]];
        [self addSubview:hitForceView];
        self.hitForceView = hitForceView;
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        UIImageView *forceView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"DrumForceOrange"]];
        [self addSubview:forceView];
        self.forceView = forceView;
        
        //        UIImageView *hotForceView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"DrumForce"]];
    }
    return self;
}


- (void)setForce:(double)force
{
//    force = MIN(force, 1.f); <- let's allow green circle= to be bigger than original view
    if (_force == force) { return; }
    
    _force = force;
    UIView *forceView = self.forceView;
    if (force >= 1.f) {
        forceView = self.hitForceView;
        self.forceView.hidden = YES;
        self.hitForceView.hidden = NO;
    } else {
        forceView.hidden = NO;
        self.hitForceView.hidden = YES;
    }
    
    CGFloat boundsWidth = self.bounds.size.width;
    CGFloat boundsHeight = self.bounds.size.height;
    
    CGSize forceSize = CGSizeMake(boundsWidth * force, boundsHeight * force);
    forceView.frame = CGRectMake(0.f, 0.f, forceSize.width, forceSize.height);
    forceView.center = CGPointMake(boundsWidth/2.f, boundsHeight/2.f);
}

@end
