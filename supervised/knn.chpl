module knn {

  private use math;

  class KNN {

      var k: int = 3;
      var nfeats: int;
      var nsamples: int;
      var nclasses: int;
      var xDomain: domain(2);
      var yDomain: domain(1);
      var X: [xDomain] real;
      var Y: [yDomain] real;

      proc init(k=3) {
        this.k = k;
      }

      proc train(X: [?DX] real, Y: [?DY] real) where DX.rank == 2 {
        (nsamples, nfeats) = X.shape;
        xDomain = {1..nsamples, 1..nfeats};
        yDomain = {1..nsamples};
        this.X = X;
        this.Y = Y;
        nclasses = (max reduce Y): int;
      }

      proc classify(X: [?DX] real, Y: [?DY] real) where DX.rank == 2 {

        const ntestSamples = X.shape(1);

        forall test in 1..ntestSamples {

          var distNeighbors: [1..k] real = INFINITY;
          var neighbors: [1..k] int;
          var classes: [1..nclasses] int = 0;

          for train in 1..nsamples {

            const dist = l2norm(X(test, ..), this.X(train, ..));
            if dist < distNeighbors(1) {
              distNeighbors(1) = dist;
              neighbors(1) = train;
              //sort the k closest neighbors
              for neighbor in 2..k {
                if distNeighbors(neighbor-1) < distNeighbors(neighbor) {
                  distNeighbors(neighbor) <=> distNeighbors(neighbor-1);
                  neighbors(neighbor) <=> neighbors(neighbor-1);
                }
              }
            }
          }

          //majority vote class
          for neighbor in 1..k {
            const idx = neighbors(neighbor);
            const classe = this.Y(idx): int;
            classes(classe) += 1;
          }

          Y(test) = argmax(classes);
        }
      }
  }
}
