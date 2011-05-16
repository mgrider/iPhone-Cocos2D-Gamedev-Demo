//
//  TetrisDemoLayer.h
//  TetrisDemo
//
//  Created by Martin Grider on 3/26/11.
//  Copyright __MyCompanyName__ 2011. All rights reserved.
//


// When you import this file, you import all the cocos2d classes
#import "cocos2d.h"


#include "TetrisDemoGameModel.h"
#include "InputLayer.h"
#include "SneakyButton.h"
#include "SneakyJoystick.h"


// TetrisDemoLayer
@interface TetrisDemoLayer : CCLayer <SneakyButtonDelegate, SneakyJoystickDPadDelegate>
{
	TetrisDemoGameModel *gameModel;
	CCLabelTTF *levelLabel;
	CCLabelTTF *scoreLabel;
	CCLabelTTF *gameOverLabel;
	CCLabelTTF *gameOverLabel2;
	
	CCSpriteBatchNode *blockSheet;
	CCSprite *block1;
	CCSprite *block2;
	CCSprite *block3;
	CCSprite *block4;
	
	PieceType previous_current_piecetype;
	InputLayer *inputLayer;
}


@property (nonatomic, retain) CCSpriteBatchNode *blockSheet;
@property (nonatomic, retain) TetrisDemoGameModel *gameModel;
@property (nonatomic, assign) PieceType previous_current_piecetype;
@property (nonatomic, retain) InputLayer *inputLayer;


- (void)startGame;
- (void)drawGameOver;
- (void)drawUnits;
- (void)drawCurrentPiece;
- (CGRect)pieceRectForType:(PieceType)type;

// returns a CCScene that contains the TetrisDemoLayer as the only child
+(CCScene *)scene;

// model interactions
- (void)dropCurrentPiece;
- (void)movePieceLeft;
- (void)movePieceRight;
- (void)rotatePieceRight;
- (void)rotatePieceLeft;


@end
