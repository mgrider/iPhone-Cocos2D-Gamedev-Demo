//
//  TetrisDemoLayer.m
//  TetrisDemo
//
//  Created by Martin Grider on 3/26/11.
//  Copyright __MyCompanyName__ 2011. All rights reserved.
//


// Import the interfaces
#import "TetrisDemoLayer.h"


#define BLOCK_RECT_I CGRectMake(0, 0, 16, 16)
#define BLOCK_RECT_SQ CGRectMake(16, 0, 16, 16)
#define BLOCK_RECT_J CGRectMake(32, 0, 16, 16)
#define BLOCK_RECT_S CGRectMake(0, 16, 16, 16)
#define BLOCK_RECT_Z CGRectMake(16, 16, 16, 16)
#define BLOCK_RECT_L CGRectMake(32, 16, 16, 16)
#define BLOCK_RECT_T CGRectMake(0, 32, 16, 16)
#define BLOCK_RECT_NONE CGRectMake(32, 32, 16, 16)

#define GAME_X_OFFSET ((480-(16*10))/2)

#define BLOCK_TAG_Y_OFFSET 1000


// TetrisDemoLayer implementation
@implementation TetrisDemoLayer
@synthesize gameModel, blockSheet, previous_current_piecetype;


#pragma mark -
#pragma mark work is called every frame

- (void)nextFrame:(ccTime)dt
{
	if ( [gameModel is_game_over] ) {
		[self drawGameOver];
		return;
	}

	// all important
	[gameModel work];

	// update display
	[levelLabel setString:[NSString stringWithFormat:@"Level: %i", [gameModel level]]];
	[scoreLabel setString:[NSString stringWithFormat:@"Score: %i", [gameModel score]]];

	// first draw the "set" units
	[self drawUnits];

	// then draw the current pieces
	[self drawCurrentPiece];
}

- (void)drawGameOver
{
	[gameOverLabel setVisible:YES];
}

- (void)drawUnits
{
	CCSprite *sprite;
	int thistag;
	int type;
	NSArray *row;
	for ( int i=0; i<[gameModel total_rows]; i++ ) {
		row = [[gameModel unitmap] objectAtIndex:i];
		for ( int j=0; j<[gameModel total_columns]; j++ ) {
			if ( [[row objectAtIndex:j] isKindOfClass:[NSNumber class]] ) {
				type = [(NSNumber*)[row objectAtIndex:j] intValue];
				thistag = (i*BLOCK_TAG_Y_OFFSET) + j;
				sprite = (CCSprite*)[blockSheet getChildByTag:thistag];
				[sprite setTextureRect:[self pieceRectForType:PieceTypeFromInt(type)]];
			}
		}
	}
}

- (void)drawCurrentPiece
{
	// change the texture if it's not the same as the previous piece
	if ( [gameModel piecetype] != previous_current_piecetype ) {
		[block1 setTextureRect:[self pieceRectForType:[gameModel piecetype]]];
		[block2 setTextureRect:[self pieceRectForType:[gameModel piecetype]]];
		[block3 setTextureRect:[self pieceRectForType:[gameModel piecetype]]];
		[block4 setTextureRect:[self pieceRectForType:[gameModel piecetype]]];
	}
	PieceCoord coord = [gameModel currentpiece];
	block1.position = ccp( coord.ax*16+GAME_X_OFFSET, 320-(coord.ay*16) );
	[block2 setPosition:ccp( coord.bx*16+GAME_X_OFFSET, 320-(coord.by*16) )];
	[block3 setPosition:ccp( coord.cx*16+GAME_X_OFFSET, 320-(coord.cy*16) )];
	[block4 setPosition:ccp( coord.dx*16+GAME_X_OFFSET, 320-(coord.dy*16) )];
	previous_current_piecetype = [gameModel piecetype];
}

- (void)startGame
{
	// draw initial stuff
	// background, etc.
}


#pragma mark -
#pragma mark utilities

