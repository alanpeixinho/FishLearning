private use math;
private use Math;

proc gaussianPdf(x: real, mu = 0.0, sigma = 1.0) {
    const expo = -(((x-mu)**2 + epsilon) / (2 * sigma**2 + epsilon));
    return (1.0 / (sqrt(2 * pi) * (sigma + epsilon ))) * exp(expo);
}

proc gaussian2Pdf(x, y, mu_x = 0.0, mu_y = 0.0, sigma = 1.0) {
    const expo = - (((x-mu_x)**2 + (y-mu_y)**2 + epsilon) / (2 * sigma**2 + epsilon));
    return (1.0 / (sqrt(2 * pi) * (sigma + epsilon ))) * exp(expo);
}

proc histogram(data) {
    const (minval, maxval) = math.minmax(data);
    var hist: [minval..maxval] uint(64) = 0;

    for d in data {
        hist[d] += 1;
    }

    return hist;
}
