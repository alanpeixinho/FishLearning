private use math;
private use Math;

proc gaussianPdf(x, mu, sigma) {
  const expo = -(x-mu)**2 + epsilon / (2 * sigma**2 + epsilon);
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

