//
//  PlayersCardViewController.m
//  PlayersCard
//
//  Created by Eugene Dvortsov on 6/23/11.
//  Copyright 2011 Apple. All rights reserved.
//
#import "AnimationPoint.h"
#import "PlayersCardViewController.h"
#import "CardOneSidedView.h"
#import "CardGame.h"
#import "CardData.h"

#define ANIMATION_DURATION .8
#define CARD_WIDTH 30
#define DESTINATION_PLAYER_Y_COORDINATE 280 
#define DESTINATION_DEALER_Y_COORDINATE 130 

//this is the XCoordinate of where the first card starts
//2 cards, 3 cards, 4 cards, 5 cards 
static const int xCoordinatesStartPoints[] = {165, 139, 113, 87};

@interface PlayersCardViewController() 
- (void)startGame;
- (void)animateCardDeal:(CardData *)card;
- (void)createAnimationLayers:(CardData *)card;
- (void)slideCurrentCardsOver;
- (void)animateAdditionalCardDeal;
- (void)flipDealersSecondCard;
- (void)performNextCardAnimation;
- (void)checkPlayerWonWithBlackJack;
- (void)continueInitialFourCardAnimation;
- (void)advanceDealerGame;
- (void)setDealtCardToFinalPostion;
- (void)setButtonImages:(UIButton*)button;
- (CAAnimationGroup *)dealOneCardAnimation;
- (CABasicAnimation *)rotateAnimation;
- (CABasicAnimation *)growAnimation;
- (CAKeyframeAnimation *)pathAnimation:(CGFloat)destX destY:(CGFloat)destY;
- (NSString*)getImageName:(CardData*)card;
- (GAME_PLAYER_STATUS)checkGameIsOver;
- (BOOL)isAnimating;
@end

@implementation PlayersCardViewController

@synthesize game;
@synthesize cardBackLayer;
@synthesize cardFrontLayer;
@synthesize doubleSidedCardLayer;
@synthesize lastCard;

- (id)init 
{
    self = [super init];
    if (self) 
    {
        currentAnimationIteration = 0;
        playersCardViews = [[NSMutableArray alloc] init];
        dealersCardViews = [[NSMutableArray alloc] init];
        [self startGame];
    }
    return self;
}

- (void)dealloc
{
    [game release];
    [cardFrontLayer release];
    [cardBackLayer release];
    [doubleSidedCardLayer release];
    [playersCardViews release];
    [dealersCardViews release];
    [lastCard release];
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
    //TODO: implement this 
}

#pragma mark - View lifecycle
- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    //TODO: implement this 
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)loadView
{
    UIView *mainView = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    [mainView setBackgroundColor:[UIColor whiteColor]];
    
    UIImageView *tableBackground = [[UIImageView alloc] initWithFrame:CGRectMake(0,0,320,460)];
	[tableBackground setImage:[UIImage imageNamed:@"table.png"]];
	[mainView addSubview:tableBackground];
	[tableBackground release];
    
    //Hit button 
    UIButton *button;
	button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setFrame:CGRectMake(30,400,80,40)];
    [self setButtonImages:button];
    [button setTitle:@"Hit" forState:UIControlStateNormal];	
	[button addTarget:self action:@selector(hitButtonPressed) forControlEvents:UIControlEventTouchUpInside];
	[mainView addSubview:button];
    
    //Stay button 
	button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:@"Stay" forState:UIControlStateNormal];
	[button setFrame:CGRectMake(120,400,80,40)];
    [self setButtonImages:button];
	[button addTarget:self action:@selector(stayButtonPressed) forControlEvents:UIControlEventTouchUpInside];
	[mainView addSubview:button];
    
    //Deal button
	button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:@"Deal" forState:UIControlStateNormal];
	[button setFrame:CGRectMake(210,400,80,40)];
    [self setButtonImages:button];
	[button addTarget:self action:@selector(dealButtonPressed) forControlEvents:UIControlEventTouchUpInside];
	[mainView addSubview:button];
    
    self.view = mainView;
    [mainView release];

}

