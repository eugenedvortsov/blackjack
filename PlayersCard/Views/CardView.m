//
//  CardView.m
//  PlayersCard
//
//  Created by Eugene Dvortsov on 6/23/11.
//  Copyright 2011 Apple. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "CardView.h"

@implementation CardView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        //for debug
        self.backgroundColor = [UIColor clearColor];

        //draw the card
        CALayer* cardLayer = [CALayer layer];
        cardLayer.cornerRadius = 10;
        cardLayer.bounds = CGRectMake(0,0,frame.size.width, frame.size.height);
        cardLayer.position = CGPointMake(frame.size.width/2,frame.size.height/2);
        cardLayer.backgroundColor = [UIColor whiteColor].CGColor;
        //black line along the edges
        cardLayer.borderColor = [UIColor blackColor].CGColor;
        cardLayer.borderWidth = 2.0;
        [self.layer addSublayer:cardLayer];
        
        //draw the hert in the middle 
        CAShapeLayer* centerPip = [CardsFactory heartPip];
        centerPip.position =  CGPointMake(cardLayer.position.x,cardLayer.position.y);
        //flip it and scale it by 2x
        CATransform3D transform = CATransform3DMakeScale(0.25, 0.25, 1);
        transform = CATransform3DRotate(transform, M_PI, 0, 0, 1);
        centerPip.transform =transform;
        [cardLayer addSublayer:centerPip];
        
        //draw the hert in the bottom right corner 
        CAShapeLayer* bottomPip = [CardsFactory heartPip];
        bottomPip.position =  CGPointMake(cardLayer.bounds.size.width-11,cardLayer.bounds.size.height-30);
        CATransform3D botomPipTransform = CATransform3DMakeScale(0.125, 0.125, 1);
        bottomPip.transform =botomPipTransform;
        [cardLayer addSublayer:bottomPip];
        
        //draw the hert in the top left corner 
        CAShapeLayer* topPip = [CardsFactory heartPip];
        topPip.position =  CGPointMake(11,30);
        CATransform3D topPipTransform = CATransform3DMakeScale(0.125, 0.125, 1);
        topPipTransform = CATransform3DRotate(topPipTransform, M_PI, 0, 0, 1);
        topPip.transform =topPipTransform;
        [cardLayer addSublayer:topPip];
        
        //draw the "A" at the top left corner 
        CATextLayer *text = [CATextLayer layer];
        text.foregroundColor = [UIColor redColor].CGColor;
        [text setString:@"A"];
        [text setFontSize:16.0];
        [text setFrame:CGRectMake(5,5,15,15)];
        [cardLayer addSublayer:text];
        
        //draw the "A" at the bottom left corner 
        CATextLayer *bottomText = [CATextLayer layer];
        bottomText.foregroundColor = [UIColor redColor].CGColor;
        [bottomText setString:@"A"];
        [bottomText setFontSize:16.0];
        [bottomText setFrame:CGRectMake(cardLayer.bounds.size.width-20,cardLayer.bounds.size.height-20,15,15)];
        CATransform3D bottomTextTransform = CATransform3DIdentity;
        bottomTextTransform = CATransform3DRotate(bottomTextTransform, M_PI, 0, 0, 1);
        bottomText.transform =bottomTextTransform;
        [cardLayer addSublayer:bottomText];
    }
    return self;
}

- (void)dealloc
{
    [super dealloc];
}

@end
