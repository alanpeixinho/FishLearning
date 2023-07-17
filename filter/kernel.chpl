proc squareKernel(side: int, fill: real = 1.0) {
    const halfSize = side/2;
    var kernel: [0..0, -halfSize..halfSize, -halfSize..halfSize] real;
    kernel = fill;
    return kernel;
}

proc circleKernel(radius: int, fill: real = 1.0) {
    var kernel: [{0..0, -radius..radius, -radius..radius}] real;
    for (_, y, x) in kernel.domain {
        kernel[0, y, x] = if sqrt(x*x + y*y) <= radius
            then fill else 0;
    }
    return kernel;
}
