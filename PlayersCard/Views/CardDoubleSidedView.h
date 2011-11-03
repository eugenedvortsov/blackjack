//
//  CardDoubleSidedView.h
//  PlayersCard
//
//  Created by Eugene Dvortsov on 6/26/11.
//  Copyright 2011 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CardDoubleSidedView : UIView {
    CALayer *doubleSidedCardLayer;
}

@property(nonatomic, retain) CALayer *doubleSidedCardLayer; 

@end
