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
@synthesize score, rotatedcount, capturedrowcount, piecetype, nextpiecetype;
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
	int center = (int)(total_columns / 2) - 1;
	currentpiece.ax += center;
	currentpiece.bx += center;
	currentpiece.cx += center;
	currentpiece.dx += center;

	// check for game over
	if ( [[unitmap objectAtIndex:(currentpiece.ay)] objectAtIndex:(currentpiece.ax)] != [NSNull null] ||
		[[unitmap objectAtIndex:(currentpiece.by)] objectAtIndex:(currentpiece.by)] != [NSNull null] ||
		[[unitmap objectAtIndex:(currentpiece.cy)] objectAtIndex:(currentpiece.cy)] != [NSNull null] ||
		[[unitmap objectAtIndex:(currentpiece.dy)] objectAtIndex:(currentpiece.dy)] != [NSNull null] ) {
		[self gameOver];
	}

	// piece is not rotated
	rotatedcount = 0;

	[self initNextPiece];
}

- (void)gameOver
{
	is_game_over = YES;
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

		//NSLog(@"found a frame.");

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

- (void)checkForCompletedRows
{
	//keep an array of completed rows
	NSMutableArray *completedRows = [NSMutableArray arrayWithCapacity:1];
	BOOL completed;
	for (int i=0; i<total_rows; i++) {
		completed = YES;
		for (int j=0; j<total_columns; j++) {
			if ( completed && [[[unitmap objectAtIndex:i] objectAtIndex:j] isEqual:[NSNull null]] ) {
				completed = NO;
			}
		}
		if (completed) {
			[completedRows addObject:[NSNumber numberWithInt:i]];
		}
	}
	if ( [completedRows count] > 0 ) {
		[self updateScoreWithInt:[completedRows count]];
	}
	for ( NSNumber *rowNum in completedRows ) {
		for ( int i=0; i < [rowNum intValue]; i++) {
			int y_index = [rowNum intValue] - i;
			int replacement_y_index = (y_index - 1);
			for (int j=0; j<total_columns; j++) {
				id replacementObject = [[unitmap objectAtIndex:replacement_y_index] objectAtIndex:j];
				[[unitmap objectAtIndex:y_index] replaceObjectAtIndex:j withObject:replacementObject];
			}
		}
	}
	[self printModel];
	NSLog(@"there were %i completed rows.", [completedRows count]);
}

- (void)printModel
{
	NSMutableString *modelString = [NSMutableString stringWithString:@"gameboard: \n"];
	for (int i=0; i < total_rows; i++) {
		for (int j=0; j < total_columns; j++) {
			if ( [[[unitmap objectAtIndex:i] objectAtIndex:j] isKindOfClass:[NSNumber class]] ) {
				[modelString appendFormat:@"%@,",[[[unitmap objectAtIndex:i] objectAtIndex:j] stringValue]];
			}
			else {
				[modelString appendString:@"-,"];
			}
		}
		[modelString appendString:@"\n"];
	}
	NSLog(@"%@",modelString);
}


#pragma mark -
#pragma mark event based methods

- (void)updateScoreWithInt:(int)new_score
{
	self.score += (self.level * new_score * new_score);
}

- (void)checkForNewLevel
{
	int nextlevel = self.level * self.level * 10;
	if ( self.score >= nextlevel ) {
		self.level++;
		[self checkForNewLevel];
	}
}

- (void)dropCurrentPiece
{
	while ( (currentpiece.ay + 1) < total_rows &&
		   (currentpiece.by + 1) < total_rows &&
		   (currentpiece.cy + 1) < total_rows &&
		   (currentpiece.dy + 1) < total_rows &&
		   [self unitmapIsEmptyAtX:currentpiece.ax andY:(currentpiece.ay + 1)] &&
		   [self unitmapIsEmptyAtX:currentpiece.bx andY:(currentpiece.by + 1)] &&
		   [self unitmapIsEmptyAtX:currentpiece.cx andY:(currentpiece.cy + 1)] &&
		   [self unitmapIsEmptyAtX:currentpiece.dx andY:(currentpiece.dy + 1)] )
	{
		currentpiece.ay++;
		currentpiece.by++;
		currentpiece.cy++;
		currentpiece.dy++;
	}
}

- (void)movePieceLeft
{
	if ( currentpiece.ax > 0 &&
		currentpiece.bx > 0 &&
		currentpiece.cx > 0 &&
		currentpiece.dx > 0 &&
		[self unitmapIsEmptyAtX:(currentpiece.ax - 1) andY:currentpiece.ay] &&
		[self unitmapIsEmptyAtX:(currentpiece.bx - 1) andY:currentpiece.by] &&
		[self unitmapIsEmptyAtX:(currentpiece.cx - 1) andY:currentpiece.cy] &&
		[self unitmapIsEmptyAtX:(currentpiece.dx - 1) andY:currentpiece.dy] )
	{
		currentpiece.ax -= 1;
		currentpiece.bx -= 1;
		currentpiece.cx -= 1;
		currentpiece.dx -= 1;
	}
}

- (void)movePieceRight
{
	if ( currentpiece.ax < (total_columns - 1) &&
		currentpiece.bx < (total_columns - 1) &&
		currentpiece.cx < (total_columns - 1) &&
		currentpiece.dx < (total_columns - 1) &&
		[self unitmapIsEmptyAtX:(currentpiece.ax + 1) andY:currentpiece.ay] &&
		[self unitmapIsEmptyAtX:(currentpiece.bx + 1) andY:currentpiece.by] &&
		[self unitmapIsEmptyAtX:(currentpiece.cx + 1) andY:currentpiece.cy] &&
		[self unitmapIsEmptyAtX:(currentpiece.dx + 1) andY:currentpiece.dy] )
	{
		currentpiece.ax += 1;
		currentpiece.bx += 1;
		currentpiece.cx += 1;
		currentpiece.dx += 1;
	}
}

- (void)rotatePiece {

	if (piecetype == PIECE_TYPE_I) // "I"
	{
		if (rotatedcount == 0)
		{
			// rotates around 2
			if ( [self unitmapIsEmptyAtX:( currentpiece.ax + 2 ) andY:( currentpiece.ay - 2 )] && 
				[self unitmapIsEmptyAtX:( currentpiece.bx + 1 ) andY:( currentpiece.by - 1 )] && 
				[self unitmapIsEmptyAtX:( currentpiece.dx - 1 ) andY:( currentpiece.dy + 1 )] &&
				(currentpiece.dy + 1) < total_rows )
			{
				currentpiece.ax = currentpiece.ax + 2;
				currentpiece.ay = currentpiece.ay - 2;
				currentpiece.bx = currentpiece.bx + 1;
				currentpiece.by = currentpiece.by - 1;
				currentpiece.dx = currentpiece.dx - 1;
				currentpiece.dy = currentpiece.dy + 1;
				rotatedcount++;
			}
		}
		else if (rotatedcount == 1)
		{
			// doesn't rotate "around" -- "slides" 1 to the left
			if ( [self unitmapIsEmptyAtX:( currentpiece.ax + 1 ) andY:( currentpiece.ay + 2 )] && 
				[self unitmapIsEmptyAtX:( currentpiece.bx ) andY:( currentpiece.by + 1 )] && 
				[self unitmapIsEmptyAtX:( currentpiece.cx - 1 ) andY:( currentpiece.cy )] && 
				[self unitmapIsEmptyAtX:( currentpiece.dx - 2 ) andY:( currentpiece.dy - 1 )] && 
				(currentpiece.ax + 1) < (total_columns - 1) && 
				(currentpiece.dx - 2) >= 0 )
			{
				currentpiece.ax = currentpiece.ax + 1;
				currentpiece.ay = currentpiece.ay + 2;
				currentpiece.by = currentpiece.by + 1;
				currentpiece.cx = currentpiece.cx - 1;
				currentpiece.dx = currentpiece.dx - 2;
				currentpiece.dy = currentpiece.dy - 1;
				rotatedcount++;
			}
			// if we're next to the right wall, lets slide over automagicallly
			else if ( (currentpiece.ax + 1) >= (total_columns - 1) ) 
			{
				if ( [self unitmapIsEmptyAtX:( currentpiece.ax ) andY:( currentpiece.ay + 2 )] && 
					[self unitmapIsEmptyAtX:( currentpiece.bx - 1 ) andY:( currentpiece.by + 1 )] && 
					[self unitmapIsEmptyAtX:( currentpiece.cx - 2 ) andY:( currentpiece.cy )] && 
					[self unitmapIsEmptyAtX:( currentpiece.dx - 3 ) andY:( currentpiece.dy - 1 )])
				{
					currentpiece.ay = currentpiece.ay + 2;
					currentpiece.bx = currentpiece.bx - 1;
					currentpiece.by = currentpiece.by + 1;
					currentpiece.cx = currentpiece.cx - 2;
					currentpiece.dx = currentpiece.dx - 3;
					currentpiece.dy = currentpiece.dy - 1;
					rotatedcount++;
				}
			}
			// right next to the left wall?
			else if ( currentpiece.dx - 2 < 0 ) {
				// one space away
				if ( [self unitmapIsEmptyAtX:( currentpiece.ax + 2 ) andY:( currentpiece.ay + 2 )] && 
					[self unitmapIsEmptyAtX:( currentpiece.bx + 1 ) andY:( currentpiece.by + 1 )] && 
					[self unitmapIsEmptyAtX:currentpiece.cx andY:(currentpiece.cy)] && 
					[self unitmapIsEmptyAtX:(currentpiece.dx - 1 ) andY:( currentpiece.dy - 1 )] &&
					((currentpiece.dx - 1) == 0) )
				{
					currentpiece.ax = currentpiece.ax + 2;
					currentpiece.ay = currentpiece.ay + 2;
					currentpiece.bx = currentpiece.bx + 1;
					currentpiece.by = currentpiece.by + 1;
					currentpiece.dx = currentpiece.dx - 1;
					currentpiece.dy = currentpiece.dy - 1;
					rotatedcount++;
				}
				// two spaces
				else if ( [self unitmapIsEmptyAtX:( currentpiece.ax + 3 ) andY:( currentpiece.ay + 2 )] && 
						 [self unitmapIsEmptyAtX:( currentpiece.bx + 2 ) andY:( currentpiece.by + 1 )] && 
						 [self unitmapIsEmptyAtX:( currentpiece.cx + 1 ) andY:( currentpiece.cy )] && 
						 [self unitmapIsEmptyAtX:( currentpiece.dx ) andY:( currentpiece.dy - 1 )] &&
						 currentpiece.dx == 0 )
				{
					currentpiece.ax = currentpiece.ax + 3;
					currentpiece.ay = currentpiece.ay + 2;
					currentpiece.bx = currentpiece.bx + 2;
					currentpiece.by = currentpiece.by + 1;
					currentpiece.cx = currentpiece.cx + 1;
					currentpiece.dy = currentpiece.dy - 1;
					rotatedcount++;
				}
			}
		}
		else if (rotatedcount == 2)
		{
			// rotate around 1
			if ( [self unitmapIsEmptyAtX:( currentpiece.ax - 1 ) andY:( currentpiece.ay + 1 )] && 
				[self unitmapIsEmptyAtX:( currentpiece.cx + 1 ) andY:( currentpiece.cy - 1 )] && 
				[self unitmapIsEmptyAtX:( currentpiece.dx + 2 ) andY:( currentpiece.dy - 2 )] &&
				(currentpiece.ay + 1) < total_rows )
			{
				currentpiece.ax = currentpiece.ax - 1;
				currentpiece.ay = currentpiece.ay + 1;
				currentpiece.cx = currentpiece.cx + 1;
				currentpiece.cy = currentpiece.cy - 1;
				currentpiece.dx = currentpiece.dx + 2;
				currentpiece.dy = currentpiece.dy - 2;
				rotatedcount++;
			}
		}
		else if (rotatedcount == 3)
		{
			// rotate around one, but slide to the left one
			if ( [self unitmapIsEmptyAtX:( currentpiece.ax - 2 ) andY:( currentpiece.ay - 1 )] && 
				[self unitmapIsEmptyAtX:( currentpiece.bx - 1 ) andY:( currentpiece.by )] && 
				[self unitmapIsEmptyAtX:( currentpiece.cx ) andY:( currentpiece.cy + 1 )] && 
				[self unitmapIsEmptyAtX:( currentpiece.dx + 1 ) andY:( currentpiece.dy + 2 )] && 
				(currentpiece.dx + 1) < (total_columns - 1) && 
				(currentpiece.ax - 2) >= 0 )
			{
				currentpiece.ax = currentpiece.ax - 2;
				currentpiece.ay = currentpiece.ay - 1;
				currentpiece.bx = currentpiece.bx - 1;
				currentpiece.cy = currentpiece.cy + 1;
				currentpiece.dx = currentpiece.dx + 1;
				currentpiece.dy = currentpiece.dy + 2;
				rotatedcount = 0;
			}
			// if we're next to the right wall, lets slide over automagicallly
			else if ( (currentpiece.dx + 1) >= (total_columns - 1) ) 
			{
				if ( [self unitmapIsEmptyAtX:( currentpiece.ax - 3 ) andY:( currentpiece.ay - 1 )] && 
					[self unitmapIsEmptyAtX:( currentpiece.bx - 2 ) andY:( currentpiece.by )] && 
					[self unitmapIsEmptyAtX:( currentpiece.cx - 1 ) andY:( currentpiece.cy + 1 )] && 
					[self unitmapIsEmptyAtX:( currentpiece.dx ) andY:( currentpiece.dy + 2 )])
				{
					currentpiece.ax = currentpiece.ax - 3;
					currentpiece.ay = currentpiece.ay - 1;
					currentpiece.bx = currentpiece.bx - 2;
					currentpiece.cx = currentpiece.cx - 1;
					currentpiece.cy = currentpiece.cy + 1;
					currentpiece.dy = currentpiece.dy + 2;
					rotatedcount = 0;
				}
			}
			// right next to the left wall?
			else if ( currentpiece.ax - 2 < 0 ) {
				// one space away
				if ( [self unitmapIsEmptyAtX:( currentpiece.ax - 1 ) andY:( currentpiece.ay - 1 )] && 
					[self unitmapIsEmptyAtX:( currentpiece.cx + 1 ) andY:( currentpiece.cy + 1 )] && 
					[self unitmapIsEmptyAtX:( currentpiece.dx + 2 ) andY:( currentpiece.dy + 2 )] &&
					(currentpiece.ax - 1) == 0 )
				{
					currentpiece.ax = currentpiece.ax - 1;
					currentpiece.ay = currentpiece.ay - 1;
					currentpiece.cx = currentpiece.cx + 1;
					currentpiece.cy = currentpiece.cy + 1;
					currentpiece.dx = currentpiece.dx + 2;
					currentpiece.dy = currentpiece.dy + 2;
					rotatedcount = 0;
				}
				// two spaces
				else if ( [self unitmapIsEmptyAtX:( currentpiece.ax ) andY:( currentpiece.ay - 1 )] && 
						 [self unitmapIsEmptyAtX:( currentpiece.bx + 1 ) andY:( currentpiece.by )] && 
						 [self unitmapIsEmptyAtX:( currentpiece.cx + 2 ) andY:( currentpiece.cy + 1 )] && 
						 [self unitmapIsEmptyAtX:( currentpiece.dx + 3 ) andY:( currentpiece.dy + 2 )] &&
						 currentpiece.ax == 0 )
				{
					currentpiece.ay = currentpiece.ay - 1;
					currentpiece.bx = currentpiece.bx + 1;
					currentpiece.cx = currentpiece.cx + 2;
					currentpiece.cy = currentpiece.cy + 1;
					currentpiece.dx = currentpiece.dx + 3;
					currentpiece.dy = currentpiece.dy + 2;
					rotatedcount = 0;
				}
			}
		}
	}
	else if (piecetype == PIECE_TYPE_J) // "J"
	{
		if (rotatedcount == 0)
		{
			// rotate around 2
			if ( [self unitmapIsEmptyAtX:( currentpiece.ax + 1 ) andY:( currentpiece.ay - 1 )] && 
				[self unitmapIsEmptyAtX:( currentpiece.cx - 1 ) andY:( currentpiece.cy + 1 )] && 
				[self unitmapIsEmptyAtX:( currentpiece.dx - 2 ) andY:( currentpiece.dy )] )
			{
				currentpiece.ax = currentpiece.ax + 1;
				currentpiece.ay = currentpiece.ay - 1;
				currentpiece.cx = currentpiece.cx - 1;
				currentpiece.cy = currentpiece.cy + 1;
				currentpiece.dx = currentpiece.dx - 2;
				rotatedcount++;
			}
		}
		else if (rotatedcount == 1)
		{
			if ( [self unitmapIsEmptyAtX:( currentpiece.ax + 1 ) andY:( currentpiece.ay + 2 )] && 
				[self unitmapIsEmptyAtX:( currentpiece.bx ) andY:( currentpiece.by + 1 )] &&
				[self unitmapIsEmptyAtX:( currentpiece.cx - 1 ) andY:( currentpiece.cy )] && 
				[self unitmapIsEmptyAtX:( currentpiece.dx ) andY:( currentpiece.dy - 1 )] && 
				(currentpiece.cx + 1) < total_columns )
			{
				currentpiece.ax = currentpiece.ax + 1;
				currentpiece.ay = currentpiece.ay + 2;
				currentpiece.by = currentpiece.by + 1;
				currentpiece.cx = currentpiece.cx - 1;
				currentpiece.dy = currentpiece.dy - 1;
				rotatedcount++;
			}
			else if ( [self unitmapIsEmptyAtX:( currentpiece.ax ) andY:( currentpiece.ay + 2 )] && 
					 [self unitmapIsEmptyAtX:( currentpiece.bx - 1 ) andY:( currentpiece.by + 1 )] &&
					 [self unitmapIsEmptyAtX:( currentpiece.cx - 2 ) andY:( currentpiece.cy )] && 
					 [self unitmapIsEmptyAtX:( currentpiece.dx - 1 ) andY:( currentpiece.dy - 1 )] && 
					 currentpiece.cx < total_columns )
			{
				currentpiece.ay = currentpiece.ay + 2;
				currentpiece.bx = currentpiece.bx - 1;
				currentpiece.by = currentpiece.by + 1;
				currentpiece.cx = currentpiece.cx - 2;
				currentpiece.dx = currentpiece.dx - 1;
				currentpiece.dy = currentpiece.dy - 1;
				rotatedcount++;
			}
		}
		else if (rotatedcount == 2)
		{
			if ( [self unitmapIsEmptyAtX:( currentpiece.ax - 2 ) andY:( currentpiece.ay )] && 
				[self unitmapIsEmptyAtX:( currentpiece.bx - 1 ) andY:( currentpiece.by - 1 )] &&
				[self unitmapIsEmptyAtX:( currentpiece.cx ) andY:( currentpiece.cy - 2 )] && 
				[self unitmapIsEmptyAtX:( currentpiece.dx + 1 ) andY:( currentpiece.dy - 1 )])
			{
				currentpiece.ax = currentpiece.ax - 2;
				currentpiece.bx = currentpiece.bx - 1;
				currentpiece.by = currentpiece.by - 1;
				currentpiece.cy = currentpiece.cy - 2;
				currentpiece.dx = currentpiece.dx + 1;
				currentpiece.dy = currentpiece.dy - 1;
				rotatedcount++;
			}
		}
		else
		{
			if ( [self unitmapIsEmptyAtX:( currentpiece.ax ) andY:( currentpiece.ay - 1 )] &&
				[self unitmapIsEmptyAtX:( currentpiece.bx + 1 ) andY:( currentpiece.by )] &&
				[self unitmapIsEmptyAtX:( currentpiece.cx + 2 ) andY:( currentpiece.cy + 1 )] && 
				[self unitmapIsEmptyAtX:( currentpiece.dx + 1 ) andY:( currentpiece.dy + 2 )] && 
				(currentpiece.dx + 1) < total_columns )
			{
				currentpiece.ay = currentpiece.ay - 1;
				currentpiece.bx = currentpiece.bx + 1;
				currentpiece.cx = currentpiece.cx + 2;
				currentpiece.cy = currentpiece.cy + 1;
				currentpiece.dx = currentpiece.dx + 1;
				currentpiece.dy = currentpiece.dy + 2;
				rotatedcount = 0;
			}
			else if ( [self unitmapIsEmptyAtX:( currentpiece.ax - 1 ) andY:( currentpiece.ay - 1 )] &&
					 [self unitmapIsEmptyAtX:( currentpiece.bx ) andY:( currentpiece.by )] &&
					 [self unitmapIsEmptyAtX:( currentpiece.cx + 1 ) andY:( currentpiece.cy + 1 )] && 
					 [self unitmapIsEmptyAtX:( currentpiece.dx ) andY:( currentpiece.dy + 2 )] && 
					 currentpiece.dx < total_columns )
			{
				currentpiece.ax = currentpiece.ax - 1;
				currentpiece.ay = currentpiece.ay - 1;
				currentpiece.cx = currentpiece.cx + 1;
				currentpiece.cy = currentpiece.cy + 1;
				currentpiece.dy = currentpiece.dy + 2;
				rotatedcount = 0;
			}
		}
	}
	else if (piecetype == PIECE_TYPE_L) // "L"
	{
		if (rotatedcount == 0)
		{
			if ( [self unitmapIsEmptyAtX:( currentpiece.ax + 1 ) andY:( currentpiece.ay - 1 )] && 
				[self unitmapIsEmptyAtX:( currentpiece.cx - 1 ) andY:( currentpiece.cy + 1 )] && 
				[self unitmapIsEmptyAtX:( currentpiece.dx ) andY:( currentpiece.dy - 2 )])
			{
				currentpiece.ax = currentpiece.ax + 1;
				currentpiece.ay = currentpiece.ay - 1;
				currentpiece.cx = currentpiece.cx - 1;
				currentpiece.cy = currentpiece.cy + 1;
				currentpiece.dy = currentpiece.dy - 2;
				rotatedcount++;
			}
		}
		else if (rotatedcount == 1)
		{
			if ( [self unitmapIsEmptyAtX:( currentpiece.ax + 1 ) andY:( currentpiece.ay + 2 )] &&
				[self unitmapIsEmptyAtX:( currentpiece.bx ) andY:( currentpiece.by + 1 )] &&
				[self unitmapIsEmptyAtX:( currentpiece.cx - 1 ) andY:( currentpiece.cy )] && 
				[self unitmapIsEmptyAtX:( currentpiece.dx + 2 ) andY:( currentpiece.dy + 1 )] && 
				(currentpiece.ax + 1) <= (total_columns - 1) )
			{
				currentpiece.ax = currentpiece.ax + 1;
				currentpiece.ay = currentpiece.ay + 2;
				currentpiece.by = currentpiece.by + 1;
				currentpiece.cx = currentpiece.cx - 1;
				currentpiece.dx = currentpiece.dx + 2;
				currentpiece.dy = currentpiece.dy + 1;
				rotatedcount++;
			}
			// if we're up against something on the right, lets check 1 space to the left
			else if ( [self unitmapIsEmptyAtX:( currentpiece.ax ) andY:( currentpiece.ay + 2 )] &&
					 [self unitmapIsEmptyAtX:( currentpiece.bx - 1 ) andY:( currentpiece.by + 1 )] &&
					 [self unitmapIsEmptyAtX:( currentpiece.cx - 2 ) andY:( currentpiece.cy )] && 
					 [self unitmapIsEmptyAtX:( currentpiece.dx + 1 ) andY:( currentpiece.dy + 1 )] )
			{
				currentpiece.ay = currentpiece.ay + 2;
				currentpiece.bx = currentpiece.bx - 1;
				currentpiece.by = currentpiece.by + 1;
				currentpiece.cx = currentpiece.cx - 2;
				currentpiece.dx = currentpiece.dx + 1;
				currentpiece.dy = currentpiece.dy + 1;
				rotatedcount++;
			}
		}
		else if (rotatedcount == 2)
		{
			if ( [self unitmapIsEmptyAtX:( currentpiece.ax - 2 ) andY:( currentpiece.ay )] && 
				[self unitmapIsEmptyAtX:( currentpiece.bx - 1 ) andY:( currentpiece.by - 1 )] &&
				[self unitmapIsEmptyAtX:( currentpiece.cx ) andY:( currentpiece.cy - 2 )] && 
				[self unitmapIsEmptyAtX:( currentpiece.dx - 1 ) andY:( currentpiece.dy + 1 )])
			{
				currentpiece.ax = currentpiece.ax - 2;
				currentpiece.bx = currentpiece.bx - 1;
				currentpiece.by = currentpiece.by - 1;
				currentpiece.cy = currentpiece.cy - 2;
				currentpiece.dx = currentpiece.dx - 1;
				currentpiece.dy = currentpiece.dy + 1;
				rotatedcount++;
			}
		}
		else
		{
			if ( [self unitmapIsEmptyAtX:( currentpiece.ax ) andY:( currentpiece.ay - 1 )] && 
				[self unitmapIsEmptyAtX:( currentpiece.bx + 1 ) andY:( currentpiece.by )] &&
				[self unitmapIsEmptyAtX:( currentpiece.cx + 2 ) andY:( currentpiece.cy + 1 )] &&
				[self unitmapIsEmptyAtX:( currentpiece.dx - 1 ) andY:( currentpiece.dy )] && 
				(currentpiece.cx + 2) <= (total_columns - 1) )
			{
				currentpiece.ay = currentpiece.ay - 1;
				currentpiece.bx = currentpiece.bx + 1;
				currentpiece.cx = currentpiece.cx + 2;
				currentpiece.cy = currentpiece.cy + 1;
				currentpiece.dx = currentpiece.dx - 1;
				rotatedcount = 0;
			}
			// if we're up against something on the right, lets check 1 space to the left
			else if ( [self unitmapIsEmptyAtX:( currentpiece.ax - 1 ) andY:( currentpiece.ay - 1 )] && 
					 [self unitmapIsEmptyAtX:( currentpiece.bx ) andY:( currentpiece.by )] &&
					 [self unitmapIsEmptyAtX:( currentpiece.cx + 1 ) andY:( currentpiece.cy + 1 )] &&
					 [self unitmapIsEmptyAtX:( currentpiece.dx - 2 ) andY:( currentpiece.dy )])
			{
				currentpiece.ax = currentpiece.ax - 1;
				currentpiece.ay = currentpiece.ay - 1;
				currentpiece.cx = currentpiece.cx + 1;
				currentpiece.cy = currentpiece.cy + 1;
				currentpiece.dx = currentpiece.dx - 2;
				rotatedcount = 0;
			}
		}
	}
	else if (piecetype == PIECE_TYPE_SQUARE) // "square"
	{
		if (rotatedcount == 0)
		{
			currentpiece.ax = currentpiece.ax + 1;
			currentpiece.by = currentpiece.by - 1;
			currentpiece.cx = currentpiece.cx - 1;
			currentpiece.dy = currentpiece.dy + 1;
			rotatedcount++;
		}
		else if (rotatedcount == 1)
		{
			currentpiece.ay = currentpiece.ay + 1;
			currentpiece.bx = currentpiece.bx + 1;
			currentpiece.cy = currentpiece.cy - 1;
			currentpiece.dx = currentpiece.dx - 1;
			rotatedcount++;
		}
		else if (rotatedcount == 2)
		{
			currentpiece.ax = currentpiece.ax - 1;
			currentpiece.by = currentpiece.by + 1;
			currentpiece.cx = currentpiece.cx + 1;
			currentpiece.dy = currentpiece.dy - 1;
			rotatedcount++;
		}
		else if (rotatedcount == 3)
		{
			currentpiece.ay = currentpiece.ay - 1;
			currentpiece.bx = currentpiece.bx - 1;
			currentpiece.cy = currentpiece.cy + 1;
			currentpiece.dx = currentpiece.dx + 1;
			rotatedcount = 0;
		}
	}
	else if (piecetype == PIECE_TYPE_S) // "S"
	{
		if (rotatedcount == 0)
		{
			if ( [self unitmapIsEmptyAtX:( currentpiece.ax + 1 ) andY:( currentpiece.ay - 1 )] && 
				[self unitmapIsEmptyAtX:( currentpiece.cx + 1 ) andY:( currentpiece.cy + 1 )] &&
				[self unitmapIsEmptyAtX:( currentpiece.dx ) andY:( currentpiece.dy + 2 )] &&
				(currentpiece.dy + 2) < total_rows )
			{
				currentpiece.ax = currentpiece.ax + 1;
				currentpiece.ay = currentpiece.ay - 1;
				currentpiece.cx = currentpiece.cx + 1;
				currentpiece.cy = currentpiece.cy + 1;
				currentpiece.dy = currentpiece.dy + 2;
				rotatedcount++;
			}
		}
		else if (rotatedcount == 1)
		{
			if ( [self unitmapIsEmptyAtX:( currentpiece.ax + 1 ) andY:( currentpiece.ay + 1 )] && 
				[self unitmapIsEmptyAtX:( currentpiece.cx - 1 ) andY:( currentpiece.cy + 1 )] &&
				[self unitmapIsEmptyAtX:( currentpiece.dx - 2 ) andY:( currentpiece.dy )] &&
				(currentpiece.dx - 2) >= 0 )
			{
				currentpiece.ax = currentpiece.ax + 1;
				currentpiece.ay = currentpiece.ay + 1;
				currentpiece.cx = currentpiece.cx - 1;
				currentpiece.cy = currentpiece.cy + 1;
				currentpiece.dx = currentpiece.dx - 2;
				rotatedcount++;
			}
			else if ( [self unitmapIsEmptyAtX:( currentpiece.ax + 2 ) andY:( currentpiece.ay + 1 )] && 
					 [self unitmapIsEmptyAtX:( currentpiece.bx + 1 ) andY:( currentpiece.by )] &&
					 [self unitmapIsEmptyAtX:( currentpiece.cx ) andY:( currentpiece.cy + 1 )] &&
					 [self unitmapIsEmptyAtX:( currentpiece.dx - 1 ) andY:( currentpiece.dy )] &&
					 (currentpiece.dx - 1) >= 0 )
			{
				currentpiece.ax = currentpiece.ax + 2;
				currentpiece.ay = currentpiece.ay + 1;
				currentpiece.bx = currentpiece.bx + 1;
				currentpiece.cy = currentpiece.cy + 1;
				currentpiece.dx = currentpiece.dx - 1;
				rotatedcount++;
			}
		}
		else if (rotatedcount == 2)
		{
			if ( [self unitmapIsEmptyAtX:( currentpiece.ax - 1 ) andY:( currentpiece.ay + 1 )] && 
				[self unitmapIsEmptyAtX:( currentpiece.cx - 1 ) andY:( currentpiece.cy - 1 )] &&
				[self unitmapIsEmptyAtX:( currentpiece.dx ) andY:( currentpiece.dy - 2 )])
			{
				currentpiece.ax = currentpiece.ax - 1;
				currentpiece.ay = currentpiece.ay + 1;
				currentpiece.cx = currentpiece.cx - 1;
				currentpiece.cy = currentpiece.cy - 1;
				currentpiece.dy = currentpiece.dy - 2;
				rotatedcount++;
			}
		}
		else if (rotatedcount == 3)
		{
			if ( [self unitmapIsEmptyAtX:( currentpiece.ax - 1 ) andY:( currentpiece.ay - 1 )] && 
				[self unitmapIsEmptyAtX:( currentpiece.cx + 1 ) andY:( currentpiece.cy - 1 )] &&
				[self unitmapIsEmptyAtX:( currentpiece.dx + 2 ) andY:( currentpiece.dy )] &&
				(currentpiece.dx + 2) <= (total_columns - 1) )
			{
				currentpiece.ax = currentpiece.ax - 1;
				currentpiece.ay = currentpiece.ay - 1;
				currentpiece.cx = currentpiece.cx + 1;
				currentpiece.cy = currentpiece.cy - 1;
				currentpiece.dx = currentpiece.dx + 2;
				rotatedcount = 0;
			}
			else if ( [self unitmapIsEmptyAtX:( currentpiece.ax - 2 ) andY:( currentpiece.ay - 1 )] && 
					 [self unitmapIsEmptyAtX:( currentpiece.bx - 1 ) andY:( currentpiece.by )] &&
					 [self unitmapIsEmptyAtX:( currentpiece.cx ) andY:( currentpiece.cy - 1 )] &&
					 [self unitmapIsEmptyAtX:( currentpiece.dx + 1 ) andY:( currentpiece.dy )] &&
					 (currentpiece.dx + 1) <= (total_columns - 1) )
			{
				currentpiece.ax = currentpiece.ax - 2;
				currentpiece.ay = currentpiece.ay - 1;
				currentpiece.bx = currentpiece.bx - 1;
				currentpiece.cy = currentpiece.cy - 1;
				currentpiece.dx = currentpiece.dx + 1;
				rotatedcount = 0;
			}
		}
	}
	else if (piecetype == PIECE_TYPE_Z)  // "Z"
	{
		if (rotatedcount == 0)
		{
			if ( [self unitmapIsEmptyAtX:( currentpiece.ax + 2 ) andY:( currentpiece.ay )] && 
				[self unitmapIsEmptyAtX:( currentpiece.bx + 1 ) andY:( currentpiece.by + 1 )] && 
				[self unitmapIsEmptyAtX:( currentpiece.dx - 1 ) andY:( currentpiece.dy + 1 )] &&
				(currentpiece.dy + 1) < total_rows )
			{
				currentpiece.ax = currentpiece.ax + 2;
				currentpiece.bx = currentpiece.bx + 1;
				currentpiece.by = currentpiece.by + 1;
				currentpiece.dx = currentpiece.dx - 1;
				currentpiece.dy = currentpiece.dy + 1;
				rotatedcount++;
			}
		}
		else if (rotatedcount == 1)
		{
			if ( [self unitmapIsEmptyAtX:( currentpiece.ax ) andY:( currentpiece.ay + 2 )] && 
				[self unitmapIsEmptyAtX:( currentpiece.bx - 1 ) andY:( currentpiece.by + 1 )] && 
				[self unitmapIsEmptyAtX:( currentpiece.dx - 1 ) andY:( currentpiece.dy - 1 )] && 
				(currentpiece.dx - 1) >= 0 )
			{
				currentpiece.ay = currentpiece.ay + 2;
				currentpiece.bx = currentpiece.bx - 1;
				currentpiece.by = currentpiece.by + 1;
				currentpiece.dx = currentpiece.dx - 1;
				currentpiece.dy = currentpiece.dy - 1;
				rotatedcount++;
			}
			else if ( [self unitmapIsEmptyAtX:( currentpiece.ax + 1 ) andY:( currentpiece.ay + 2 )] && 
					 [self unitmapIsEmptyAtX:( currentpiece.bx ) andY:( currentpiece.by + 1 )] && 
					 [self unitmapIsEmptyAtX:( currentpiece.cx + 1 ) andY:( currentpiece.cy )] &&
					 [self unitmapIsEmptyAtX:( currentpiece.dx ) andY:( currentpiece.dy - 1 )] && 
					 currentpiece.dx >= 0 &&
					 (currentpiece.ax + 1) < total_columns )
			{
				currentpiece.ax = currentpiece.ax + 1;
				currentpiece.ay = currentpiece.ay + 2;
				currentpiece.by = currentpiece.by + 1;
				currentpiece.cx = currentpiece.cx + 1;
				currentpiece.dy = currentpiece.dy - 1;
				rotatedcount++;
			}
		}
		else if (rotatedcount == 2)
		{
			if ( [self unitmapIsEmptyAtX:( currentpiece.ax - 2 ) andY:( currentpiece.ay )] && 
				[self unitmapIsEmptyAtX:( currentpiece.bx - 1 ) andY:( currentpiece.by - 1 )] && 
				[self unitmapIsEmptyAtX:( currentpiece.dx + 1 ) andY:( currentpiece.dy - 1 )])
			{
				currentpiece.ax = currentpiece.ax - 2;
				currentpiece.bx = currentpiece.bx - 1;
				currentpiece.by = currentpiece.by - 1;
				currentpiece.dx = currentpiece.dx + 1;
				currentpiece.dy = currentpiece.dy - 1;
				rotatedcount++;
			}
		}
		else if (rotatedcount == 3)
		{
			if ( [self unitmapIsEmptyAtX:( currentpiece.ax ) andY:( currentpiece.ay - 2 )] && 
				[self unitmapIsEmptyAtX:( currentpiece.bx + 1 ) andY:( currentpiece.by - 1 )] && 
				[self unitmapIsEmptyAtX:( currentpiece.dx + 1 ) andY:( currentpiece.dy + 1 )] && 
				(currentpiece.dx + 1) < total_columns)
			{
				currentpiece.ay = currentpiece.ay - 2;
				currentpiece.bx = currentpiece.bx + 1;
				currentpiece.by = currentpiece.by - 1;
				currentpiece.dx = currentpiece.dx + 1;
				currentpiece.dy = currentpiece.dy + 1;
				rotatedcount = 0;
			}
			else if ( [self unitmapIsEmptyAtX:( currentpiece.ax - 1 ) andY:( currentpiece.ay - 2 )] && 
					 [self unitmapIsEmptyAtX:( currentpiece.bx ) andY:( currentpiece.by - 1 )] && 
					 [self unitmapIsEmptyAtX:( currentpiece.cx - 1 ) andY:( currentpiece.cy )] && 
					 [self unitmapIsEmptyAtX:( currentpiece.dx ) andY:( currentpiece.dy + 1 )] &&
					 (currentpiece.ax - 1) >= 0 )
			{
				currentpiece.ax = currentpiece.ax - 1;
				currentpiece.ay = currentpiece.ay - 2;
				currentpiece.by = currentpiece.by - 1;
				currentpiece.cx = currentpiece.cx - 1;
				currentpiece.dy = currentpiece.dy + 1;
				rotatedcount = 0;
			}
		}
	}
	else if (piecetype == PIECE_TYPE_T) // "T"
	{
		if (rotatedcount == 0)
		{
			// rotate around 1
			if ( [self unitmapIsEmptyAtX:( currentpiece.ax + 1 ) andY:( currentpiece.ay - 1 )] && 
				[self unitmapIsEmptyAtX:( currentpiece.cx - 1 ) andY:( currentpiece.cy + 1 )] &&
				[self unitmapIsEmptyAtX:( currentpiece.dx - 1 ) andY:( currentpiece.dy - 1 )])
			{
				currentpiece.ax = currentpiece.ax + 1;
				currentpiece.ay = currentpiece.ay - 1;
				currentpiece.cx = currentpiece.cx - 1;
				currentpiece.cy = currentpiece.cy + 1;
				currentpiece.dx = currentpiece.dx - 1;
				currentpiece.dy = currentpiece.dy - 1;
				rotatedcount++;
			}
		}
		else if (rotatedcount == 1)
		{
			// rotate around 1
			if ( [self unitmapIsEmptyAtX:( currentpiece.ax + 1 ) andY:( currentpiece.ay + 1 )] && 
				[self unitmapIsEmptyAtX:( currentpiece.cx - 1 ) andY:( currentpiece.cy - 1 )] && 
				[self unitmapIsEmptyAtX:( currentpiece.dx + 1 ) andY:( currentpiece.dy - 1 )] &&
				(currentpiece.ax + 1) <= (total_columns - 1) )
			{
				currentpiece.ax = currentpiece.ax + 1;
				currentpiece.ay = currentpiece.ay + 1;
				currentpiece.cx = currentpiece.cx - 1;
				currentpiece.cy = currentpiece.cy - 1;
				currentpiece.dx = currentpiece.dx + 1;
				currentpiece.dy = currentpiece.dy - 1;
				rotatedcount++;
			}
			// if we're against the wall, check one square over
			else if ( (currentpiece.ax + 1) > (total_columns - 1) &&
					 [self unitmapIsEmptyAtX:( currentpiece.ax ) andY:( currentpiece.ay + 1 )] && 
					 [self unitmapIsEmptyAtX:( currentpiece.bx - 1 ) andY:( currentpiece.bx )] &&
					 [self unitmapIsEmptyAtX:( currentpiece.cx - 2 ) andY:( currentpiece.cy - 1 )] && 
					 [self unitmapIsEmptyAtX:( currentpiece.dx ) andY:( currentpiece.dy - 1 )]) 
			{
				currentpiece.ay = currentpiece.ay + 1;
				currentpiece.bx = currentpiece.bx - 1;
				currentpiece.cx = currentpiece.cx - 2;
				currentpiece.cy = currentpiece.cy - 1;
				currentpiece.dy = currentpiece.dy - 1;
				rotatedcount++;
			}
		}
		else if (rotatedcount == 2)
		{
			if ( [self unitmapIsEmptyAtX:( currentpiece.ax - 1 ) andY:( currentpiece.ay + 1 )] &&
				[self unitmapIsEmptyAtX:( currentpiece.cx + 1 ) andY:( currentpiece.cy - 1 )] &&
				[self unitmapIsEmptyAtX:( currentpiece.dx + 1 ) andY:( currentpiece.dy + 1 )] &&
				(currentpiece.ay + 1) < total_rows )
			{
				currentpiece.ax = currentpiece.ax - 1;
				currentpiece.ay = currentpiece.ay + 1;
				currentpiece.cx = currentpiece.cx + 1;
				currentpiece.cy = currentpiece.cy - 1;
				currentpiece.dx = currentpiece.dx + 1;
				currentpiece.dy = currentpiece.dy + 1;
				rotatedcount++;
			}
			// if it fits one square up try that
			else if ( [self unitmapIsEmptyAtX:( currentpiece.ax - 1 ) andY:( currentpiece.ay )] &&
					 [self unitmapIsEmptyAtX:( currentpiece.bx ) andY:( currentpiece.by - 1 )] &&
					 [self unitmapIsEmptyAtX:( currentpiece.cx + 1 ) andY:( currentpiece.cy - 2 )] &&
					 [self unitmapIsEmptyAtX:( currentpiece.dx + 1 ) andY:( currentpiece.dy )]) 
			{
				currentpiece.ax = currentpiece.ax - 1;
				currentpiece.by = currentpiece.by - 1;
				currentpiece.cx = currentpiece.cx + 1;
				currentpiece.cy = currentpiece.cy - 2;
				currentpiece.dx = currentpiece.dx + 1;
				rotatedcount++;
			}
		}
		else
		{
			if ( [self unitmapIsEmptyAtX:( currentpiece.ax - 1 ) andY:( currentpiece.ay - 1 )] &&
				[self unitmapIsEmptyAtX:( currentpiece.cx + 1 ) andY:( currentpiece.cy + 1 )] && 
				[self unitmapIsEmptyAtX:( currentpiece.dx - 1 ) andY:( currentpiece.dy + 1 )] && 
				(currentpiece.ax - 1) >= 0 )
			{
				currentpiece.ax = currentpiece.ax - 1;
				currentpiece.ay = currentpiece.ay - 1;
				currentpiece.cx = currentpiece.cx + 1;
				currentpiece.cy = currentpiece.cy + 1;
				currentpiece.dx = currentpiece.dx - 1;
				currentpiece.dy = currentpiece.dy + 1;
				rotatedcount = 0;
			}
			// try one to the right
			else if ( [self unitmapIsEmptyAtX:( currentpiece.ax ) andY:( currentpiece.ay - 1 )] &&
					 [self unitmapIsEmptyAtX:( currentpiece.bx + 1 ) andY:( currentpiece.by )] &&
					 [self unitmapIsEmptyAtX:( currentpiece.cx + 2 ) andY:( currentpiece.cy + 1 )] &&
					 [self unitmapIsEmptyAtX:( currentpiece.dx ) andY:( currentpiece.dy + 1 )])
			{
				currentpiece.ay = currentpiece.ay - 1;
				currentpiece.bx = currentpiece.bx + 1;
				currentpiece.cx = currentpiece.cx + 2;
				currentpiece.cy = currentpiece.cy + 1;
				currentpiece.dy = currentpiece.dy + 1;
				rotatedcount = 0;
			}
		}
	}
	
}


#pragma mark -
#pragma mark helper/conversion methods

- (BOOL)unitmapIsEmptyAtX:(int)x andY:(int)y
{
	if ( [[unitmap objectAtIndex:y] objectAtIndex:x] == [NSNull null] ) {
		return YES;
	}
	return NO;
}

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
	// default (we should never get here.)
	return PieceCoordMake(0, 0, 1, 0, 2, 0, 3, 0);
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
