/*
 *  TetrisDemoGameModel.h
 *
 *  Game object for a Tetris in Cocos2D demo.
 *
 *  Created by Martin Grider
 */
// - ------------------------------------------------------------------------------------------ - //
#ifndef __TetrisDemoGameModel_H__
#define __TetrisDemoGameModel_H__
// - ------------------------------------------------------------------------------------------ - //

#include <string>


typedef enum {
	GAME_MODE_NORMAL,
	GAME_MODE_EASY,
	GAME_MODE_HARD,
} GameMode;


class TetrisDemoGameModel {

	// properties
	public:

		bool 			debug;
		bool			is_paused;
		bool			is_game_over;
		int				framecount;
		GameMode		game_mode;

	// methods
	public:

		TetrisDemoGameModel( );		//constructor	
		~TetrisDemoGameModel( );		//destructor

		void work();
		void start_game( );
		void pause_game( );
		void unpause_game( );

		// getters and setters
		void set_game_mode( GameMode mode );
		void set_game_difficulty( GameMode difficulty );

	private:

};


// -------------------------------------------------------------------------- //
#endif // __TetrisDemoGameModel_H__ //
// -------------------------------------------------------------------------- //
