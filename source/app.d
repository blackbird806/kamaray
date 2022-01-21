import std.stdio;
import bindbc.sdl;
import globals;
import world;

void loadLib() 
{
	import loader = bindbc.loader.sharedlib;
    /*
     Compare the return value of loadSDL with the global `sdlSupport` constant, which is configured at compile time for
     a specific version of SDL.
    */
    auto ret = loadSDL();
    if(ret != sdlSupport) {
        // Log the error info
        foreach(info; loader.errors) {
            /*
             A hypothetical logging function. Note that `info.error` and `info.message` are `const(char)*`, not
             `string`.
            */
            writeln(info.error, info.message);
        }

        // Optionally construct a user-friendly error message for the user
        if(ret == SDLSupport.noLibrary) {
            writeln("This application requires the SDL library.");
        } else {
            writeln("The version of the SDL library on your system is too low. Please upgrade.");
        }
		assert(false);
    }
}

void main()
{
	loadLib();

	//Initialize SDL
	if( SDL_Init( SDL_INIT_VIDEO ) < 0 )
	{
		writeln("failed to init sdl : ", sdlError());
		assert(false);
	}
	scope(exit) SDL_Quit();

	window = SDL_CreateWindow("Kamaray", SDL_WINDOWPOS_UNDEFINED, SDL_WINDOWPOS_UNDEFINED, 800, 520, SDL_WINDOW_SHOWN);
	if (window == null)
	{
		writeln("failed to create window : ", sdlError());
		assert(false);
	}
	scope(exit) SDL_DestroyWindow(window);
	SDL_SetWindowResizable(window, SDL_bool.SDL_TRUE);

	renderer = SDL_CreateRenderer(window, -1, SDL_RENDERER_ACCELERATED);
	if (renderer == null)
	{
		writeln("failed to create renderer : ", sdlError());
		assert(false);
	}
	scope(exit) SDL_DestroyRenderer(renderer);
	SDL_RenderSetLogicalSize(renderer, screenWidth, screenHeight);

	renderTexture = SDL_CreateTexture(renderer, SDL_PIXELFORMAT_RGB888, SDL_TEXTUREACCESS_STREAMING, screenWidth, screenHeight);
	if (renderTexture == null)
	{
		writeln("failed to create renderTexture : ", sdlError());
		assert(false);
	}
	scope(exit) SDL_DestroyTexture(renderTexture);

	bool quit = false;
	SDL_Event e;

	World gameWorld;
	gameWorld.create();

	while(!quit)
	{
		while (SDL_PollEvent(&e) != 0)
		{
			if (e.type == SDL_QUIT)
				quit = true;
			else if( e.type == SDL_KEYDOWN )
            {
				switch(e.key.keysym.sym)
                {
					case SDLK_UP:
					default:
					break;
				}
			}
		}

	  	SDL_SetRenderDrawColor( renderer, 0, 0, 0, 0xFF );
        SDL_RenderClear( renderer );
		SDL_SetRenderDrawColor(renderer, 0xFF, 0xFF, 0xFF, 0xFF);
		gameWorld.draw();
		SDL_RenderPresent( renderer );
	}
}
