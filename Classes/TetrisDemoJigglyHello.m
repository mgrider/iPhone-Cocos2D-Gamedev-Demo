//
//  TetrisDemoJigglyHello.m
//  TetrisDemo
//
//  Created by Martin Grider on 3/26/11.
//  Copyright __MyCompanyName__ 2011. All rights reserved.
//


// Import the interfaces
#import "TetrisDemoJigglyHello.h"
#import "TetrisDemoCCMenu.h"

// TetrisDemoLayer implementation
@implementation TetrisDemoJigglyHello

#pragma mark -
#pragma mark nextFrame is called every frame

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
	TetrisDemoJigglyHello *layer = [TetrisDemoJigglyHello node];

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
	if( (self=[super init])) {
		
		// create and initialize a Label
		CCLabelTTF *label = [CCLabelTTF labelWithString:@"Hello World" fontName:@"Marker Felt" fontSize:64];
		[label setTag:1000];

		// ask director the the window size
		CGSize size = [[CCDirector sharedDirector] winSize];
	
		// position the label on the center of the screen
		label.position =  ccp( size.width /2 , size.height/2 );
		
		// add the label as a child to this Layer
		[self addChild: label];

		// schedule a repeating callback on every frame
        [self schedule:@selector(nextFrame:)];

		// a back button
		CCMenuItemLabel *back = [CCMenuItemLabel itemWithLabel:[CCLabelTTF labelWithString:@"back" fontName:@"Helvetica" fontSize:12.0f]
															  target:self selector:@selector(back)];
		CCMenu *backMenu = [CCMenu menuWithItems:back, nil];
		backMenu.position =  ccp( 450, 10 );
		[self addChild:backMenu z:2];
		
	}
	return self;
}

- (void)back
{
	[[CCDirector sharedDirector] replaceScene:
	 [CCTransitionFade transitionWithDuration:0.5 scene:[TetrisDemoCCMenu node]]];
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