- (CGRect)pieceRectForType:(PieceType)type
{
	switch (type) {
		case PIECE_TYPE_I: return BLOCK_RECT_I;
		case PIECE_TYPE_J: return BLOCK_RECT_J;
		case PIECE_TYPE_L: return BLOCK_RECT_L;
		case PIECE_TYPE_SQUARE: return BLOCK_RECT_SQ;
		case PIECE_TYPE_S: return BLOCK_RECT_S;
		case PIECE_TYPE_Z: return BLOCK_RECT_Z;
		case PIECE_TYPE_T: return BLOCK_RECT_T;
	}
}


#pragma mark -
#pragma mark default stuff

+(CCScene *)scene
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

// on "init" you need to initialize your instance
-(id)init
{
	// always call "super" init
	// Apple recommends to re-assign "self" with the "super" return value
	if( (self=[super init])) {

		// ask director the the window size
		CGSize size = [[CCDirector sharedDirector] winSize];

		// create and initialize a Label
		levelLabel = [CCLabelTTF labelWithString:@"Level: " fontName:@"Courier" fontSize:14];
		levelLabel.position = ccp( 50, size.height - 20);
		[self addChild:levelLabel];

		scoreLabel = [CCLabelTTF labelWithString:@"Score: " fontName:@"Courier" fontSize:14];
		scoreLabel.position = ccp( 50, size.height - 50);
		[self addChild:scoreLabel];

		// init the game object
		gameModel = [[TetrisDemoGameModel alloc] init];
		[gameModel startNewGame];

		// init the texture atlas for our tetris blocks
		blockSheet = [CCSpriteBatchNode batchNodeWithFile:@"squares3.png"];
		[self addChild:blockSheet];

		// init the sprites for each square
		CCSprite *sprite;
		for ( int i=0; i < [gameModel total_rows]; i++ ) {
			for ( int j=0; j < [gameModel total_columns]; j++ ) {
				sprite = [CCSprite spriteWithBatchNode:blockSheet rect:BLOCK_RECT_NONE];
				[sprite setTag:((i*BLOCK_TAG_Y_OFFSET) + j)];
				[sprite setPosition:ccp( (j*16)+GAME_X_OFFSET, (320-(i*16)) )];
				[blockSheet addChild:sprite];
			}
		}

		// init the current piece blocks
		block1 = [CCSprite spriteWithBatchNode:blockSheet rect:BLOCK_RECT_I];
		[blockSheet addChild:block1];
		block2 = [CCSprite spriteWithBatchNode:blockSheet rect:BLOCK_RECT_I];
		[blockSheet addChild:block2];
		block3 = [CCSprite spriteWithBatchNode:blockSheet rect:BLOCK_RECT_I];
		[blockSheet addChild:block3];
		block4 = [CCSprite spriteWithBatchNode:blockSheet rect:BLOCK_RECT_I];
		[blockSheet addChild:block4];

		// draw a label for the game over
		gameOverLabel = [CCLabelTTF labelWithString:@"Game Over!" fontName:@"Courier" fontSize:52];
		gameOverLabel.position = ccp( size.width / 2, size.height / 2 );
		[gameOverLabel setVisible:NO];
		[self addChild:gameOverLabel];
		gameOverLabel2 = [CCLabelTTF labelWithString:@"Game Over!" fontName:@"Courier" fontSize:52];
		gameOverLabel2.position = ccp( (size.width / 2)+2, (size.height / 2)+2 );
		[gameOverLabel2 setColor:ccBLACK];
		[gameOverLabel2 setVisible:NO];
		[self addChild:gameOverLabel2];

		// actually start the game
		[self startGame];

		// schedule a repeating callback on every frame
        [self schedule:@selector(nextFrame:)];
	}
	return self;
}

// on "dealloc" you need to release all your retained objects
- (void) dealloc
{
	// cocos2d will automatically release all the children (Label)

	// stuff that isn't a child of self
	[blockSheet release];
	[gameModel release];

	// don't forget to call "super dealloc"
	[super dealloc];
}
@end
