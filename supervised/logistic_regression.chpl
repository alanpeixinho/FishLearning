private use math;
private use Time;
private use Random;

var t = new Timer();

proc start() {
  t = new Timer();
  t.start();
}

proc elapsed(msg = "time elapsed") {
  t.stop();
  /* writeln(msg, ": ", t.elapsed()); */
}

class LogisticRegression {

  var learningRate = 1e-4;
  var maxIter = 1000;
  var stopCriteria = 1e-12;

  var ntrain, nfeats, nclasses: int;

  var coefDomain: domain(2);
  var coef: [coefDomain] real;

  var biasDomain: domain(1);
  var bias: [biasDomain] real;

  proc train(_X, _Y) {

    nclasses = (max reduce _Y): int;

    (ntrain, nfeats) = _X.shape;
    nfeats += 1;
    var X: [1..ntrain, 1..nfeats] real;

    X(.., 1..nfeats-1) = _X;
    X(.., nfeats) = 1.0;


    start();
    var XT = X.T;
    elapsed("transpose");

    start();
    biasDomain = {1..nfeats};
    coefDomain = {1..nfeats, 1..nclasses};
    var gradient: [coefDomain] real = 0.0;
    var biasGradient: [biasDomain] real = 0.0;
    var prediction: [{1..ntrain, 1..nclasses}] real = 0.0;
    elapsed("aloc");

    var y = oneHotEncoder(_Y, nclasses);

    var prev = INFINITY;

    /* var c: [1..nclasses] real; */

    /* fillRandom(coef); */

    for it in 1..maxIter {

      forward(X, prediction);
      var cost = computeCost(prediction, y);
      backward(XT, y, prediction, gradient); //compute gradient
      coef -= gradient * learningRate; //update weights
      learningRate *= 0.9;

      if abs(prev - cost) < stopCriteria then break;

      prev = cost;
    }
  }

  proc computeCost(prediction, y) {
    var cost = 0.0;

    forall t in 1..ntrain with (+ reduce cost) {
        //add epsilon constant to avoid log(0)
        var c = y(t, ..) * log(prediction(t, ..) + epsilon) +
                (1.0 - y(t, ..)) * log(1.0 - prediction(t, ..) + epsilon);
        cost -= (+ reduce c)/ntrain;
    }

    return cost;
  }


  proc forward(ref X, ref pred) {

    pred = 0.0;
    forall i in 1..ntrain {
        for c in 1..nclasses {
          for j in 1..nfeats {
            pred(i, c) += X(i, j) * coef(j, c);
          }
          pred(i, c) = sigmoid(pred(i, c));
        }
      }
  }

  proc backward(XT, Y, pred, grad) {
    pred -= Y;
    dotProduct(grad, XT, pred);
    /* grad = dot(XT, pred); */
  }

  proc dotProduct(ref C: [?DC], ref A: [?DA], ref B: [?DB])
  where DC.rank == 2 && DA.rank == 2 && DB.rank == 2
{

  forall (row, col) in DC {
    // Zero out the value, in case C is reused.
    C(row, col) = 0;
    for i in DA.dim(2) do
      C(row, col) += A(row, i) * B(i, col);
  }
}

  proc classify(_X, Y) {
    var ntest = _X.shape(1);
        var X: [1..ntest, 1..nfeats] real;

        X(.., 1..nfeats-1) = _X;
        X(.., nfeats) = 1.0;

    var prediction: [{1..ntest, 1..nclasses}] real = 0.0;
    forward(X, prediction);

    forall t in 1..ntest {
      Y(t) = argmax(prediction(t, ..));
    }
  }

}
