//
//  Point.h
//  posse
//
//  Created by Eugene Dvortsov on 6/27/11.
//  Copyright 2011 Apple. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface AnimationPoint : NSObject {
    CGFloat x;
    CGFloat y;
}

@property(nonatomic, assign) CGFloat x;
@property(nonatomic, assign) CGFloat y;

@end
