use image;
use utils;

proc convolution(img: Image, kernel) {
    convolution(img.l, kernel);
    convolution(img.a, kernel);
    convolution(img.b, kernel);
}

proc convolution(ref data: [?ddomain] ?dtype, kernel) {
    var conv: [ddomain] dtype;
    var n = + reduce kernel;
    if n == 0 then n = 1.0;
    forall (z, y, x) in data.domain {
        var val = 0.0;
        for (kz, ky, kx) in kernel.domain {
            const k = kernel[kz, ky, kx];
            if data.domain.contains(z + kz, y + ky, x + kx) {
                val += k * data[z + kz, y + ky, x + kx];
            }
        }
        conv[z, y, x] = (val / n) : dtype;
    }
    data = conv;
}

