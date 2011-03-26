/*
 *  GameModel.h
 *
 *  Generic game object.
 *
 *  Created by Martin Grider
 */
// - ------------------------------------------------------------------------------------------ - //
#ifndef __GameModel_H__
#define __GameModel_H__
// - ------------------------------------------------------------------------------------------ - //

#include <string>


class GameModel {

	// properties
	public:

		bool 			debug;
		bool			is_paused;
		bool			is_game_over;
		int				framecount;
		GameMode		game_mode;

	// methods
	public:

		GameModel( );		//constructor	
		~GameModel( );		//destructor

		void work();
		void start_game( );
		void pause_game( );
		void unpause_game( );

	private:

};


// -------------------------------------------------------------------------- //
#endif // __GameModel_H__ //
// -------------------------------------------------------------------------- //
