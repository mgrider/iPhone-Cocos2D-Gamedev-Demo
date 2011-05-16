//
//  button.h
//  Classroom Demo
//
//  Created by Nick Pannuto on 2/10/10.
//  Copyright 2010 Sneakyness, llc.. All rights reserved.
//

#import "cocos2d.h"


@protocol SneakyButtonDelegate

@optional

- (void)sneakyButtonPressed;

@end



@interface SneakyButton : CCNode <CCTargetedTouchDelegate> {
	CGPoint center;
	
	float radius;
	float radiusSq;
	
	CGRect bounds;
	BOOL active;
	BOOL status;
	BOOL value;
	BOOL isHoldable;
	BOOL isToggleable;
	float rateLimit;
	
	id<SneakyButtonDelegate> delegate;
}

@property (nonatomic, assign) BOOL status;
@property (nonatomic, readonly) BOOL value;
@property (nonatomic, readonly) BOOL active;
@property (nonatomic, assign) BOOL isHoldable;
@property (nonatomic, assign) BOOL isToggleable;
@property (nonatomic, assign) float rateLimit;
@property (nonatomic, retain) id<SneakyButtonDelegate> delegate;

//Optimizations (keep Squared values of all radii for faster calculations) (updated internally when changing radii)
@property (nonatomic, assign) float radius;

-(id)initWithRect:(CGRect)rect;

@end
