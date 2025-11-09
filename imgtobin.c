#include <stdio.h>
#include <SDL2/SDL.h>
#include <SDL2/SDL_image.h>

bool islittlendian()
{
	unsigned int x = 1;
	char *c = (char*)&x;
	return *c == 1;
}

int main(int argc, char* argv[]) 
{
	SDL_Init(SDL_INIT_EVERYTHING);
	SDL_Surface *surf = NULL;
	SDL_Surface *surface = NULL;
	if(argc==2)	surf = IMG_Load(argv[1]);
	else surf = IMG_Load("img.png");
	if(islittlendian())	surface = SDL_ConvertSurfaceFormat(surf,SDL_PIXELFORMAT_BGRA32,0);
	else surface = SDL_ConvertSurfaceFormat(surf,SDL_PIXELFORMAT_RGBA32,0);

	Uint32 *pixels = (Uint32*)surface->pixels;
	int w = surface->w;
	int h = surface->h;

	FILE *f = fopen("pixels.mem", "w");
	fprintf(f, "%06X", pixels[0] & 0x00FFFFFF);
	for (int i = 1; i < w * h; i++) 
	{
		fprintf(f, " %06X", pixels[i] & 0x00FFFFFF);
		if ((i+1) % 8 == 0) fprintf(f, "\n");
	}
	fclose(f);
	SDL_FreeSurface(surf);
	SDL_FreeSurface(surface);
	IMG_Quit();
	SDL_Quit();
	return 0;
}
