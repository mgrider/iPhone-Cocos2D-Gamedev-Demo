//
//  TetrisDemoGameModel.h
//  TetrisDemo
//
//  Created by Martin Grider on 4/12/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef enum {
	PIECE_TYPE_I,
	PIECE_TYPE_J,
	PIECE_TYPE_L,
	PIECE_TYPE_SQUARE,
	PIECE_TYPE_S,
	PIECE_TYPE_Z,
	PIECE_TYPE_T
} PieceType;
CG_INLINE PieceType PieceTypeFromInt(int pInt)
{
	switch (pInt) {
		case 1: return PIECE_TYPE_J;
		case 2: return PIECE_TYPE_L;
		case 3: return PIECE_TYPE_SQUARE;
		case 4: return PIECE_TYPE_S;
		case 5: return PIECE_TYPE_Z;
		case 6: return PIECE_TYPE_T;
		default:
		case 0: return PIECE_TYPE_I;
	}
}

struct PieceCoord {
	int ax; int ay;
	int bx; int by;
	int cx; int cy;
	int dx; int dy;
};
typedef struct PieceCoord PieceCoord;
CG_INLINE PieceCoord PieceCoordMake(int ax, int ay, int bx, int by, int cx, int cy, int dx, int dy)
{
	PieceCoord p; 
	p.ax = ax; p.ay = ay; 
	p.bx = bx; p.by = by;
	p.cx = cx; p.cy = cy;
	p.dx = dx; p.dy = dy;
	return p;
}


@interface TetrisDemoGameModel : NSObject
{

	BOOL is_paused;
	BOOL is_game_over;

	int framecount;
	int level;
	int speed;
	int basespeed;
	int score;
	int rotatedcount;
	int capturedrowcount;
	PieceType piecetype;
	PieceType nextpiecetype;

	// setting up the size of the game board
	int total_rows;
	int total_columns;
	// size of each "square" in pixels
	int unitsize;

	// keeping track of the current piece's coordinates
	PieceCoord currentpiece;

	// keeping track of "units" (squares)
	NSMutableArray *unitmap;
}


@property (nonatomic) BOOL is_paused;
@property (nonatomic) BOOL is_game_over;
@property (nonatomic) int framecount;
@property (nonatomic) int level;
@property (nonatomic) int speed;
@property (nonatomic) int basespeed;
@property (nonatomic) int score;
@property (nonatomic) int rotatedcount;
@property (nonatomic) int capturedrowcount;
@property (nonatomic) PieceType piecetype;
@property (nonatomic) PieceType nextpiecetype;
@property (nonatomic) int total_rows;
@property (nonatomic) int total_columns;
@property (nonatomic) int unitsize;
@property (nonatomic) PieceCoord currentpiece;
@property (nonatomic, retain) NSMutableArray *unitmap;


- (void)startNewGame;
- (void)initNextPiece;
- (void)newPiece;
- (void)gameOver;
- (void)work;
- (void)checkForCompletedRows;
- (void)updateScoreWithInt:(int)new_score;
- (void)checkForNewLevel;
- (void)dropCurrentPiece;
- (void)movePieceLeft;
- (void)movePieceRight;
- (void)rotatePiece;
- (BOOL)unitmapIsEmptyAtX:(int)x andY:(int)y;
- (PieceCoord)pieceCoordinatesFromPieceType:(PieceType)newType;


@end
