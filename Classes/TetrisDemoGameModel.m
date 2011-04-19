//
//  TetrisDemoGameModel.m
//  TetrisDemo
//
//  Created by Martin Grider on 4/12/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "TetrisDemoGameModel.h"


@implementation TetrisDemoGameModel


@synthesize is_paused, is_game_over, framecount, level, speed, basespeed;
@synthesize score, piececount, rotatedcount, piecetype, nextpiecetype;
@synthesize total_rows, total_columns, unitsize;
@synthesize currentpiece, unitmap;


#pragma mark -
#pragma mark methods called when we start a new game

- (void)startNewGame
{
	is_paused = NO;
	is_game_over = NO;
	framecount = 0;
	level = 1;
	speed = 20;  // piece moves once every 20 frames
	basespeed = 20;  // how slow to start
	score = 0;
	piececount = 0;
	rotatedcount = 0;
	
	unitmap = [NSMutableArray arrayWithCapacity:total_rows];
	for ( int i=0; i < total_rows; i++ ) {
		[unitmap insertObject:[NSMutableArray arrayWithCapacity:total_columns] atIndex:i];
	}
	currentpiece = PieceCoordMake(1, 1, 2, 1, 3, 1, 4, 1);

	[self initNextPiece];
	[self newPiece];
}

- (void)initNextPiece
{
}

- (void)newPiece
{
}


#pragma mark -
#pragma mark work is called once per frame

- (void)work
{
	if ( is_paused || is_game_over ) {
		return;
	}

	// lets go ahead and assume we've got a nice steady frame rate
	// normally we would do something here to calculate how many frames of work we should be doing
	framecount++;
}


#pragma mark -
#pragma mark init/dealloc

-(id) init
{
	if ( (self = [super init]) )
	{
		// some config here
		total_rows = 20;
		total_columns = 10;
		unitsize = 320/total_rows;
	}
	return self;
}


- (void)dealloc
{
	[unitmap release];
	[super dealloc];
}


@end