- (void)setButtonImages:(UIButton*)button
{
    [button setBackgroundImage:[[UIImage imageNamed:@"button.png"] stretchableImageWithLeftCapWidth:5 topCapHeight:0] forState:UIControlStateNormal];
    
    [button setBackgroundImage:[[UIImage imageNamed:@"button_tapped.png"] stretchableImageWithLeftCapWidth:5 topCapHeight:0] forState:UIControlStateHighlighted];
    
}

//handlers for the buttons 
- (void)hitButtonPressed 
{
    if(!self.isAnimating && currentAnimationIteration > 3)
    {
        [self animateAdditionalCardDeal]; 
    }
}

- (void)stayButtonPressed 
{
    if(currentAnimationIteration > 3)
    {
        self.game.turn = kDealersTurn;
        [self flipDealersSecondCard];
        
        //check some game state
        if([game dealerNeedsToHit])
        {
            [self animateAdditionalCardDeal];         
        }
        else
        {
            [self checkGameIsOver];
        }
    }
}

- (void)dealButtonPressed 
{
    //starts the initial deal
    if((currentAnimationIteration == 0) && !self.isAnimating)
    {
        self.lastCard = [game dealNextCard]; 
        [self animateCardDeal:lastCard];    
    }
}

- (void)startGame
{
    game = [[CardGame alloc] init]; 
    [game startGame];
    
}

//move over the cards that are already dealt to make space for a new one from the deck
- (void)slideCurrentCardsOver
{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:1.0];
    [UIView setAnimationDelay:0.0];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
    
    NSMutableArray *cardViewsArray = nil;
    if(game.turn == KPlayersTurn)
    {
        cardViewsArray = playersCardViews;
    }
    else
    {
        cardViewsArray = dealersCardViews;        
    }
    //make space for the new card
    for(UIView *cardView in cardViewsArray)
    {
        CGRect frame = cardView.frame;
        frame.origin.x -= 26;
        cardView.frame = frame;
    }
    
    [UIView commitAnimations];
    
}

- (void)animateAdditionalCardDeal
{
    //make room for the new card 
    [self slideCurrentCardsOver];

    //update the model / game state
    self.lastCard = [game dealNextCard]; 
    
    //create the layers for the flip animation
    [self createAnimationLayers:self.lastCard];
        
    //animate the card deal
    CAAnimationGroup *playerCardOneFlip =  [self dealOneCardAnimation];
    [self.doubleSidedCardLayer addAnimation:playerCardOneFlip forKey:@"dealCardAnimation"];
}

-(BOOL)isAnimating
{
    if([self.doubleSidedCardLayer animationForKey:@"dealCardAnimation"])
    {
        return YES;
    }
    return NO;
}

- (void)flipDealersSecondCard
{
    //remove the backwards card 
    CardOneSidedView *dealersSecondCard = [dealersCardViews lastObject];
    [dealersSecondCard removeFromSuperview];
    
    //reveal it 
    CardOneSidedView * dealersSecondCardFrontView = [[CardOneSidedView alloc] initWithFrame:dealersSecondCard.frame];
    //set the card 
    CardData *cardData = [game getCard:3];
    NSString *cardImageName = [self getImageName:cardData];
    [dealersSecondCardFrontView setImage:[UIImage imageNamed:cardImageName]];
    [self.view addSubview:dealersSecondCardFrontView];
    
    //remove the downward facing card card 
    [dealersCardViews removeLastObject];
    //add the upward facing card (its the same card)
    [dealersCardViews addObject:dealersSecondCardFrontView];
    
    [dealersSecondCardFrontView release];
}

