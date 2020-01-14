
const epsilon = 1e-12;

proc oneHotEncoder(Y: [?D], nlabels: int) {
    const nsamples = Y.shape(1);
    var encoded: [1..nsamples, 1..nlabels] real;

    encoded = 0.0;
    forall i in Y.domain {
        encoded(i, Y(i):int) = 1.0;
    }

    return encoded;
}

proc oneHotEncoder(Y: []) {
  return oneHotEncoder(Y, (max reduce Y): int);
}

proc l1norm(X1, X2) {
  var d = 0.0;
  for (x1, x2) in zip(X1, X2) {
    d += abs(x1 - x2);
  }
  return d;
}

proc l2norm(X1, X2) {
  var d = 0.0;
  for (x1, x2) in zip(X1, X2) {
    d += (x1 - x2) * (x1 - x2);
  }
  return sqrt(d);
}

proc sigmoid(x) {
    return 1.0 / (1.0 + exp(-x));
}

proc accuracy(X1, X2) {
  var right = 0.0;
  var total = X1.size;

  for (x1, x2) in zip(X1, X2) {
    if x1 == x2 {
      right += 1;
    }
  }

  return right/total;
}
