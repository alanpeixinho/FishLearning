proc squareKernel(side: int, fill: real = 1.0) {
    const halfSize = side/2;
    var kernel: [0..0, -halfSize..halfSize, -halfSize..halfSize] real;
    for k in kernel do k = fill;
    return kernel;
}
