use Math;
use stats;

proc squareKernel(size: int, fill: real = 1.0) {
    const halfSize = size/2;
    var kernel: [0..0, -halfSize..halfSize, -halfSize..halfSize] real = fill;
    return kernel;
}

proc circleKernel(radius: int, fill: real = 1.0) {
    const squareDomain = {0..0, -radius..radius, -radius..radius};
    var kernel: [squareDomain] real = fill;
    for (_, y, x) in squareDomain {
        if sqrt(x*x + y*y) <= radius {
            kernel[0, y, x] = fill;
        } else {
            kernel[0, y, x] = 0;
        }
    }
    return kernel;
}

// sharpen kernel
proc laplacianKernel() {
    var kernel: [0..0, -1..1, -1..1] real = -1;
    kernel[0, 0, 0] = 8;
    return kernel;
}

proc crossKernel(size: int, fill: real = 1.0) {
    const halfSize = size/2;
    var kernel : [0..0, -halfSize..halfSize, -halfSize..halfSize] real;
    for (_, y, x) in kernel.domain {
        kernel[0, y, x] = if y == 0 || x == 0 then fill else 0;
    }

    return kernel;
}

proc gaussianKernel(size: int, sigma: real = 1.0) {
    const halfSize = size/2;
    var kernel: [0..0, -halfSize..halfSize, -halfSize..halfSize] real;
    for (_, y, x) in kernel.domain {
        kernel[0, y, x] = gaussian2Pdf(x, y, sigma=sigma);
    }
    kernel /= (+ reduce kernel);
    return kernel;
}
