//
//  TetrisDemoLayer.h
//  TetrisDemo
//
//  Created by Martin Grider on 3/26/11.
//  Copyright __MyCompanyName__ 2011. All rights reserved.
//


// When you import this file, you import all the cocos2d classes
#import "cocos2d.h"


// TetrisDemoLayer
@interface TetrisDemoJigglyHello : CCLayer
{
}


- (void)nextFrame:(ccTime)dt;

// returns a CCScene that contains the TetrisDemoLayer as the only child
+(CCScene *) scene;

- (void)back;


@end
