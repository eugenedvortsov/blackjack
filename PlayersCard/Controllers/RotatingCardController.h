//
//  RotatingCardController.h
//  posse
//
//  Created by Eugene Dvortsov on 7/6/11.
//  Copyright 2011 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface RotatingCardController : UIViewController {
    CALayer* cardBackLayer;
    CALayer* cardFrontLayer;
    CATransformLayer* doubleSidedCardLayer;
}

@property (nonatomic, retain) CALayer *cardBackLayer; 
@property (nonatomic, retain) CALayer *cardFrontLayer; 
@property (nonatomic, retain) CALayer *doubleSidedCardLayer; 

@end