//displays an alert after each hand 
- (void)displayHandOverAlert:(GAME_PLAYER_STATUS)status
{
    NSString *alertTitle = nil;
    NSString *alertMessage = nil; 
    if(status == kPlayerWon)
    {
        alertTitle = [NSString stringWithString:@"NICE WORK"];
        alertMessage = [NSString stringWithString:@"YOU WON 1 million dollars!"];    
    }
    else if(status == kPlayerLost)
    {
        alertTitle = [NSString stringWithString:@"NICE TRY"]; 
        alertMessage = [NSString stringWithString:@"YOU LOOSE"];
    }
    else if(status == kPlayerDraw)
    {
        alertTitle = [NSString stringWithString:@"BETTER LUCK NEXT TIME"];
        alertMessage = [NSString stringWithString:@"ITS A DRAW"];        
    }
    
    if(status != kPlayerPlaying)
    {
        //NSLog(@"TITLE = %@ MESSAGE = %@\n", alertTitle, alertMessage);
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:alertTitle
                                                    message:alertMessage
                                                   delegate:self
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil, nil];
        [alert show];
        [alert release];
    }
}

- (GAME_PLAYER_STATUS)checkGameIsOver
{    
    GAME_PLAYER_STATUS status = [game checkGamePlayerStatus];
    [self displayHandOverAlert:status];
    
    return status;
}

//creates the double sided card layer for the animation
- (void)createAnimationLayers:(CardData *)cardData
{
    self.doubleSidedCardLayer = [CATransformLayer layer];
    doubleSidedCardLayer.bounds = CGRectMake(0,0, 30,50);
    doubleSidedCardLayer.position = CGPointMake(250, 50);
    doubleSidedCardLayer.transform = CATransform3DMakeTranslation(0, 0, 20); 

    //back of the card 
    self.cardBackLayer = [CALayer layer];
    cardBackLayer.bounds = doubleSidedCardLayer.bounds;
    cardBackLayer.position = CGPointMake(30, 50);
    cardBackLayer.cornerRadius = 10;
    cardBackLayer.contents = (id)[UIImage imageNamed:@"back-red-150-2.png"].CGImage;
    cardBackLayer.doubleSided = NO;
    [doubleSidedCardLayer addSublayer:cardBackLayer]; 
    
    //front of the card 
    self.cardFrontLayer = [CALayer layer];
    cardFrontLayer.bounds = doubleSidedCardLayer.bounds;
    cardFrontLayer.position = CGPointMake(30, 50);
    cardFrontLayer.cornerRadius = 10;
    NSString *cardImageName = [self getImageName:cardData];
    cardFrontLayer.contents = (id)[UIImage imageNamed:cardImageName].CGImage;
    cardFrontLayer.doubleSided = NO;
    CATransform3D rotate = CATransform3DMakeRotation(M_PI, 0,-1,0); 
    cardFrontLayer.transform = rotate;
    [doubleSidedCardLayer addSublayer:cardFrontLayer]; 
    
    [self.view.layer addSublayer:doubleSidedCardLayer];
}

//animates the card getting dealt from the deck along a path
- (CAKeyframeAnimation *)pathAnimation:(CGFloat)destX destY:(CGFloat)destY
{    
    CAKeyframeAnimation *pathAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
	pathAnimation.calculationMode = kCAAnimationPaced;
    pathAnimation.duration = ANIMATION_DURATION;
	//set the path - 2 points 
    CGMutablePathRef curvedPath = CGPathCreateMutable();
	CGPathMoveToPoint(curvedPath, NULL, 260, 20);
	CGPathAddQuadCurveToPoint(curvedPath, NULL, 10, 250, destX, destY);
	//set it
    pathAnimation.path = curvedPath;
	CGPathRelease(curvedPath);
    
    return pathAnimation;
    
}

//enlarges the card 
- (CABasicAnimation *)growAnimation
{
    //ANIMATE SIZE - The card getting bigger 
    CABasicAnimation *growAnimation=[CABasicAnimation animationWithKeyPath:@"transform.scale"];
    growAnimation.duration=ANIMATION_DURATION;
    growAnimation.autoreverses=NO;
    growAnimation.fromValue=[NSNumber numberWithFloat:1];
    growAnimation.toValue=[NSNumber numberWithFloat:2];
    
    return growAnimation;
}

//flips the card layer about the y axis
- (CABasicAnimation *)rotateAnimation
{
    //ROTATE THE CARD TO THE FACE
    CABasicAnimation *rotateToFrontAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.y"];      
    rotateToFrontAnimation.toValue = [NSNumber numberWithDouble:-M_PI];
    [rotateToFrontAnimation setDuration:ANIMATION_DURATION];
    
    return rotateToFrontAnimation;
}
  
