//
//  PlayersCardAppDelegate.h
//  PlayersCard
//
//  Created by Eugene Dvortsov on 6/23/11.
//  Copyright 2011 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PlayersCardViewController;

@interface PlayersCardAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
    PlayersCardViewController *viewController;
}

@property (nonatomic, retain) UIWindow *window;
@property (nonatomic, retain) PlayersCardViewController *viewController;

@end
