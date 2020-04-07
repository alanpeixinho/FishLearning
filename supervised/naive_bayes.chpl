private use math;
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
}

proc train(X, Y) {

  const (n_train, n_feats) = X.shape;
  const n_classes = (max reduce Y): int(64);

  //global feature model
  var mu: [1..n_feats] real;
  var sigma: [1..n_feats] real;

  //classes feature model
  var mu_c: [1..n_classes, 1..n_feats] real;
  var sigma_c: [1..n_classes, 1..n_feats] real;

  var p_class: [1..n_classes] real;

  var n_train_c: [1..n_classes] int;

  mu = 0.0;
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

  writeln("model");
  writeln(mu);
  writeln(sigma);

  //compute P(class)
  forall c in 1..n_classes {
    p_class(c) = n_train_c(c): real / n_train;
  }

  writeln(p_class);

  return new NaiveBayes(n_train = n_train, n_feats=n_feats,
                        n_classes=n_classes, mu=mu, sigma=sigma,
                        mu_c=mu_c,sigma_c=sigma_c,p_class=p_class);
}

proc classify(classifier: NaiveBayes, X, Y) {


  writeln("-------");
  writeln(classifier.mu);
  writeln(classifier.sigma);

  for c in 1..classifier.n_classes {
    writeln("------- ", c);
    writeln(classifier.mu_c(c,..));
    writeln(classifier.sigma_c(c,..));
  }

  var n_test = X.shape(1);

  writeln("go brrr");
  forall i in 1..n_test {
    var p_data = gaussianPDF(X(i, ..), classifier.mu, classifier.sigma);
    //compute the joint probability as a product of all independent variables
    //remember: prod(A) = exp(sum(log(A)))
    /* writeln(p_data.shape); */
    var p_joint_data = exp(+ reduce(log(p_data)));
    /* writeln(X(i,..)); */
    /* writeln(p_data); */
    /* writeln(p_joint_data); */

    var p_class_given_data: [1..classifier.n_classes] real;
    for c in 1..classifier.n_classes {
      /* writeln("=====", c); */
      /* writeln("mu_c = ", classifier.mu_c(c, ..), " sigma_c = ", classifier.sigma_c(c, ..)); */
      var p_data_given_class = gaussianPDF(X(i, ..), classifier.mu_c(c, ..), classifier.sigma_c(c, ..));
      var p_joint_data_given_class =  exp(+ reduce(log(p_data_given_class)));
      /* writeln(p_data_given_class); */
      /* writeln(p_joint_data_given_class); */
      /* writeln(classifier.p_class(c)); */
      var p = p_joint_data_given_class * classifier.p_class(c) / p_joint_data;
      /* writeln(p); */
      p_class_given_data(c) = p;
    }

    /* writeln("........"); */
    /* writeln(p_class_given_data); */

    Y(i) = argmax(p_class_given_data);
  }

  return Y;
}
