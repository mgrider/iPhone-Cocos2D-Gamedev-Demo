//
//  TetrisDemoJigglyHello.m
//  TetrisDemo
//
//  Created by Martin Grider on 3/26/11.
//  Copyright __MyCompanyName__ 2011. All rights reserved.
//


// Import the interfaces
#import "TetrisDemoParticles1.h"
#import "TetrisDemoCCMenu.h"

// TetrisDemoLayer implementation
@implementation TetrisDemoParticles1


- (void)setUpParticles
{
	CCParticleFireworks *emitter = [[CCParticleFireworks alloc] initWithTotalParticles:413];
	[emitter setEmitterMode: kCCParticleModeGravity];
	[self addChild:emitter];
}

- (void)setUpParticlesRadius
{
	CCParticleFireworks *emitter = [[CCParticleFireworks alloc] initWithTotalParticles:413];
	[emitter setEmitterMode: kCCParticleModeRadius];
	[emitter setAngle:180];
	[self addChild:emitter];
}

- (void)setUpParticles3
{
	CCParticleFire *emitter = [[CCParticleFire alloc] initWithTotalParticles:10];
	[self addChild:emitter];
}

- (void)setUpParticles4
{
	CCParticleExplosion *emitter = [[CCParticleExplosion alloc] initWithTotalParticles:1000];
	[self addChild:emitter];
}

- (void)setUpParticles5
{
	CCParticleFlower *emitter = [[CCParticleFlower alloc] initWithTotalParticles:100];
	[self addChild:emitter];
}

- (void)setUpParticles6
{
	CCParticleGalaxy *emitter = [[CCParticleGalaxy alloc] initWithTotalParticles:300];
	[self addChild:emitter];
}

- (void)setUpParticles7
{
	CCParticleRain *emitter = [[CCParticleRain alloc] initWithTotalParticles:300];
	[self addChild:emitter];
}

- (void)setUpParticles8
{
	CCParticleSmoke *emitter = [[CCParticleSmoke alloc] initWithTotalParticles:300];
	[self addChild:emitter];
}

- (void)setUpParticles9
{
	CCParticleSnow *emitter = [[CCParticleSnow alloc] initWithTotalParticles:300];
	[self addChild:emitter];
}

- (void)setUpParticles10
{
	CCParticleSpiral *emitter = [[CCParticleSpiral alloc] init];
	[self addChild:emitter];
}

- (void)setUpParticles11
{
	CCParticleSun *emitter = [[CCParticleSun alloc] initWithTotalParticles:300];
	[self addChild:emitter];
}

- (void)setUpParticlesOthers
{
	CCParticleFireworks *emitter = [[CCParticleFireworks alloc] initWithTotalParticles:413];
	[emitter setEmitterMode:kCCParticleModeRadius];

//	[emitter setEmitterMode: kCCParticleModeRadius];
//	[emitter setStartSize:30.0f];
//	[emitter setEndSize:1.0f];
//	[emitter setStartSpin:10.0f];
/*	
	[emitter setGravity:ccp(1.23,0.28)];
	[emitter setSpeed:12.0];
	[emitter setLifeVar:8];
	[emitter setStartSize:26.0];
	[emitter setStartSizeVar:5.0];
	[emitter setEndSize:14.0];
	[emitter setEndSizeVar:33.0];
	[emitter setLife:10];
	[emitter setAngleVar:337];
 
	// you can also use Particle Designer: http://particledesigner.71squared.com/
*/
	
	[self addChild:emitter];
}



#pragma mark -
#pragma mark default stuff

+(CCScene *)scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	TetrisDemoParticles1 *layer = [TetrisDemoParticles1 node];
	[layer setTag:1000];

	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}

// on "init" you need to initialize your instance
-(id)init
{
	// always call "super" init
	// Apple recommends to re-assign "self" with the "super" return value
	if( (self=[super init])) {

		//[self setUpParticles];

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
