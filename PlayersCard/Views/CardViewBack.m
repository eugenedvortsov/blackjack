//
//  CardViewBack.m
//  PlayersCard
//
//  Created by Eugene Dvortsov on 6/26/11.
//  Copyright 2011 Apple. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "CardViewBack.h"

@implementation CardViewBack

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        //draw the back of the card
        CALayer* cardLayer = [CALayer layer];
        cardLayer.cornerRadius = 10;
        cardLayer.bounds = CGRectMake(0,0,frame.size.width, frame.size.height);
        cardLayer.position = CGPointMake(frame.size.width/2,frame.size.height/2);        
        cardLayer.contents = (id)[UIImage imageNamed:@"back-red-150-2.png"].CGImage;
        [self.layer addSublayer:cardLayer];
    }
    return self;
}

- (void)dealloc
{
    [super dealloc];
}

@end
