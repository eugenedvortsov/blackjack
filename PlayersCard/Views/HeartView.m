//
//  HeartView.m
//  PlayersCard
//
//  Created by Eugene Dvortsov on 6/25/11.
//  Copyright 2011 Apple. All rights reserved.
//

#import "HeartView.h"


@implementation HeartView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    // Drawing code    
    CGContextRef context = UIGraphicsGetCurrentContext();

    CGContextMoveToPoint(context, 0, 21);
    CGContextAddCurveToPoint(context, -16, 49.8, -53.2, 41.0, -49.6, 5.8);
    CGContextAddCurveToPoint(context, -46, -29.4, -9.4, -53.4, 0, -69.8);
    CGContextAddCurveToPoint(context, 9.4, -53.4, 46, -29.4, 49.6, 5.8);
    CGContextAddCurveToPoint(context, 53.2, 41, 16, 49.8, 0, 21);
   
    UIColor *fillColor = [UIColor redColor];

    CGContextClosePath(context);
    CGContextSetFillColorWithColor(context, fillColor.CGColor);
    CGContextFillPath(context);
}


- (void)dealloc
{
    [super dealloc];
}

@end
