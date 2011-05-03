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
		[particle1 setColor:ccORANGE];
		CCMenuItemLabel *particle2 = [CCMenuItemLabel itemWithLabel:[CCLabelTTF labelWithString:@"Radius Type Particles" fontName:@"Helvetica" fontSize:12.0f]
															 target:self selector:@selector(openParticle2)];
		[particle2 setColor:ccORANGE];
		CCMenuItemLabel *particle3 = [CCMenuItemLabel itemWithLabel:[CCLabelTTF labelWithString:@"Fire Type Particles" fontName:@"Helvetica" fontSize:12.0f]
															 target:self selector:@selector(openParticle3)];
		[particle3 setColor:ccORANGE];
		CCMenuItemLabel *particle4 = [CCMenuItemLabel itemWithLabel:[CCLabelTTF labelWithString:@"Explosion Type Particles" fontName:@"Helvetica" fontSize:12.0f]
															 target:self selector:@selector(openParticle4)];
		[particle4 setColor:ccORANGE];
		CCMenuItemLabel *particle5 = [CCMenuItemLabel itemWithLabel:[CCLabelTTF labelWithString:@"Flower Type Particles" fontName:@"Helvetica" fontSize:12.0f]
															 target:self selector:@selector(openParticle5)];
		[particle5 setColor:ccORANGE];
		CCMenuItemLabel *particle6 = [CCMenuItemLabel itemWithLabel:[CCLabelTTF labelWithString:@"Galaxy Type Particles" fontName:@"Helvetica" fontSize:12.0f]
															 target:self selector:@selector(openParticle6)];
		[particle6 setColor:ccORANGE];
		CCMenuItemLabel *particle7 = [CCMenuItemLabel itemWithLabel:[CCLabelTTF labelWithString:@"Rain Type Particles" fontName:@"Helvetica" fontSize:12.0f]
															 target:self selector:@selector(openParticle7)];
		[particle7 setColor:ccORANGE];
		CCMenuItemLabel *particle8 = [CCMenuItemLabel itemWithLabel:[CCLabelTTF labelWithString:@"Smoke Type Particles" fontName:@"Helvetica" fontSize:12.0f]
															 target:self selector:@selector(openParticle8)];
		[particle8 setColor:ccORANGE];
		CCMenuItemLabel *particle9 = [CCMenuItemLabel itemWithLabel:[CCLabelTTF labelWithString:@"Snow Type Particles" fontName:@"Helvetica" fontSize:12.0f]
															 target:self selector:@selector(openParticle9)];
		[particle9 setColor:ccORANGE];
		CCMenuItemLabel *particle10 = [CCMenuItemLabel itemWithLabel:[CCLabelTTF labelWithString:@"Spiral Type Particles" fontName:@"Helvetica" fontSize:12.0f]
															 target:self selector:@selector(openParticle10)];
		[particle10 setColor:ccORANGE];
		CCMenuItemLabel *particle11 = [CCMenuItemLabel itemWithLabel:[CCLabelTTF labelWithString:@"Sun Type Particles" fontName:@"Helvetica" fontSize:12.0f]
															 target:self selector:@selector(openParticle11)];
		[particle11 setColor:ccORANGE];
		
		// Make the menu
		CGSize size = [[CCDirector sharedDirector] winSize];
		CCMenu *menu = [CCMenu menuWithItems:helloWorld, particle1, particle2, particle3, particle4, 
						particle5, particle6, particle7, particle8, particle9, particle10, particle11, nil];
		[menu alignItemsVertically];
		menu.position =  ccp( size.width /3 , size.height/2 );
		[self addChild:menu z:2];

		CCMenuItemLabel *asdf = [CCMenuItemLabel itemWithLabel:[CCLabelTTF labelWithString:@"Jiggly Hello World" fontName:@"Helvetica" fontSize:12.0f]
															  target:self selector:@selector(openHelloWorld)];
	}
	return self;
}


- (void)openParticle11
{
	TetrisDemoParticles1 *particles = [TetrisDemoParticles1 node];
	[particles setUpParticles11];
	[[CCDirector sharedDirector] replaceScene:
	 [CCTransitionFadeDown transitionWithDuration:1 scene:(CCScene*)particles]];
}


- (void)openParticle10
{
	TetrisDemoParticles1 *particles = [TetrisDemoParticles1 node];
	[particles setUpParticles10];
	[[CCDirector sharedDirector] replaceScene:
	 [CCTransitionFadeDown transitionWithDuration:1 scene:(CCScene*)particles]];
}


- (void)openParticle9
{
	TetrisDemoParticles1 *particles = [TetrisDemoParticles1 node];
	[particles setUpParticles9];
	[[CCDirector sharedDirector] replaceScene:
	 [CCTransitionFadeDown transitionWithDuration:1 scene:(CCScene*)particles]];
}


- (void)openParticle8
{
	TetrisDemoParticles1 *particles = [TetrisDemoParticles1 node];
	[particles setUpParticles8];
	[[CCDirector sharedDirector] replaceScene:
	 [CCTransitionFadeDown transitionWithDuration:1 scene:(CCScene*)particles]];
}


- (void)openParticle7
{
	TetrisDemoParticles1 *particles = [TetrisDemoParticles1 node];
	[particles setUpParticles7];
	[[CCDirector sharedDirector] replaceScene:
	 [CCTransitionFadeDown transitionWithDuration:1 scene:(CCScene*)particles]];
}


- (void)openParticle6
{
	TetrisDemoParticles1 *particles = [TetrisDemoParticles1 node];
	[particles setUpParticles6];
	[[CCDirector sharedDirector] replaceScene:
	 [CCTransitionFadeDown transitionWithDuration:1 scene:(CCScene*)particles]];
}


- (void)openParticle5
{
	TetrisDemoParticles1 *particles = [TetrisDemoParticles1 node];
	[particles setUpParticles5];
	[[CCDirector sharedDirector] replaceScene:
	 [CCTransitionFadeDown transitionWithDuration:1 scene:(CCScene*)particles]];
}


- (void)openParticle4
{
	TetrisDemoParticles1 *particles = [TetrisDemoParticles1 node];
	[particles setUpParticles4];
	[[CCDirector sharedDirector] replaceScene:
	 [CCTransitionFadeDown transitionWithDuration:1 scene:(CCScene*)particles]];
}


- (void)openParticle3
{
	TetrisDemoParticles1 *particles = [TetrisDemoParticles1 node];
	[particles setUpParticles3];
	[[CCDirector sharedDirector] replaceScene:
	 [CCTransitionFadeDown transitionWithDuration:1 scene:(CCScene*)particles]];
}


- (void)openParticle2
{
	TetrisDemoParticles1 *particles = [TetrisDemoParticles1 node];
	[particles setUpParticlesRadius];

	[[CCDirector sharedDirector] replaceScene:
	 [CCTransitionFadeDown transitionWithDuration:1 scene:(CCScene*)particles]];
}


- (void)openParticle1
{
	TetrisDemoParticles1 *particles = [TetrisDemoParticles1 node];
	[particles setUpParticles];
	
	[[CCDirector sharedDirector] replaceScene:
	 [CCTransitionFadeDown transitionWithDuration:1 scene:(CCScene*)particles]];
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