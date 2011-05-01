//
//  TetrisDemoCCMenu.m
//  TetrisDemo
//
//  Created by Martin Grider on 5/1/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "TetrisDemoCCMenu.h"
#import "JigglyHelloWorldLayer.h"


@implementation TetrisDemoCCMenu


-(id) init
{
	// always call "super" init
	if( (self=[super init])) {
		// make some CCMenuItems
		CCMenuItemLabel *helloWorld = [CCMenuItemLabel itemWithLabel:[CCLabelTTF labelWithString:@"Jiggly Hello World" fontName:@"Helvetica" fontSize:12.0f]
															  target:self selector:@selector(openHelloWorld)];
		CCMenu *menu = [CCMenu menuWithItems:helloWorld, nil];
		menu.position = ccp(44, 440);
		[self addChild:menu z:2];
	}
}


- (void)openHelloWorld
{
	[[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:1 scene:[JigglyHelloWorldLayer node]]];
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