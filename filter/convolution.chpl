use image;

proc convolution(img: Image, kernel) {
    convolution(img.l, kernel);
    convolution(img.a, kernel);
    convolution(img.b, kernel);
}

proc convolution(data: ?dtype, kernel) {
    var conv: dtype;
    const n = + reduce kernel;
    forall (z, y, x) in data.domain {
        var val = 0.0;
        for (kz, ky, kx) in kernel.domain {
            const k = kernel[kz, ky, kx];
            if data.domain.contains(z + kz, y + ky, x + kx) {
                val += k * data[z + kz, y + ky, x + kx];
            }
        }
        conv[z, y, x] = val / n;
    }
    data = conv;
}

