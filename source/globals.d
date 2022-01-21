module globals;
import bindbc.sdl;

struct Color
{
	ubyte r, g, b;
}

enum screenWidth = 255;
enum screenHeight = 255;

auto sdlError()
{
	import std.string : fromStringz;
	return fromStringz(SDL_GetError());
}

// Global variables
public	{
	SDL_Window* window;
	SDL_Renderer* renderer;
	SDL_Texture* renderTexture;
}