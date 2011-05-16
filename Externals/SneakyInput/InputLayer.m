//
//  HelloWorldLayer.m
//  SneakyInput 0.4.0
//
//  Created by Nick Pannuto on 12/3/10.
//  Copyright Sneakyness, llc. 2010. All rights reserved.
//

// Import the interfaces
#import "InputLayer.h"
#import "SneakyJoystick.h"
#import "SneakyJoystickSkinnedJoystickExample.h"
#import "SneakyJoystickSkinnedDPadExample.h"
#import "SneakyButton.h"
#import "SneakyButtonSkinnedBase.h"
#import "ColoredCircleSprite.h"
#import "TetrisDemoLayer.h"


#define TOUCH_OFFSET_BEFORE_MOVE 20.0f


// HelloWorld implementation
@implementation InputLayer


@synthesize touchStartPoint, touchComparePoint, controllerLayer, leftJoystick, rightButton;


#pragma mark Touch Delegate

- (void) onEnterTransitionDidFinish
{
	[[CCTouchDispatcher sharedDispatcher] addTargetedDelegate:self priority:1 swallowsTouches:YES];
}

- (void) onExit
{
	[[CCTouchDispatcher sharedDispatcher] removeDelegate:self];
}

- (BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event
{
	CGPoint location = [[CCDirector sharedDirector] convertToGL:[touch locationInView:[touch view]]];
	self.touchStartPoint = [self convertToNodeSpace:location];
	self.touchComparePoint = self.touchStartPoint;
	NSLog(@"lcoation is %@ and startComparePoint is %@", NSStringFromCGPoint(location), NSStringFromCGPoint(touchStartPoint));
	return YES;
//    return CGRectContainsPoint([self boundingBox], self.touchStartPoint);
}

- (void)ccTouchMoved:(UITouch *)touch withEvent:(UIEvent *)event
{
	CGPoint location = [[CCDirector sharedDirector] convertToGL:[touch locationInView:[touch view]]];
	location = [self convertToNodeSpace:location];

	if ( location.x >= (touchComparePoint.x + TOUCH_OFFSET_BEFORE_MOVE) ) {
		[controllerLayer movePieceRight];
		self.touchComparePoint = location;
	}
	else if ( location.x <= (touchComparePoint.x - TOUCH_OFFSET_BEFORE_MOVE) ) {
		[controllerLayer movePieceLeft];
		self.touchComparePoint = location;
	}
	else if ( location.y <= (touchComparePoint.y - TOUCH_OFFSET_BEFORE_MOVE) ) {
		// TODO: untested
		[controllerLayer dropCurrentPiece];
		self.touchComparePoint = location;
	}
}

- (void)ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event
{
	CGPoint location = [[CCDirector sharedDirector] convertToGL:[touch locationInView:[touch view]]];
	location = [self convertToNodeSpace:location];

	int maxOffset = 10.0f;

	if (location.x > (touchStartPoint.x + maxOffset) || location.x < (touchStartPoint.x - maxOffset) ||
		location.y > (touchStartPoint.y + maxOffset) || location.y < (touchStartPoint.y - maxOffset) ) {
		NSLog(@"lcoation is %@ and touchStartPoint is %@", NSStringFromCGPoint(location), NSStringFromCGPoint(touchStartPoint));
		return;
	}

	if ( location.x > 0 ) {
		[controllerLayer rotatePieceRight];
	}
	else if ( location.x < 0 ) {
		[controllerLayer rotatePieceLeft];
	}
}


#pragma mark - other stuff

+(id) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];

	// 'layer' is an autorelease object.
	InputLayer *layer = [InputLayer node];

	// add layer as a child to scene
	[scene addChild: layer];

	// return the scene
	return scene;
}

// on "init" you need to initialize your instance
-(id) init
{
	// always call "super" init
	// Apple recommends to re-assign "self" with the "super" return value
	if( (self=[super init] )) {
		self.isTouchEnabled = YES;
/*  -- just using standard touches for now... --
		SneakyJoystickSkinnedBase *leftJoy = [[[SneakyJoystickSkinnedBase alloc] init] autorelease];
		leftJoy.position = ccp(100,100);
		leftJoy.backgroundSprite = [ColoredCircleSprite circleWithColor:ccc4(255, 0, 0, 128) radius:64];
		leftJoy.thumbSprite = [ColoredCircleSprite circleWithColor:ccc4(0, 0, 255, 200) radius:32];
		leftJoy.joystick = [[SneakyJoystick alloc] initWithRect:CGRectMake(0,0,128,128)];
		leftJoy.joystick.isDPad = YES;
		leftJoy.joystick.numberOfDirections = 4;
		leftJoystick = [leftJoy.joystick retain];
		[self addChild:leftJoy];

		SneakyButtonSkinnedBase *rightBut = [[[SneakyButtonSkinnedBase alloc] init] autorelease];
		rightBut.position = ccp(448,32);
		rightBut.defaultSprite = [ColoredCircleSprite circleWithColor:ccc4(255, 255, 255, 128) radius:32];
		rightBut.activatedSprite = [ColoredCircleSprite circleWithColor:ccc4(255, 255, 255, 255) radius:32];
		rightBut.pressSprite = [ColoredCircleSprite circleWithColor:ccc4(200, 0, 0, 255) radius:32];
		rightBut.button = [[SneakyButton alloc] initWithRect:CGRectMake(0, 0, 64, 64)];
		rightButton = [rightBut.button retain];
		rightButton.isToggleable = NO;
		[self addChild:rightBut];
*/
		[[CCDirector sharedDirector] setAnimationInterval:1.0f/60.0f];

		//[self schedule:@selector(tick:) interval:1.0f/120.0f];
	}
	return self;
}

// on "dealloc" you need to release all your retained objects
- (void) dealloc
{
	// in case you have something to dealloc, do it in this method
	// in this particular example nothing needs to be released.
	// cocos2d will automatically release all the children (Label)
	
	// don't forget to call "super dealloc"
	[super dealloc];
}
@end
