/*
 *  TetrisDemoGameModel.cpp
 *
 *  Created by Martin Grider.
 *  Copyright 2010. All rights reserved.
**/

#include <stdio.h>
#include <iostream> //For stdio messaging
#include <sstream> //For formatting strings
#include "TetrisDemoGameModel.h"


// C++ init
TetrisDemoGameModel::TetrisDemoGameModel( ) {

	// set some defaults. These may very well get thrown away.
	this->game_mode   = GAME_MODE_NORMAL;
	this->is_paused   = true;
	this->framecount  = 0;

}


// C++ destructor, not technically necessary, but we define this here because otherwise 
// the compiler complains when we call it in our obj-c destructor
TetrisDemoGameModel::~TetrisDemoGameModel( ) {
}


// this gets called from our main game loop
void TetrisDemoGameModel::work( ) {

	if ( this->is_paused ) {
		return;
	}

	// this might be a good place to check the time against some internal variable
	// if too much time has elapsed, we may want to do all the stuff here more than once.

	this->framecount++;

}


void TetrisDemoGameModel::start_game( ) {
	this->is_paused   = true;
	this->framecount  = 0;
}


#pragma mark -
#pragma mark changing the various game state properties

void TetrisDemoGameModel::pause_game( ) {
	this->is_paused = true;
}

void TetrisDemoGameModel::unpause_game( ) {
	this->is_paused = false;
}


#pragma mark -
#pragma mark some setters

void TetrisDemoGameModel::set_game_mode( GameMode mode ) {
//	std::cout << "game type is " << mode << std::endl;
	this->game_mode = mode;
}


// this is just an alias for set_game_mode
void TetrisDemoGameModel::set_game_difficulty( GameMode difficulty ) {
//	std::cout << "difficulty is " << difficulty << std::endl;
	this->set_game_mode( difficulty );
}
