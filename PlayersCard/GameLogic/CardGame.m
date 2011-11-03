//
//  CardGame.m
//  posse
//
//  Created by Eugene Dvortsov on 6/28/11.
//  Copyright 2011 Apple. All rights reserved.
//

#import "CardGame.h"
#import "DeckData.h"

@interface CardGame ()
-(void)dealCards:(NSMutableArray*)cards fromDeck:(DeckData*)deck;
-(int)getCardsScore:(NSMutableArray *)cards;
@end

@implementation CardGame

@synthesize playersCards;
@synthesize dealersCards;
@synthesize deck;
@synthesize turn;

- (id)init {
    self = [super init];
    if (self) 
    {
        playersCards = [[NSMutableArray alloc] init]; 
        dealersCards = [[NSMutableArray alloc] init]; 
        
        //create the deck and shuffle it 
        deck = [[DeckData alloc] init];
    }
    return self;
}

- (void)dealloc 
{
    [deck release];
    [playersCards release];
    [dealersCards release];
    [super dealloc];
}

//dealer hits on sweet 16 
-(BOOL)dealerNeedsToHit
{
    BOOL ret = false; 
    int score = [self getCardsScore:dealersCards];
    NSLog(@"DEALER SCORE=%d\n", score);
    if(score <= 16)
    {
        ret = true;
    }
    return ret; 
}

-(GAME_PLAYER_STATUS)checkForPlayerBlackJack
{
    GAME_PLAYER_STATUS ret = kPlayerPlaying;
    int playersScore = [self getCardsScore:playersCards];
    if(playersScore == 21)
    {
        ret = kPlayerWon;
    }
    return ret; 
}

-(GAME_PLAYER_STATUS)checkGamePlayerStatus
{
    int playersScore = [self getCardsScore:playersCards];
    int dealersScore = [self getCardsScore:dealersCards];
   
    GAME_PLAYER_STATUS ret = kPlayerPlaying;
    //this gets called after every hit that a player takes 
    if(turn == KPlayersTurn)
    {
        //busted 
        if(playersScore > 21)
        {
            ret = kPlayerLost;
        }
        //won! blackjack 
        else if(playersScore == 21)
        {
            ret = kPlayerWon;
        }
    }
    else 
    {
        if([self dealerNeedsToHit])
        {
            ret = kPlayerPlaying;
        }
        else if(dealersScore > 21)
        {
            ret = kPlayerWon;
        }
        else if(dealersScore == 21)
        {
            ret = kPlayerLost;
        }
        else
        {
            if(dealersScore > playersScore)
            {
                ret = kPlayerLost;
            }
            else if(dealersScore < playersScore)
            {
                ret = kPlayerWon;
            }
            else
            {
                ret = kPlayerDraw; 
            }
        }
    }
    NSLog(@"Dealer score = %d Player Score = %d\n", dealersScore, playersScore);
    return ret; 
}

-(int)getCardsScore:(NSMutableArray *)cards
{
    int score = 0; 
    int aceCount = 0; 
    for(CardData *card in cards)
    {
        if(card.rank > 9)
        {
            score += 10;  
        }
        else 
        {
            if(card.rank == 1)
            {
                aceCount++; 
            }
            score += card.rank;
        }
    }
    
    //highest possible score without busting 
    while(aceCount > 0)
    {
        if(score + 10 < 22)
        {
            score = score + 10; 
        }
        aceCount--; 
    }
    return score; 
}

-(void)startGame
{
    [deck shuffle];
    self.turn = KPlayersTurn;
}

-(void)resetTurn
{
    NSMutableArray *playersCardsArray =  [[NSMutableArray alloc] init];
    NSMutableArray *dealersCardsArray =  [[NSMutableArray alloc] init];

    self.playersCards = playersCardsArray; 
    self.dealersCards = dealersCardsArray; 
    
    [playersCardsArray release];
    [dealersCardsArray release];
    
    self.turn = KPlayersTurn;
}

-(CardData *)dealNextCard
{
    CardData *card = [self.deck dealCard];
    if(turn == KPlayersTurn)
    {
        [playersCards addObject:card];        
    }
    else
    {
        [dealersCards addObject:card];        
    }
    
    //check for empty deck 
    if([self.deck cardCount] == 0)
    {
        DeckData *deckData = [[DeckData alloc] init];
        self.deck = deckData;
        [deckData release];
        
        [deck shuffle];
    }
    return card;
}

-(int)dealersCardsCount
{
    return [dealersCards count];
}

-(int)playersCardsCount
{
    return [playersCards count];
}

-(void)dealFirstFourCards
{
    //deal out the cards 
    [self dealCards:playersCards fromDeck:deck];
    [self dealCards:dealersCards fromDeck:deck];
}

-(void)dealCards:(NSMutableArray*)cards fromDeck:(DeckData*)inDeck
{
    for(int i=0; i<2; i++)
    {
        CardData *card = [inDeck dealCard];
        [cards addObject:card]; 
        NSLog(@"Dealt card=%d\n", card.rank); 
    }
}

-(CardData*)getCard:(int)animationIndex
{
    CardData *card = nil; 
    int count = [playersCards count]; 
    if(animationIndex == 0)
    {
        card = [playersCards objectAtIndex:(count-2)];
    }
    else if(animationIndex == 1)
    {
        card = [dealersCards objectAtIndex:(count-2)];        
    }
    else if(turn == KPlayersTurn && animationIndex > 1)
    {
        //get the last card 
        card = [playersCards lastObject];                
    }
    else
    {
        card = [dealersCards lastObject];                
    }
    return card;
}

@end
