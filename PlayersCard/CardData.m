//
//  CardData.m
//  posse
//
//  Created by Eugene Dvortsov on 6/28/11.
//  Copyright 2011 Apple. All rights reserved.
//

#import "CardData.h"


@implementation CardData

@synthesize suit, rank;

-(id)initWithSuitAndRank:(CardSuit)inSuit rank:(CardRank)inRank;
{
    if((self = [super init]))
    {
        suit = inSuit;
        rank = inRank;
    }
    return self; 
}

@end
