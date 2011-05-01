//
//  TetrisDemoLayer.m
//  TetrisDemo
//
//  Created by Martin Grider on 3/26/11.
//  Copyright __MyCompanyName__ 2011. All rights reserved.
//


// Import the interfaces
#import "TetrisDemoLayer.h"


#define LEVEL_LABEL_TAG 1000
#define SCORE_LABEL_TAG 2000


// TetrisDemoLayer implementation
@implementation TetrisDemoLayer

#pragma mark -
#pragma mark work is called every frame

- (void) nextFrame:(ccTime)dt {
	CCLabelTTF *label = (CCLabelTTF*)[self getChildByTag:1000];
	switch (arc4random()%4) {
		case 0:
			label.position = ccp( label.position.x+1, label.position.y );
			break;
		case 1:
			label.position = ccp( label.position.x-1, label.position.y );
			break;
		case 2:
			label.position = ccp( label.position.x, label.position.y+1 );
			break;
		case 3:
			label.position = ccp( label.position.x, label.position.y-1 );
			break;
		default:
			break;
	}
	
	
}


#pragma mark -
#pragma mark default stuff

+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	TetrisDemoLayer *layer = [TetrisDemoLayer node];

	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}

-(void)startGame
{
}

// on "init" you need to initialize your instance
-(id) init
{
	// always call "super" init
	// Apple recommends to re-assign "self" with the "super" return value
	if( (self=[super init])) {

		// ask director the the window size
		CGSize size = [[CCDirector sharedDirector] winSize];

		// create and initialize a Label
		CCLabelTTF *levelLabel = [CCLabelTTF labelWithString:@"Level" fontName:@"Courier" fontSize:14];
		levelLabel.position = ccp( 10, size.height - 20);
		[self addChild:levelLabel];

		// init the game object
		gameModel = [[TetrisDemoGameModel alloc] init];
		[gameModel startNewGame];

		// schedule a repeating callback on every frame
        [self schedule:@selector(nextFrame:)];
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