-(AnimationPoint *)animationPoint 
{
    int cardsCount = 0; 
    int destX = 0;
    int destXOffset = 0;
    int destY = 0; 
    if(game.turn == KPlayersTurn)
    {
        cardsCount = [game playersCardsCount];
        destY = DESTINATION_PLAYER_Y_COORDINATE;
    }
    else
    {
        cardsCount = [game dealersCardsCount];
        //for dealers second card since its not flipped 
        if(cardsCount == 2)
        {
            destXOffset -=60;
        }
        destY = DESTINATION_DEALER_Y_COORDINATE;
    }
    
    destXOffset += (cardsCount - 1) * 50;
    //HACK this is for the first two cards 
    if(cardsCount < 2)
    {
        cardsCount = 2; 
    }
    destX = xCoordinatesStartPoints[cardsCount-2];
    destX += destXOffset;
    

    AnimationPoint *point = [[AnimationPoint alloc] init];
    point.x = destX;
    point.y = destY;
    
    return [point autorelease];
}

- (CAAnimationGroup *)dealOneCardAnimation
{
    AnimationPoint *destination = self.animationPoint; 
    
    CAAnimationGroup *animationGroup = [CAAnimationGroup animation];
    CAKeyframeAnimation *pathAnimation = [self pathAnimation:destination.x destY:destination.y];
    
    if(currentAnimationIteration == 3)
    {
        //the last dealer card is face down, so no rotate animation
        animationGroup.animations = [NSArray arrayWithObjects:pathAnimation, self.growAnimation, nil];
    }
    else
    {
        animationGroup.animations = [NSArray arrayWithObjects:pathAnimation, self.growAnimation, self.rotateAnimation, nil];
    }
    animationGroup.duration = ANIMATION_DURATION;
    animationGroup.delegate = self;
    // Hold the view in the state reached by the animation until we can fix it, or else we get an annoying flicker
    animationGroup.fillMode = kCAFillModeForwards;
    animationGroup.removedOnCompletion = NO;
    
    return animationGroup;
}

- (void)animateCardDeal:(CardData *)card
{
    if(currentAnimationIteration < 4)
    {
        [self createAnimationLayers:card];
        CAAnimationGroup *playerCardOneFlip =  [self dealOneCardAnimation];
        [self.doubleSidedCardLayer addAnimation:playerCardOneFlip forKey:@"dealCardAnimation"];
    }
}

-(void)cleanupAnimationLayers
{
    [cardBackLayer removeFromSuperlayer];
	[cardFrontLayer removeFromSuperlayer];
	[doubleSidedCardLayer removeFromSuperlayer];
	
    self.cardBackLayer = nil;
	self.cardFrontLayer = nil;
	self.doubleSidedCardLayer = nil;     
}

-(void)clearCardsOnTable
{
    //cleanup the cards 
    for(UIView *view in playersCardViews)
    {
        [view removeFromSuperview];
    }
    for(UIView *view in dealersCardViews)
    {
        [view removeFromSuperview];
    }
    [playersCardViews removeAllObjects];
    [dealersCardViews removeAllObjects];
}

//returns the name of the png with the card on it 
-(NSString*)getImageName:(CardData*)card
{
    NSMutableString *name = [[NSMutableString alloc] init];
    switch(card.suit)
    {
        case kSuitClubs:
            [name appendString:@"clubs-"];
            break;
        case kSuitDiamonds:
            [name appendString:@"diamonds-"];
            break;
        case kSuitHearts:
            [name appendString:@"hearts-"];
            break;
        case kSuitSpades:
            [name appendString:@"spades-"];
            break;
        default:
            //do nothing 
            break; 
            
    }
    
    //numbered card
    if(card.rank > 1 && card.rank < 11)
    {
        [name appendString:[NSString stringWithFormat: @"%d-150.png", card.rank]];
    }
    else
    {
        switch(card.rank)
        {
            case kRankAce:
                [name appendString:@"a-150.png"];
                break;
            case kRankKing:
                [name appendString:@"k-150.png"];
                break;
            case kRankQueen:
                [name appendString:@"q-150.png"];
                break;
            case kRankJack:
                [name appendString:@"j-150.png"];
                break;
            default:
                //do nothing 
                break; 
        }
    }
    return [name autorelease];;
}

