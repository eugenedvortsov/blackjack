//
//  CardDoubleSidedView.m
//  PlayersCard
//
//  Created by Eugene Dvortsov on 6/26/11.
//  Copyright 2011 Apple. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

#import "CardDoubleSidedView.h"


@implementation CardDoubleSidedView

@synthesize doubleSidedCardLayer;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        //draw the back of the card
        doubleSidedCardLayer = [CATransformLayer layer];
        
        CALayer* cardBackLayer = [CALayer layer];
        cardBackLayer.cornerRadius = 10;
        cardBackLayer.bounds = CGRectMake(0,0,frame.size.width, frame.size.height);
        cardBackLayer.position = CGPointMake(frame.size.width,frame.size.height);        
        cardBackLayer.contents = (id)[UIImage imageNamed:@"back-red-150-2.png"].CGImage;
        CATransform3D rotateTransform = CATransform3DMakeTranslation(0.0, 0.0, 2);
        cardBackLayer.transform = rotateTransform; 
        [doubleSidedCardLayer addSublayer:cardBackLayer]; 
        
        CALayer* frontCardLayer = [CALayer layer];
        frontCardLayer.cornerRadius = 10;
        frontCardLayer.bounds = CGRectMake(0,0,frame.size.width, frame.size.height);
        frontCardLayer.position = CGPointMake(frame.size.width,frame.size.height);        
        frontCardLayer.contents = (id)[UIImage imageNamed:@"spades-j-150.png"].CGImage;
        
        //move the z coordinate back by 1 pixel to create 3D illusion  
        rotateTransform = CATransform3DMakeTranslation(0.0, 0.0, 1);
        frontCardLayer.transform = rotateTransform; 
        
        [doubleSidedCardLayer addSublayer:frontCardLayer]; 
        
        [self.layer addSublayer:doubleSidedCardLayer];

    }
    return self;
}

- (void)dealloc
{
    [doubleSidedCardLayer release];
    [super dealloc];
}

@end
