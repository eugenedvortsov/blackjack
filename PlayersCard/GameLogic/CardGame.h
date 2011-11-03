//
//  CardGame.h
//  posse
//
//  Created by Eugene Dvortsov on 6/28/11.
//  Copyright 2011 Apple. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    KPlayersTurn,
    kDealersTurn
} GAME_TURN;

typedef enum {
    kPlayerWon,
    kPlayerLost,
    kPlayerDraw, 
    kPlayerPlaying
} GAME_PLAYER_STATUS;

@class CardData;
@class DeckData;

@interface CardGame : NSObject {

@private
    //for simplicity, just one player 
    NSMutableArray *playersCards; 
    NSMutableArray *dealersCards; 
    DeckData *deck;
    GAME_TURN turn; 
}

@property (nonatomic, retain) NSMutableArray *playersCards;
@property (nonatomic, retain) NSMutableArray *dealersCards;
@property (nonatomic, retain) DeckData *deck;
@property (nonatomic, assign) GAME_TURN turn;

-(void)startGame;
-(void)dealFirstFourCards;
-(void)resetTurn;
-(int)dealersCardsCount;
-(int)playersCardsCount;
-(BOOL)dealerNeedsToHit;
-(CardData *)dealNextCard;
-(CardData*)getCard:(int)animationIndex;
-(GAME_PLAYER_STATUS)checkGamePlayerStatus;
-(GAME_PLAYER_STATUS)checkForPlayerBlackJack;

@end
