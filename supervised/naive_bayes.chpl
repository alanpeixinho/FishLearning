private use math;
private use stats;
private use utils;

class NaiveBayes {

    var n_train, n_feats, n_classes: int;

    //global feature model
    var mu: [1..n_feats] real;
    var sigma: [1..n_feats] real;

    //classes feature model
    var mu_c: [1..n_classes, 1..n_feats] real;
    var sigma_c: [1..n_classes, 1..n_feats] real;

    var n_train_c: [1..n_classes] int;

    var p_class: [1..n_classes] int;

    proc init(n_train, n_feats, n_classes) {
      this.n_train = n_train;
      this.n_feats = n_feats;
      this.n_classes = n_classes;
    }

    proc train(X, Y) {

      (n_train, n_feats) = X.shape;

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
      forall f in 1..n_feats {
        mu_c(.., f) /= n_train_c;
      }

      //compute standard deviation
      for i in 1..n_train {
        var c = Y(i): int;
        sigma += (X(i, ..) - mu)**2;
        sigma_c(c, ..) += (X(i, ..) - mu_c(c, ..))**2;
      }
      sigma = sqrt(sigma) / n_train;
      forall f in 1..n_feats {
        sigma_c(.., f) /= n_train_c;
      }
      //compute P(class)
      forall c in 1..n_classes {
        p_class(c) = n_train_c(c) / n_train;
      }
    }

    proc classify(X, Y) {

      writeln("-------");
      writeln(mu);
      writeln(sigma);

      var n_test = X.shape(1);

      forall i in 1..n_test {
        var p_data = gaussianPDF(X(i, ..), mu, sigma);
        //compute the joint probability as a product of all independent variables
        //remember: prod(A) = exp(sum(log(A)))
        var p_joint_data = exp(+ reduce(log(p_data)));
        var p_class_given_data: [1..n_classes] real;
        for c in 1..n_classes {
          var p_data_given_class = gaussianPDF(X(i, ..), mu_c(c, ..), sigma_c(c, ..));
          p_class_given_data(c) = p_data_given_class(c) * p_joint_data / p_class(c);
        }

        /* writeln("........");
        writeln(p_class_given_data); */

        Y(i) = argmax(p_class_given_data);
      }

      return Y;
    }

}