#pragma mark UIAlertViewDelegate 
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex;
{
    [self clearCardsOnTable];
   
    //deal the new set 
    currentAnimationIteration = 0; 
    //update the model with 4 new cards
    [game resetTurn];
    
    //deal the next card 
    self.lastCard = [game dealNextCard]; 
    [self animateCardDeal:lastCard];
}

#pragma mark NSObject (CAAnimationDelegate)
- (void)animationDidStop:(CAAnimation *)animation finished:(BOOL)flag;
{
    // This delegate method allows us to clean up our state
    if (![animation isKindOfClass:[CAAnimationGroup class]])
        return;
    
    //get rid of the double sided layers used for the animation to save space 
    [self cleanupAnimationLayers];
    
    //create the one sided card layer in its final position 
    [self setDealtCardToFinalPostion];
      
    //perform the next animation
    [self performNextCardAnimation];
    
}

-(void)setDealtCardToFinalPostion
{
    CardOneSidedView *dealtCard = nil;    
    AnimationPoint *destinationPoint = self.animationPoint;
    if(currentAnimationIteration == 3)
    {
        dealtCard = [[CardOneSidedView alloc] initWithFrame:CGRectMake(destinationPoint.x-30,destinationPoint.y-50, 60,100)];
    }
    else
    {
        dealtCard = [[CardOneSidedView alloc] initWithFrame:CGRectMake(destinationPoint.x-90,destinationPoint.y-50, 60,100)];
    }
    
    //set the card 
    NSString *cardImageName = [self getImageName:lastCard];
    [dealtCard setImage:[UIImage imageNamed:cardImageName]];
    if(currentAnimationIteration == 3)
    {
        [dealtCard setImage:[UIImage imageNamed:@"back-red-150-2.png"]];
    }
    
    [self.view addSubview:dealtCard];
    
    if([game turn] == KPlayersTurn)
    {
        [playersCardViews addObject:dealtCard];
    }
    else
    {
        [dealersCardViews addObject:dealtCard];
    }
    [dealtCard release];    
}

-(void)performNextCardAnimation
{
    currentAnimationIteration++;   
    if(currentAnimationIteration == 4)
    {
        [self checkPlayerWonWithBlackJack];        
    }
    else if(currentAnimationIteration > 3)
    {
        [self advanceDealerGame];
    }
    else
    {
        //for the first 4 cards that get deal automatically 
        [self continueInitialFourCardAnimation];
    }    
}

-(void)checkPlayerWonWithBlackJack
{
    game.turn = KPlayersTurn;
    //check if player has 21 
    GAME_PLAYER_STATUS status = [game checkForPlayerBlackJack];
    if(status == kPlayerWon)
    {
        [self flipDealersSecondCard];
        [self displayHandOverAlert:status];
    }    
}

-(void)continueInitialFourCardAnimation
{
    if(game.turn == KPlayersTurn)
    {
        game.turn = kDealersTurn;
    }
    else
    {
        game.turn = KPlayersTurn;
    }
    self.lastCard = [game dealNextCard]; 
    [self animateCardDeal:lastCard];    
}

//deals more cards to the dealer 
-(void)advanceDealerGame
{
    GAME_PLAYER_STATUS status = [self checkGameIsOver];
    if(status == kPlayerPlaying) 
    {
        if(game.turn == KPlayersTurn)
        {
            //only allow player 5 cards 
            if([game playersCardsCount] == 5)
            {
                game.turn = kDealersTurn;
            }
        }
        else if(game.turn == kDealersTurn )
        {
            //check some game state
            if([game dealerNeedsToHit])
            {
                [self animateAdditionalCardDeal];         
            }
        }
    }
}

@end
