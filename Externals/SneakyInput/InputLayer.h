//
//  HelloWorldLayer.h
//  SneakyInput 0.4.0
//
//  Created by Nick Pannuto on 12/3/10.
//  Copyright Sneakyness, llc. 2010. All rights reserved.
//


// When you import this file, you import all the cocos2d classes
#import "cocos2d.h"

@class SneakyJoystick;
@class SneakyButton;
@class TetrisDemoLayer;

// HelloWorld Layer
@interface InputLayer : CCLayer <CCTargetedTouchDelegate>
{
	CGPoint touchStartPoint;
	CGPoint touchComparePoint;
	TetrisDemoLayer *controllerLayer;

	SneakyJoystick *leftJoystick;
	SneakyButton *rightButton;
}


@property (nonatomic) CGPoint touchStartPoint;
@property (nonatomic) CGPoint touchComparePoint;
@property (nonatomic, retain) TetrisDemoLayer *controllerLayer;
@property (nonatomic, retain) SneakyJoystick *leftJoystick;
@property (nonatomic, retain) SneakyButton *rightButton;


// returns a Scene that contains the HelloWorld as the only child
+(id) scene;


@end
