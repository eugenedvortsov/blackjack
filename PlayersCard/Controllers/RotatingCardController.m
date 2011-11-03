//
//  RotatingCardController.m
//  posse
//
//  Created by Eugene Dvortsov on 7/6/11.
//  Copyright 2011 Apple. All rights reserved.
//

#import "RotatingCardController.h"

@interface RotatingCardController() 
-(void) createAnimationLayers;
-(void)rotateAnimation;
@end 

@implementation RotatingCardController

@synthesize cardBackLayer;
@synthesize cardFrontLayer;
@synthesize doubleSidedCardLayer;


- (id)init 
{
    self = [super init];
    if (self) 
    {
        [self createAnimationLayers];
        [self rotateAnimation];
    }
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc
{
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
}
*/

/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
}
*/

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(void) createAnimationLayers
{
    //CREATE THE LAYERS
    self.doubleSidedCardLayer = [CATransformLayer layer];
    doubleSidedCardLayer.frame = CGRectMake(100,100,30,50);
    doubleSidedCardLayer.position = CGPointMake(115, 125);
    
    self.cardBackLayer = [CALayer layer];
    cardBackLayer.cornerRadius = 10;
    cardBackLayer.frame = doubleSidedCardLayer.frame;
    cardBackLayer.position = CGPointMake(15, 25);
    cardBackLayer.contents = (id)[UIImage imageNamed:@"back-red-150-2.png"].CGImage;
    cardBackLayer.doubleSided = NO;
    
    
    [doubleSidedCardLayer addSublayer:cardBackLayer]; 
    
    self.cardFrontLayer = [CALayer layer];
    cardFrontLayer.cornerRadius = 10;
    cardFrontLayer.frame = doubleSidedCardLayer.frame; 
    cardFrontLayer.position = CGPointMake(15, 25);
    cardFrontLayer.contents = (id)[UIImage imageNamed:@"clubs-9-150.png"].CGImage;
    cardFrontLayer.doubleSided = NO;
    
    //move the z coordinate back by 1 pixel to create 3D illusion  
    cardFrontLayer.transform = CATransform3DMakeRotation(M_PI, 0,-1,0); 
    //cardFrontLayer.transform = CATransform3DMakeTranslation(0.0, 0.0, 10);
    
    [doubleSidedCardLayer addSublayer:cardFrontLayer]; 
    
    [self.view.layer addSublayer:doubleSidedCardLayer];
    
}

-(void)rotateAnimation
{
    //ROTATE THE CARD TO THE FACE
    CABasicAnimation *rotateToFrontAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.y"];      
    rotateToFrontAnimation.toValue = [NSNumber numberWithDouble:-M_PI];
    [rotateToFrontAnimation setDuration:5.0];
    rotateToFrontAnimation.removedOnCompletion = YES;
    
    [self.doubleSidedCardLayer addAnimation:rotateToFrontAnimation forKey:@"dealCardAnimation"];
}



@end
