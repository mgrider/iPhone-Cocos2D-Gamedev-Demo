//
//  TetrisDemoCCMenu.m
//  TetrisDemo
//
//  Created by Martin Grider on 5/1/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "TetrisDemoCCMenu.h"
#import "TetrisDemoJigglyHello.h"
#import "TetrisDemoParticles1.h"


@implementation TetrisDemoCCMenu


-(id) init
{
	// always call "super" init
	if( (self=[super init])) {

		// make some CCMenuItems
		CCMenuItemLabel *helloWorld = [CCMenuItemLabel itemWithLabel:[CCLabelTTF labelWithString:@"Jiggly Hello World" fontName:@"Helvetica" fontSize:12.0f]
															  target:self selector:@selector(openHelloWorld)];

		CCMenuItemLabel *particle1 = [CCMenuItemLabel itemWithLabel:[CCLabelTTF labelWithString:@"Firework Type Particles" fontName:@"Helvetica" fontSize:12.0f]
															  target:self selector:@selector(openParticle1)];
		CCMenuItemLabel *particle2 = [CCMenuItemLabel itemWithLabel:[CCLabelTTF labelWithString:@"Radius Type Particles" fontName:@"Helvetica" fontSize:12.0f]
															 target:self selector:@selector(openParticle2)];

		// Make the menu
		CGSize size = [[CCDirector sharedDirector] winSize];
		CCMenu *menu = [CCMenu menuWithItems:helloWorld, particle1, nil];
		[menu alignItemsVertically];
		menu.position =  ccp( size.width /2 , size.height/2 );
		[self addChild:menu z:2];
	}
	return self;
}


- (void)openParticle2
{
	TetrisDemoParticles1 *particles = [TetrisDemoParticles1 node];
	[particles setUpParticles];

	[[CCDirector sharedDirector] replaceScene:
	 [CCTransitionFadeDown transitionWithDuration:1 scene:particles]];
}


- (void)openParticle1
{
	[[CCDirector sharedDirector] replaceScene:
	 [CCTransitionFadeDown transitionWithDuration:1 scene:[TetrisDemoParticles1 node]]];
}


- (void)openHelloWorld
{
	[[CCDirector sharedDirector] replaceScene:
	 [CCTransitionFade transitionWithDuration:1 scene:[TetrisDemoJigglyHello node]]];
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