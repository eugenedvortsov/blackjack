//
//  CardOneSidedView.h
//  PlayersCard
//
//  Created by Eugene Dvortsov on 6/26/11.
//  Copyright 2011 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface CardOneSidedView : UIView {
    CALayer* cardLayer;
}

@property (nonatomic, retain) CALayer* cardLayer;

- (void)setImage:(UIImage *)image;

@end
