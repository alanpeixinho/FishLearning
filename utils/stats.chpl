private use math;

proc gaussianPDF(x, mu, sigma) {
  const expo = -(x-mu)**2 / (2 * sigma**2 + epsilon);
  return (1.0 / (sqrt(2 * pi) * sigma)) * exp(expo);
}
