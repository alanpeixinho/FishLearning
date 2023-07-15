private use IO.FormattedIO;
private use BitOps;
private use utils;

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

private proc emptyImage(type dtype: numeric) {
    var img: [0..#0, 0..#0, 0..#0] dtype;
    return img;
}

private proc getColorType(channels) throws {
    select channels {
        when 1 do return PNG_COLOR_TYPE_GRAY;
        when 2 do return PNG_COLOR_TYPE_GRAY | PNG_COLOR_MASK_ALPHA;
        when 3 do return PNG_COLOR_MASK_COLOR;
        when 4 do return PNG_COLOR_MASK_COLOR | PNG_COLOR_MASK_ALPHA;
        otherwise do throw new Error("WTF bro, what the hell, the image has channels: %i"
                .format(channels));
    };
}

private proc numChannels(colorType: uint(32)) {
    var channels = 1;
    if colorType & PNG_COLOR_MASK_COLOR {
        channels = 3;
    }
    if colorType & PNG_COLOR_MASK_ALPHA {
        channels += 1;
    }
    return channels;
}

proc writePng(filepath: string, img: [] ?dtype)
    where img.domain.rank == 3 && numBits(dtype) <= 16 {
    const (height, width, channels) = img.shape;

    var pngFile = fopen(filepath.c_str(), "wb");
    if !pngFile then return;

    var png = png_create_write_struct(LIBPNG_VERSION.c_str(), nil, nil, nil);
    if !png then return;

    var info = png_create_info_struct(png);
    if !info then return;

    const colorType = getColorType(channels);
    const bitdepth: int(32) = numBits(dtype);
    const bytedepth: int(32) = bitdepth / 8;

    png_init_io(png, pngFile);

    png_set_IHDR(png, info,
            width: uint(32), height: uint(32),
            bitdepth, colorType,
            PNG_INTERLACE_NONE,
            PNG_COMPRESSION_TYPE_DEFAULT,
            PNG_FILTER_TYPE_DEFAULT
            );
    png_write_info(png, info);

    var rows = c_malloc(c_ptr(c_uchar), height);
    const rowSize = png_get_rowbytes(png, info);

    for row in 0..#height {
        rows[row] = c_malloc(c_uchar, rowSize);
    }

    for (y, x) in {0..#height, 0..#width} {
        const pixel = rows[y] + (x * channels * bytedepth);
        for c in 0..#channels {
            for b in 0..#bytedepth {
                pixel[c*bytedepth+b] = (img[y,x,c] >> b*8): uint(8);
            }
        }
    }

    png_write_image(png, rows);
    png_write_end(png, nil);

    for row in 0..#height {
        c_free(rows[row]);
    }
    c_free(rows);

    fclose(pngFile);
    png_destroy_write_struct(c_ptrTo(png), c_ptrTo(info));
}

proc readPng(filepath: string, type dtype: numeric) {

    var pngFile = fopen(filepath.c_str(), "rb");
    if !pngFile then return emptyImage(dtype);

    var png = png_create_read_struct(LIBPNG_VERSION.c_str(), nil, nil, nil);
    if !png then return emptyImage(dtype);

    var info = png_create_info_struct(png);
    if !info then return emptyImage(dtype);

    png_init_io(png, pngFile);
    png_read_info(png, info);

    const width = png_get_image_width(png, info);
    const height = png_get_image_height(png, info);
    const colorType = png_get_color_type(png, info);
    const bitdepth = png_get_bit_depth(png, info);
    const channels = numChannels(colorType);
    const bytedepth = bitdepth / 8;

    var rows = c_malloc(c_ptr(c_uchar), height);
    const rowSize = png_get_rowbytes(png, info);

    for row in 0..#height {
        rows[row] = c_malloc(c_uchar, rowSize);
    }

    png_read_image(png, rows);

    var img: [0..#height, 0..#width, 0..#channels] dtype;
    for (y, x) in {0..#height, 0..#width} {
        const pixel = rows[y] + (x * channels * bytedepth);
        for c in 0..#channels {
            var val: dtype = 0;
            for b in 0..#bytedepth {
                val |= (pixel[c*bytedepth + b]: dtype) << 8*b;
            }
            img[y,x,c] = val;
        }
    }

    for row in 0..#height {
        c_free(rows[row]);
    }
    c_free(rows);

    fclose(pngFile);
    png_destroy_read_struct(c_ptrTo(png), c_ptrTo(info), nil);

    return img;
}
