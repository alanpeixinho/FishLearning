extern {
#include <png.h>
}

proc c_str_define(s: c_string): string {
    return (s: string).strip("\"");
}

const LIBPNG_VERSION = c_str_define(PNG_LIBPNG_VER_STRING);

use CTypes;

extern type FILE;
extern proc fopen(filename: c_string, iomode: c_string): c_ptr(FILE);
extern proc fclose(stream: c_ptr(FILE)): c_int;

const EMPTY_IMAGE: [0..0, 0..0, 0..0] uint(8);

proc readPng(filepath: string) {

    writeln("reading the mofo png");

    var pngFile = fopen(filepath.c_str(), "rb");
    if !pngFile then return EMPTY_IMAGE;

    var png = png_create_read_struct(LIBPNG_VERSION.c_str(), nil, nil, nil);
    if !png then return EMPTY_IMAGE;

    var info = png_create_info_struct(png);
    if !info then return EMPTY_IMAGE;

    png_init_io(png, pngFile);
    png_read_info(png, info);
    const width = png_get_image_width(png, info);
    const height = png_get_image_height(png, info);

    const colorType = png_get_color_type(png, info);
    const bitDepth = png_get_bit_depth(png, info);

    if colorType & PNG_COLOR_MASK_COLOR {
        writeln("there is color mofo");
    } else {
        writeln("There is no color life is sad");
    }

    var row_pointers = c_calloc(c_ptr(c_uchar), height);
    const rowSize = png_get_rowbytes(png, info);

    for row in 0..(height-1) {
        row_pointers[row] = malloc(rowSize): c_ptr(c_uchar);
    }

    png_read_image(png, row_pointers);

    var channels = if colorType & PNG_COLOR_MASK_COLOR
        then 3 else 1 : uint(32);

    var img: [0..#height, 0..#width, 0..#channels] uint(8);

    for (y, x) in {0..#height, 0..#width} {
        const pixel = row_pointers[y] + (x * channels);
        for c in 0..#channels {
            img[y, x, c] = pixel[c];
        }
    }

    const s = + reduce img: real / img.size;

    writeln("data: ", s);

    for row in 0..#height {
        free(row_pointers[row]);
    }

    writeln("yeah: ", width, "x", height, " -> ", colorType, " / ", bitDepth);
    fclose(pngFile);
    return img;
}

config const input: string = "input.png";
config const output: string = "output.png";

/*var f = fopen(input.c_str(), "rt");*/

const img = readPng(input);

writeln("file: ", img.domain);
/*if true {*/
/*fclose(f);*/
/*} else {*/
/*writeln("doesnt even exist BRO");*/
/*}*/
