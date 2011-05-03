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
@synthesize score, piececount, rotatedcount, capturedrowcount, piecetype, nextpiecetype;
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
	
	self.unitmap = [NSMutableArray arrayWithCapacity:total_rows];
	for ( int i=0; i < total_rows; i++ ) {
		NSMutableArray *unitArray = [NSMutableArray arrayWithCapacity:total_columns];
		for (int j=0; j<total_columns; j++) {
			[unitArray addObject:[NSNull null]];
		}
		[unitmap insertObject:unitArray atIndex:i];
	}
	// this will get overwritten in newPiece
	currentpiece = PieceCoordMake(1, 1, 2, 1, 3, 1, 4, 1);

	[self initNextPiece];
	[self newPiece];
}

- (void)initNextPiece
{
	int nextPieceInt = ( arc4random() % 7 );
	nextpiecetype = PieceTypeFromInt( nextPieceInt );
}

- (void)newPiece
{
	// new piece is always of the nextpiecetype
	piecetype = nextpiecetype;
	currentpiece = [self pieceCoordinatesFromPieceType:piecetype];

	// move the pieces over to the center of the board
	int center = (int)total_columns / 2;
	currentpiece.ax += center;
	currentpiece.bx += center;
	currentpiece.cx += center;
	currentpiece.dx += center;

	// piece is not rotated
	rotatedcount = 0;

	[self initNextPiece];
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
	
	speed = basespeed - level;
	if (speed<1) {
		speed = 1;
	}

	if ( framecount % speed == 0 ) {

		NSLog(@"found a frame.");
		// reset the framecount
		framecount = 0;

		// move the piece down (assuming there's room, and we're not falling off the bottom of the board)
		if ( (currentpiece.ay + 1) < total_rows &&
			(currentpiece.by + 1) < total_rows &&
			(currentpiece.cy + 1) < total_rows &&
			(currentpiece.dy + 1) < total_rows &&
			[[unitmap objectAtIndex:currentpiece.ay + 1] objectAtIndex:(currentpiece.ax)] == [NSNull null] &&
			[[unitmap objectAtIndex:currentpiece.by + 1] objectAtIndex:(currentpiece.bx)] == [NSNull null] &&
			[[unitmap objectAtIndex:currentpiece.cy + 1] objectAtIndex:(currentpiece.cx)] == [NSNull null] &&
			[[unitmap objectAtIndex:currentpiece.dy + 1] objectAtIndex:(currentpiece.dx)] == [NSNull null] )
		{
			NSLog(@"curentpiece has fallen.");
			currentpiece.ay++;
			currentpiece.by++;
			currentpiece.cy++;
			currentpiece.dy++;
		}
		else 
		{
			NSLog(@"setting the piece down. piecetype is %i", piecetype);
			// set the piece down
			[[unitmap objectAtIndex:currentpiece.ay] replaceObjectAtIndex:currentpiece.ax withObject:[NSNumber numberWithInt:piecetype]];
			[[unitmap objectAtIndex:currentpiece.by] replaceObjectAtIndex:currentpiece.bx withObject:[NSNumber numberWithInt:piecetype]];
			[[unitmap objectAtIndex:currentpiece.cy] replaceObjectAtIndex:currentpiece.cx withObject:[NSNumber numberWithInt:piecetype]];
			[[unitmap objectAtIndex:currentpiece.dy] replaceObjectAtIndex:currentpiece.dx withObject:[NSNumber numberWithInt:piecetype]];

//NSLog(@"unitmap is %@", unitmap);
			// check for rows to break
			[self checkForCompletedRows];

			// make a new one
			[self newPiece];
		}

	}
}

- (void)checkForCompletedRows {
	//keep an array of completed rows
	NSMutableArray *completedRows = [NSMutableArray arrayWithCapacity:1];
	BOOL completed;
	for (int i=0; i<total_rows; i++) {
		completed = YES;
		for (int j=0; j<total_columns; j++) {
			if ( [[[unitmap objectAtIndex:i] objectAtIndex:j] isEqual:[NSNull null]] ) {
				completed = NO;
				continue;
			}
		}
		if (completed) {
			[completedRows addObject:[NSNumber numberWithInt:i]];
		}
	}
	if ( [completedRows count] > 0 ) {
		[self updateScoreWithInt:[completedRows count]];
	}
	NSLog(@"there were %i completed rows.", [completedRows count]);
}


#pragma mark -
#pragma mark event based methods

- (void)updateScoreWithInt:(int)new_score {
	self.score += (self.level * new_score * new_score);
}

- (void)checkForNewLevel {
	int nextlevel = self.level * self.level * 10;
	if ( self.score >= nextlevel ) {
		self.level++;
		[self checkForNewLevel];
	}
}


#pragma mark -
#pragma mark helper/conversion methods

- (PieceCoord)pieceCoordinatesFromPieceType:(PieceType)newType
{
	switch (newType) {
		case PIECE_TYPE_I:
			return PieceCoordMake(0, 0, 1, 0, 2, 0, 3, 0);
		case PIECE_TYPE_J:
			return PieceCoordMake(0, 0, 1, 0, 2, 0, 2, 1);
		case PIECE_TYPE_L:
			return PieceCoordMake(0, 0, 1, 0, 2, 0, 0, 1);
		case PIECE_TYPE_SQUARE:
			return PieceCoordMake(0, 0, 0, 1, 1, 1, 1, 0);
		case PIECE_TYPE_S:
			return PieceCoordMake(0, 1, 1, 1, 1, 0, 2, 0);
		case PIECE_TYPE_Z:
			return PieceCoordMake(0, 0, 1, 0, 1, 1, 2, 1);
		case PIECE_TYPE_T:
			return PieceCoordMake(0, 0, 1, 0, 2, 0, 1, 1);
	}
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
