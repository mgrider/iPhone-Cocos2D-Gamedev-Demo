//
//  TetrisDemoCCMenu.m
//  TetrisDemo
//
//  Created by Martin Grider on 5/1/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "TetrisDemoCCMenu.h"
#import "TetrisDemoJigglyHello.h"


@implementation TetrisDemoCCMenu


-(id) init
{
	// always call "super" init
	if( (self=[super init])) {

		// make some CCMenuItems
		CCMenuItemLabel *helloWorld = [CCMenuItemLabel itemWithLabel:[CCLabelTTF labelWithString:@"Jiggly Hello World" fontName:@"Helvetica" fontSize:12.0f]
															  target:self selector:@selector(openHelloWorld)];

		// Make the menu
		CGSize size = [[CCDirector sharedDirector] winSize];
		CCMenu *menu = [CCMenu menuWithItems:helloWorld, nil];
		menu.position =  ccp( size.width /2 , size.height/2 );
		[self addChild:menu z:2];
	}
	return self;
}


- (void)openHelloWorld
{
	[[CCDirector sharedDirector] replaceScene:
	 [CCTransitionFade transitionWithDuration:1 scene:[TetrisDemoJigglyHello node]]];
}


- (void)openParticle1
{
}


#pragma mark -
#pragma mark static scene

+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];

	// 'layer' is an autorelease object.
	TetrisDemoCCMenu *layer = [TetrisDemoCCMenu node];

	// add layer as a child to scene
	[scene addChild:layer];

	// return the scene
	return scene;
}


@end