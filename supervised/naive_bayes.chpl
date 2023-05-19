private use Math;
private use stats;
private use utils;

class NaiveBayes {

    const n_train, n_feats, n_classes: int;

    //global feature model
    const mu: [1..n_feats] real;
    const sigma: [1..n_feats] real;

    //classes feature model
    const mu_c: [1..n_classes, 1..n_feats] real;
    const sigma_c: [1..n_classes, 1..n_feats] real;

    const p_class: [1..n_classes] real;


    proc predict(x): int {
        var p_data = gaussianPdf(x, mu, sigma);
        var p_joint_data = sum(log(p_data));

        var p_class_given_data: [1..n_classes] real;

        for c in 1..n_classes {
          var p_data_given_class = gaussianPdf(x, mu_c(c, ..), sigma_c(c, ..));
          var p_joint_data_given_class =  sum(log(p_data_given_class));
          var p = p_joint_data_given_class + p_class(c) - p_joint_data;
          p_class_given_data(c) = p;
        }


        return argmax(p_class_given_data);
    }

    proc predict_batch(X): [] int {

      const n_test = X.shape(0);
      var Y: [1..n_test] int;
      forall i in 1..n_test {
          Y(i) = predict(X(i, ..));
      }

      return Y;
    }

}

proc train(X, Y) {

  const (n_train, n_feats) = X.shape;
  const n_classes = max(Y): int(64);

  //global feature model
  var mu: [1..n_feats] real;
  var sigma: [1..n_feats] real;

  //classes feature model
  var mu_c: [1..n_classes, 1..n_feats] real;
  var sigma_c: [1..n_classes, 1..n_feats] real;

  var p_class: [1..n_classes] real;

  var n_train_c: [1..n_classes] int = 0;

  mu = 0.0;
  mu_c = 0.0;
  sigma = 0.0;
  sigma_c = 0.0;

  //compute mean
  for i in 1..n_train {
    var c = Y(i): int;
    mu += X(i,..);
    mu_c(c, ..) += X(i, ..);
    n_train_c(c) += 1;
  }
  mu /= n_train;
  for f in 1..n_feats {
    mu_c(.., f) /= n_train_c;
  }

  //compute standard deviation
  for i in 1..n_train {
    var c = Y(i): int;
    sigma += (X(i, ..) - mu)**2;
    sigma_c(c, ..) += (X(i, ..) - mu_c(c, ..))**2;
  }

  sigma = sqrt(sigma / n_train);
  for f in 1..n_feats {
    sigma_c(.., f) = sqrt(sigma_c(..,f) / n_train_c);
  }

  //compute P(class)
  for c in 1..n_classes {
    p_class(c) = n_train_c(c): real / n_train;
  }

  p_class = log(p_class);

  return new NaiveBayes(n_train = n_train, n_feats=n_feats,
                        n_classes=n_classes, mu=mu, sigma=sigma,
                        mu_c=mu_c,sigma_c=sigma_c,p_class=p_class);
}
