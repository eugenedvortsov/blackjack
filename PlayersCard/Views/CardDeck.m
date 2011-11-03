//
//  CardDeck.m
//  PlayersCard
//
//  Created by Eugene Dvortsov on 6/26/11.
//  Copyright 2011 Apple. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "CardDeck.h"

@implementation CardDeck

@synthesize subLayer;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        CAReplicatorLayer *replicatorX = [CAReplicatorLayer layer];
        replicatorX.backgroundColor = [[UIColor whiteColor] CGColor];
        replicatorX.bounds = CGRectMake(0, 0, 60, 100); 
        replicatorX.position = CGPointMake(30, 50);
        replicatorX.instanceCount = 16;
        replicatorX.backgroundColor = [UIColor clearColor].CGColor;
        
        CATransform3D finalTransform = CATransform3DMakeScale(.99, .99, 1);
        finalTransform = CATransform3DTranslate(finalTransform,1.0, -3.0, -1);

        [replicatorX setInstanceTransform:finalTransform]; 
        
        subLayer = [CALayer layer]; 
        subLayer.bounds = CGRectMake(0, 0, 33, 53);
        subLayer.position = CGPointMake(16, 27);
        subLayer.backgroundColor = [[UIColor whiteColor] CGColor];
        subLayer.cornerRadius = 5.0; 
        subLayer.contents = (id)[UIImage imageNamed:@"back-red-150-2.png"].CGImage;

        
        [replicatorX addSublayer:subLayer];
        [self.layer addSublayer:replicatorX];
    }
    
    return self;
}

- (void)dealloc
{
    [subLayer release];
    [super dealloc];
}

@end
