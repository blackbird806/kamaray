module world;
import bindbc.sdl;
import globals;
import core.stdc.string : memcpy;

enum CollisionMask : ubyte
{
	None = 0,
	Default = 1
}

enum PixelType
{
	Air,
	Wall
}

enum Color[PixelType] pixelColors = [
	PixelType.Air: Color(0, 0xFF, 0),
	PixelType.Wall: Color(0xFF, 0xFF, 0xFF),
	];

struct World
{
	void create()
	{
		renderBuffer = new Color[screenWidth * screenHeight];
		pixels = new PixelType[screenWidth * screenHeight];
	}
	
	void draw()
	{
		for (uint i = 0; i < renderBuffer.length; i++)
		{
			renderBuffer[i] = pixelColors[pixels[i]];
		}

		void* pix = void;
		int pitch = void;
		const ret = SDL_LockTexture(renderTexture, null, &pix, &pitch);
		debug {
			import std.stdio;
			if (ret != 0)
				writeln("failed to lock renderTexture error: ", sdlError());
		}

		memcpy(pix, cast(void*)renderBuffer, renderBuffer[].sizeof);
		SDL_UnlockTexture(renderTexture);
		SDL_RenderCopy(renderer, renderTexture, null, null);
	}
	
	// https://stackoverflow.com/questions/33304351/sdl2-fast-pixel-manipulation
	// https://stackoverflow.com/questions/20753726/rendering-pixels-from-array-of-rgb-values-in-sdl-1-2/36504803#36504803
	// https://stackoverflow.com/questions/62379457/how-to-draw-a-grid-of-pixels-fast-with-sdl2
	PixelType[] pixels;
	Color[] renderBuffer;
}