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


typedef enum {
	GAME_MODE_NORMAL,
	GAME_MODE_EASY,
	GAME_MODE_HARD,
} GameMode;

typedef enum {
	GAME_SCREEN_SPLASH,
	GAME_SCREEN_MENU,
	GAME_SCREEN_SETUP,
	GAME_SCREEN_PLAY,
	GAME_SCREEN_PLAY_END,
	GAME_SCREEN_ENTRY,
	GAME_SCREEN_PAUSE,
	GAME_SCREEN_HELP,
	GAME_SCREEN_END,
	GAME_SCREEN_ANSWER
} GameScreen;

typedef enum {
	DEVICE_TYPE_IPHONE,
	DEVICE_TYPE_IPAD,
} DeviceTypes;


class GameModel {

	// properties
	public:

		bool 			debug;
		int				framecount;
		GameMode		game_mode;
		GameScreen		current_screen;
		DeviceTypes		device_type;

	// methods
	public:

		GameModel( );		//constructor	
		~GameModel( );		//destructor

		void draw();
		void work();
		void pause_game( );

		// getters and setters
		void set_game_mode( GameMode mode );
		void set_current_screen( GameScreen screen );
		void set_game_difficulty( GameMode difficulty );
		void set_device_type( DeviceTypes type );

		bool supports_portrait_orientation();
		bool supports_landscape_orientation();

	private:

};


// -------------------------------------------------------------------------- //
#endif // __GameModel_H__ //
// -------------------------------------------------------------------------- //
