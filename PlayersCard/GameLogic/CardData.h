//
//  CardData.h
//  posse
//
//  Created by Eugene Dvortsov on 6/28/11.
//  Copyright 2011 Apple. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    kSuitClubs,
    kSuitDiamonds,
    kSuitHearts,
    kSuitSpades
} CardSuit;

typedef enum {
    kRankAce = 1,
    kRankJack = 11,
    kRankQueen = 12,
    kRankKing = 13
} CardRank;

@interface CardData : NSObject {
    CardSuit suit;
    CardRank rank; 
}

@property (readonly) CardSuit suit;
@property (readonly) CardRank rank;

-(id)initWithSuitAndRank:(CardSuit)suit rank:(CardRank)inRank;

@end
