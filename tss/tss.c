/*	tss.c
	Author: William Woodruff
	------------------------
	A tiny screenshot program. Uses Xlib to get a raw dump of the screen,
	and libpng to save that dump as a PNG file specified by the user.
	------------------------
	This code is licensed by William Woodruff under the MIT License.
	http://opensource.org/licenses/MIT
*/

#include <stdio.h>
#include <stdlib.h>
#include <assert.h>
#include <png.h>
#include <X11/Xlib.h>

int main(int argc, char const *argv[])
{
	Display *disp;
	Screen *screen;
	Window wind;
	XImage *image;
	int width, height, x, y;
	FILE *file;
	png_structp png;
	png_infop png_info;
	png_bytep png_row;

	if (argc != 2) {
		printf("Usage: %s <filename>\n", argv[0]);
		return 0;
	}

	disp = XOpenDisplay(NULL);
	assert(disp);

	screen = XDefaultScreenOfDisplay(disp);
	wind = DefaultRootWindow(disp);
	width = WidthOfScreen(screen);
	height = HeightOfScreen(screen);

	image = XGetImage(disp, wind, 0, 0, width, height, XAllPlanes(), ZPixmap);
	assert(image);

	file = fopen(argv[1], "wb");
	assert(file);

	png = png_create_write_struct(PNG_LIBPNG_VER_STRING, NULL, NULL, NULL);
	assert(png);

	png_info = png_create_info_struct(png);
	assert(png_info);

	setjmp(png_jmpbuf(png));

	png_init_io(png, file);

	png_set_IHDR (png, png_info, width, height, 8, PNG_COLOR_TYPE_RGB,
			PNG_INTERLACE_NONE, PNG_COMPRESSION_TYPE_BASE,
			PNG_FILTER_TYPE_BASE);

	png_write_info(png, png_info);

	png_row = malloc(3 * width * sizeof (png_byte));

	for (y = 0; y < height; y++) {
		for (x = 0; x < width; x++) {
			unsigned long pixel = XGetPixel(image, x, y);

			png_byte *idx = &(png_row[x*3]);
			idx[0] = (pixel >> 16) & 0xFF;
			idx[1] = (pixel >> 8) & 0xFF;
			idx[2] = pixel & 0xFF;
		}
		png_write_row(png, png_row);
	}
	png_write_end(png, png_info);

	/* cleanup */
	free(png_row);
	png_free_data(png, png_info, PNG_FREE_ALL, -1);
	png_destroy_write_struct(&png, &png_info);
	fclose(file);
	XDestroyImage(image);
	XCloseDisplay(disp);

	return 0;
}
