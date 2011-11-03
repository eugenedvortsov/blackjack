//
//  CardOneSidedView.m
//  PlayersCard
//
//  Created by Eugene Dvortsov on 6/26/11.
//  Copyright 2011 Apple. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

#import "CardOneSidedView.h"


@implementation CardOneSidedView

@synthesize cardLayer;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        //draw the back of the card
        //self.backgroundColor = [UIColor redColor]
        self.cardLayer = [CALayer layer];
        self.cardLayer.cornerRadius = 10;
        self.cardLayer.bounds = CGRectMake(0,0,frame.size.width, frame.size.height);
        self.cardLayer.position = CGPointMake(frame.size.width,frame.size.height);        
        //default image
        self.cardLayer.contents = (id)[UIImage imageNamed:@"spades-j-150.png"].CGImage;
        [self.layer addSublayer:self.cardLayer];
    }
    return self;
}

- (void)setImage:(UIImage *)image
{
    self.cardLayer.contents = (id)image.CGImage;
}

- (void)dealloc
{
    [cardLayer release];
    [super dealloc];
}

@end
