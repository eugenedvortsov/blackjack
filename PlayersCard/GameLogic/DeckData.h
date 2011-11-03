//
//  DeckData.h
//  posse
//
//  Created by Eugene Dvortsov on 6/28/11.
//  Copyright 2011 Apple. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CardData.h"

@interface DeckData : NSObject {
    
@private 
    NSMutableArray *cards; 
}

@property (nonatomic, retain) NSMutableArray *cards; 

-(int)cardCount;
-(void)shuffle;
-(CardData*)dealCard;

@end
