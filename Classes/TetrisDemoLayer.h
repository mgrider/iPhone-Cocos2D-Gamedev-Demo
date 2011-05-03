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


// TetrisDemoLayer
@interface TetrisDemoLayer : CCLayer
{
	TetrisDemoGameModel *gameModel;
	CCLabelTTF *levelLabel;
	CCLabelTTF *scoreLabel;
	
	CCSpriteBatchNode *blockSheet;
	CCSprite *block1;
	CCSprite *block2;
	CCSprite *block3;
	CCSprite *block4;
	
	PieceType previous_current_piecetype;
}


@property (nonatomic, retain) CCSpriteBatchNode *blockSheet;
@property (nonatomic, retain) TetrisDemoGameModel *gameModel;
@property (nonatomic, assign) PieceType previous_current_piecetype;


// returns a CCScene that contains the TetrisDemoLayer as the only child
+(CCScene *)scene;

- (void)startGame;
- (void)drawUnits;
- (void)drawCurrentPiece;
- (CGRect)pieceRectForType:(PieceType)type;


@end
