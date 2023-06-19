use Math;
use math;
use png;

class Image {
    const depth: uint(64) = 1;
    const height: uint(64);
    const width: uint(64);

    const color: bool = false;

    var l: [0..#depth, 0..#height, 0..#width] real; // luminance

    // color
    var colorDomain: domain(3);
    var h: [colorDomain] real; // hue
    var c: [colorDomain] real; // chroma

    proc postinit() {
        if color {
            colorDomain = l.domain;
        } else {
            colorDomain = {..#0, ..#0, ..#0};
        }
    }
}

proc writeImage(filepath: string, img: Image) {
    const channels = if img.color then 3 else 1;
    const (height, width) = (img.height, img.width);
    const maxvalue = 65535; // always 16bit
    var data: [0..#height, 0..#width, 0..#channels] uint(16);

    if img.color {
        for (y, x) in {0..#height, 0..#width} {
            const (r, g, b) = hcl2rgb(
                    img.h[0, y, x],
                    img.c[0, y, x],
                    img.l[0, y, x], maxvalue);
            data[y, x, 0] = r: uint(16);
            data[y, x, 1] = g: uint(16);
            data[y, x, 2] = b: uint(16);
        }
    } else {
        for (y, x) in {0..#height, 0..#width} {
            data[y, x, 0] = ((img.l[0, y, x] / 100.0) * maxvalue) : uint(16);
        }
    }
    png.writePng(filepath, data);
}

proc readImage(filepath: string): Image {
    const data = png.readPng(filepath, uint(16));
    const (height, width, channels) = data.shape;

    var img = new Image(1, height, width, color = channels > 1);
    const maxvalue = if max(data) > 255 then 65535 else 255;

    if img.color {
        for (y, x) in {0..#height, 0..#width} {
            const (hue, chroma, luminance) = rgb2hcl(
                    data[y, x, 0], data[y, x, 1], data[y, x, 2], maxvalue);
            img.l[0, y, x] = luminance;
            img.c[0, y, x] = chroma;
            img.h[0, y, x] = hue;
        }
    } else {
        for (y, x) in {0..#height, 0..#width} {
            img.l[0, y, x] = (data[y, x, 0] / maxvalue) * 100.0;
        }
    }

    return img;
}

proc rgb2xyz(red, green, blue, max: real = 255.0): (real, real, real) {
    const r = red / max;
    const g = green / max;
    const b = blue / max;

    const x = 0.4124564 * r + 0.3575761 * g + 0.1804375 * b; // [0, ~0.95047]
    const y = 0.2126729 * r + 0.7151522 * g + 0.072175 * b; // [0, ~1.0]
    const z = 0.0193339 * r + 0.119192 * g + 0.9503041 * b; // [0, 1.08883]

    return (x, y, z);
}

proc xyz2rgb(x: real, y: real, z: real, maxval: real = 255.0): (real, real, real) {
    var r = 3.2406 * x - 1.5372 * y - 0.4986 * z;
    var g = -0.9689 * x + 1.8758 * y + 0.0415 * z;
    var b = 0.0557 * x - 0.2040 * y + 1.0570 * z;

    r = clamp(r, 0.0, 1.0);
    g = clamp(g, 0.0, 1.0);
    b = clamp(b, 0.0, 1.0);

    return (r*maxval, g*maxval, b*maxval);
}

proc xyz2lab(x, y, z): (real, real, real) {

    // reference white point
    const wx = 0.95047;
    const wy = 1.00000;
    const wz = 1.08883;

    var fx = x / wx;
    var fy = y / wy;
    var fz = z / wz;

    const epsilon = 216.0/24389.0;
    const kappa = 24389.0/27.0;

    fx = if fx > epsilon then cbrt(fx) else (kappa * fx + 16.0) / 116.0;
    fy = if fy > epsilon then cbrt(fy) else (kappa * fy + 16.0) / 116.0;
    fz = if fz > epsilon then cbrt(fz) else (kappa * fz + 16.0) / 116.0;

    const l = (116.0 * fy) - 16.0; // [0,100]
    const a = 500.0 * (fx - fy); // ~[-86.1827,98.2343]
    const b = 200.0 * (fy - fz); // ~[-107.86, 94.478] -> and here

    return (l, a, b);
}

proc lab2xyz(l: real, a: real, b: real): (real, real, real) {
    //white reference
    const wx = 0.95047;
    const wy = 1.00000;
    const wz = 1.08883;

    var fy = (16.0 + l) / 116.0;
    var fx = fy + (a / 500.0);
    var fz = fy - (b / 200.0);

    const kappa = 24389.0/27.0;
    const epsilon = 216.0/24389.0;

    const delta = cbrt(epsilon);

    if fx > delta {
        fx = fx ** 3.0;
    } else {
        fx = (116.0 * fx - 16.0)/kappa;
    }

    if fy > delta {
        fy = fy ** 3.0;
    } else {
        fy = (116.0 * fy - 16.0)/kappa;
    }

    if fz > delta {
        fz = fz ** 3.0;
    } else {
        fz = (116.0 * fz - 16.0)/kappa;
    }

    return (fx * wx, fy * wy, fz * wz);

}

proc hcl2lab(h: real, c: real, l: real): (real, real, real) {
    const h_rad = h * pi / 180.0;
    const a = c * cos(h_rad);
    const b = c * sin(h_rad);
    return (l, a, b);
}

proc lab2hcl(l: real, a: real, b: real): (real, real, real) {

    const chroma = sqrt(a ** 2 + b ** 2); // ~[0, 180]
    var hue = atan2(b, a);
    if hue < 0.0 {
        hue += 2*pi;
    }
    hue *= 180.0 / pi; // [0, 360)
    const luma = l; // [0, 100]

    return (hue, chroma, luma);
}

proc rgb2hcl(red, green, blue, maxval: real = 255.0): (real, real, real) {
    const (x, y, z) = rgb2xyz(red, green, blue, maxval);
    const (l, a, b) = xyz2lab(x, y, z);
    return lab2hcl(l, a, b);
}

proc hcl2rgb(hue, chroma, luminance, maxval: real = 255.0): (real, real, real) {
    const (l, a, b) = hcl2lab(hue, chroma, luminance);
    const (x, y, z) = lab2xyz(l, a, b);
    return xyz2rgb(x, y, z, maxval);
}

/*config const input: string;*/

/*const img = readImage(input);*/

/*var minh = 1000.0, maxh = -1000.0, minc = 1000.0, maxc = -1000.0, minl = 1000.0, maxl = -1000.0;*/
/*for (r, g, b) in {0..255, 0..255, 0..255} {*/
/*const (_h, _c, _l) = rgb2hcl(r/1.0, g/1.0, b/1.0);*/
/*const (_r, _g, _b) = hcl2rgb(_h, _c, _l);*/
/*const (h, c, l) = (abs(r-_r), abs(g-_g), abs(b-_b));*/
/*minh = min(h, minh); maxh = max(h, maxh);*/
/*minc = min(c, minc); maxc = max(c, maxc);*/
/*minl = min(l, minl); maxl = max(l, maxl);*/
/*}*/

/*writeln("h: ", minh, " ", maxh);*/
/*writeln("c: ", minc, " ", maxc);*/
/*writeln("l: ", minl, " ", maxl);*/

/*writeln(data.l);*/
/*writeln(img.l[0,0,0]);*/


/*config const r, g, b: uint(8);*/

/*const (x, y, z) = rgb2xyz(r/1.0, g/1.0, b/1.0);*/
/*const (_l, _a, _b) = xyz2lab(x, y, z);*/

/*writeln(x, " ", y, " ", z);*/
/*writeln(_l, " ", _a, " ", _b);*/

/*const (l,a,b) = hcl2lab(img.h[0,0,0], img.c[0,0,0], img.l[0,0,0]);*/
/*writeln(lab2xyz(l,a,b));*/
