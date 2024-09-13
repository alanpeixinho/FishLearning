use image;
use utils;

proc convolution(ref img: Image, const ref kernel) {
    /*var temp = new Image(dtype = img.dtype,*/
            /*height = img.height,*/
            /*width = img.width,*/
            /*channels = img.channels);*/
    var temp = img.clone(false);
    convolution(img.l, kernel, temp.l);
    convolution(img.a, kernel, temp.a);
    convolution(img.b, kernel, temp.b);
    copyImage(temp, img);
}

proc convolution(const ref data: [?ddomain] ?dtype, const ref kernel,
        ref conv: [ddomain] dtype) {
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
}

