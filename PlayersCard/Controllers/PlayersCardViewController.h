//
//  PlayersCardViewController.h
//  PlayersCard
//
//  Created by Eugene Dvortsov on 6/23/11.
//  Copyright 2011 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@class CardGame;
@class CardDeck;
@class CardData;

@interface PlayersCardViewController : UIViewController<UIAlertViewDelegate> {

    CardGame *game;
    //visual representation of the deck 
    CardDeck *deck;
    
    CALayer* cardBackLayer;
    CALayer* cardFrontLayer;
    CATransformLayer* doubleSidedCardLayer;
        
    NSMutableArray* playersCardViews; 
    NSMutableArray* dealersCardViews; 

    int currentAnimationIteration;
    
    CardData *lastCard; 
}

@property (nonatomic, retain) CardGame *game; 
@property (nonatomic, retain) CALayer *cardBackLayer; 
@property (nonatomic, retain) CALayer *cardFrontLayer; 
@property (nonatomic, retain) CATransformLayer *doubleSidedCardLayer; 
@property (nonatomic, retain) CardData *lastCard; 

@end
