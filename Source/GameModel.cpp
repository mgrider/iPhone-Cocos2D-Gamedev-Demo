/*
 *  GameModel.cpp
 *
 *  Created by Martin Grider.
 *  Copyright 2010. All rights reserved.
**/

#include <stdio.h>
#include <iostream> //For stdio messaging
#include <sstream> //For formatting strings
#include "GameModel.h"


GameModel::GameModel( ) {

	// set some defaults. These may very well get thrown away.
	this->game_mode   = GAME_MODE_NORMAL;

	this->current_screen = GAME_SCREEN_SPLASH;

	this->set_device_type(DEVICE_TYPE_IPHONE);

}


// we define this here, because otherwise the compiler complains when we call it in our obj-c destructor
GameModel::~GameModel( ) {
}


// this gets called from our loop
void GameModel::work( ) {
	this->framecount++;
}


void GameModel::draw( ) {
	//this->game_draw->render();
}

#pragma mark -
#pragma mark changing the various game state properties

void GameModel::pause_game( ) {
	this->set_current_screen( GAME_SCREEN_PAUSE );
}


#pragma mark -
#pragma mark some setters

void GameModel::set_game_mode( GameMode mode ) {
//	std::cout << "game type is " << mode << std::endl;
	this->game_mode = mode;
}


void GameModel::set_current_screen( GameScreen screen ) {
	this->current_screen = screen;
}


void GameModel::set_game_difficulty( GameMode difficulty ) {
//	std::cout << "difficulty is " << difficulty << std::endl;
	this->game_mode = difficulty;
}


void GameModel::set_device_type( DeviceTypes type ) {
	switch (type) {
		case DEVICE_TYPE_IPAD:
			// set some stuff
			break;
		case DEVICE_TYPE_IPHONE:
		default:
			// set some stuff
			break;
	}
	this->device_type = type;
	// TODO: device type implies the object that we'll use to draw content for each screen.
	// we should be setting (instantiating?) that object here.
}

bool GameModel::supports_portrait_orientation() {
	return false;
}

bool GameModel::supports_landscape_orientation() {
	return true;
}
