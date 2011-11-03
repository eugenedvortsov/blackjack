//
//  DeckData.m
//  posse
//
//  Created by Eugene Dvortsov on 6/28/11.
//  Copyright 2011 Apple. All rights reserved.
//

#import "DeckData.h"
#import "CardData.h"

@interface DeckData ()
-(void)createDeck;
-(void)createSuitCards:(CardSuit)suit;
@end


@implementation DeckData

@synthesize cards;

- (id)init {
    self = [super init];
    if (self) {
        cards = [[NSMutableArray alloc] init];
        [self createDeck];
    }
    return self;
}

- (void)dealloc 
{
    [cards release];
    [super dealloc];
}
-(void)shuffle
{
    int n = cards.count;
    NSMutableArray *shuffled = [NSMutableArray arrayWithCapacity: n];
    for( ; n > 0; n-- ) 
    {
        //seed with system clock
        srandom(time(NULL));
        int i = random() % n;
        CardData *card = [cards objectAtIndex: i];
        [shuffled addObject:card];
        [cards removeObjectAtIndex: i];
    }
    self.cards = shuffled;
}

-(int)cardCount
{
    return [cards count];
}

-(CardData*)dealCard
{
    //NSLog(@"cards in deck=%d\n", [cards count]);
    CardData *card = [[cards lastObject] retain];
    if( card ) {
        [cards removeLastObject];
    }
    return [card autorelease]; 
}


-(void)createDeck
{
    [self createSuitCards:kSuitClubs];
    [self createSuitCards:kSuitSpades];
    [self createSuitCards:kSuitHearts];
    [self createSuitCards:kSuitDiamonds];
    
    
}
        
-(void)createSuitCards:(CardSuit)suit
{
    for(int i=1; i<=kRankKing; i++)
    {
        CardData *card = [[CardData alloc] initWithSuitAndRank:suit rank:i];
        [cards addObject:card];
        [card release];    
    }
}

@end
