private use math;

proc gaussianPdf(x, mu, sigma) {
  /*writeln('gaussian start.');
  writeln(x);
  writeln(mu);
  writeln(sigma);
  writeln('gaussian end.');*/
  const expo = -(x-mu)**2 + epsilon / (2 * sigma**2 + epsilon);
  return (1.0 / (sqrt(2 * pi) * (sigma + epsilon ))) * exp(expo);
}
