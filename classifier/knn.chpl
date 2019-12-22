module knn {
use utils;

class KNN {

    var k: int = 3;
    var nfeats: int;
    var nsamples: int;
    var xDomain: domain(2);
    var X: [xDomain] real;

    proc init() {

    }

    proc train(X: [?DX] real, Y: [] real) {
      writeln("hue");
      (nsamples, nfeats) = X.shape;
      xDomain = {1..nsamples, 1..nfeats};
    }
}

}
