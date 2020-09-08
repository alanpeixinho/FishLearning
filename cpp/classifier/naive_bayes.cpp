#include <iostream>
#include "naive_bayes.h"
#include "../util/stats.h"
#include <util/array.h>
#include <cmath>

using namespace std;

void naive_bayes::train(const matrix<float> &X, const array<int> &Y) {

    cerr << "comecei" << endl;

    c = max(Y);
    //global features model
    mu = array<float>(X.n);
    sigma = array<float>(X.n);

    mu_c = matrix<float>(c, X.n);
    sigma_c = matrix<float>(c, X.n);

    auto count_c = array<int>(c);

    //init vars
    for (int j = 0; j < X.n; ++j) {
        mu(j) = sigma(j) = 0.0;
        for (int k = 0; k < c; ++k) {
            mu_c(k, j) = sigma_c(k, j) = 0.0;
        }
    }

    for (int i = 0; i < X.m; ++i) {
        int yi = Y(i);
        count_c(yi)++;
        for (int j = 0; j < X.n; ++j) {
            mu(j) += X(i, j);
            mu_c(yi - 1, j) += sigma_c(i, j) = 0.0;
        }
    }

    for (int j = 0; j < X.n; ++j) {
        mu(j) /= X.m;
        for (int k = 0; k < c; ++k) {
            mu_c(k, j) /= count_c(k);
        }
    }

    //compute standard deviation
    for (int i=0; i < X.m; ++i) {
        const int yi = Y(i);
        for (int j = 0; j < X.n; ++j) {
            sigma(j) += pow(X(i, j) - mu(j), 2);
            sigma_c(yi - 1, j) += pow(X(i, j) - mu_c(yi - 1, j), 2);
        }
        sigma(i) = sqrt(sigma(i)/X.m);
    }

    for (int k = 0; k < c; ++k) {
        for (int j = 0; j < X.n; ++j) {
            sigma_c(k, j) = sqrt(sigma_c(k, j)/count_c(k));
        }
    }

    for (int k=0; k < c; ++k) {
      p_class(k) = log(count_c(k) / X.m);
    }

    cerr << "terminei" << endl;

}

int naive_bayes::predict(const array<float> &x) {

    auto p_data = array<float>(x.n);
    float p_joint_data = 0.0;

    auto p_class_given_data = array<float>(c);

    for (int j = 0; j < x.n; ++j) {
        p_data(j) = gaussian_pdf(x(j), mu(j), sigma(j));
        p_joint_data += log(p_data(j));
    }

    float p_joint_data_given_class = 0.0;

    for (int k = 0; k < c; ++k) {
        auto p_data_given_class = array<float>(x.n);
        for (int j = 0; j < x.n; ++j) {
            p_data_given_class(j) = gaussian_pdf(x(j), mu_c(k, j), sigma_c(k, j));
            p_joint_data_given_class += log(p_data_given_class(j));

            float p = p_joint_data_given_class + p_class(c) - p_joint_data;

            p_class_given_data(c) = p;
        }
    }

    return argmax(p_class_given_data) + 1;
}

//
//  void train(matrix<float>& X, array<float>& Y) {
//    c = Y.max();
//
//    //global feature model
//    var mu: [1..n_feats] real;
//    var sigma: [1..n_feats] real;
//
//    //classes feature model
//    var mu_c: [1..n_classes, 1..n_feats] real;
//    var sigma_c: [1..n_classes, 1..n_feats] real;
//
//    auto p_class: [1..n_classes] real;
//
//    var n_train_c: [1..n_classes] int;
//
//    mu = 0.0;
//    sigma = 0.0;
//    sigma_c = 0.0;
//
//    //compute mean
//    for i in 1..n_train {
//      var c = Y(i): int;
//      mu += X(i,..);
//      mu_c(c, ..) += X(i, ..);
//      n_train_c(c) += 1;
//    }
//    mu /= n_train;
//    for f in 1..n_feats {
//      mu_c(.., f) /= n_train_c;
//    }
//
//    //compute standard deviation
//    for i in 1..n_train {
//      var c
//      = Y(i): int;
//      sigma += (X(i, ..) - mu)**2;
//      sigma_c(c, ..) += (X(i, ..) - mu_c(c, ..))**2;
//    }
//
//    sigma = sqrt(sigma / n_train);
//    for f in 1..n_feats {
//      sigma_c(.., f) = sqrt(sigma_c(..,f) / n_train_c);
//    }
//
//    //compute P(class)
//    for c in 1..n_classes {
//      p_class(c) = n_train_c(c): real / n_train;
//    }
//
//    return model(n_train = n_train, n_feats=n_feats,
//                 n_classes=n_classes, mu=mu, sigma=sigma,
//                 mu_c=mu_c,sigma_c=sigma_c,p_class=p_class);
//  }
//
//  int predict(array<float> x) {
//
//
//    /* writeln("-------");
//    writeln("mu = ", classifier.mu);
//    writeln("sigma = ", classifier.sigma);
//
//    for c in 1..classifier.n_classes {
//      writeln("------- ", c);
//      writeln("mu = ", classifier.mu_c(c,..));
//      writeln("sigma = ", classifier.sigma_c(c,..));
//    } */
//
//    var n_test = X.shape(1);
//
//    forall i in 1..n_test {
//      var p_data = gaussianPDF(X(i, ..), classifier.mu, classifier.sigma);
//      //compute the joint probability as a product of all independent variables
//      //remember: prod(A) = exp(sum(log(A)))
//      /* writeln(p_data.shape); */
//      var p_joint_data = sum(log(p_data));
//      /* writeln(X(i,..)); */
//      /* writeln(p_data); */
//      /* writeln(p_joint_data); */
//
//      var p_class_given_data: [1..classifier.n_classes] real;
//
//      forall c in 1..classifier.n_classes {
//        var p_data_given_class = gaussianPDF(X(i, ..), classifier.mu_c(c, ..), classifier.sigma_c(c, ..));
//        var p_joint_data_given_class =  sum(log(p_data_given_class));
//        /* var p_joint_data_given_class =  (* reduce(p_data_given_class)); */
//        /* var p_joint_data_given_class = 1.0;
//        for p in p_data_given_class {
//          p_joint_data_given_class *= p;
//        } */
//        /* writeln(p_data_given_class); */
//        /* writeln(p_joint_data_given_class); */
//        /* writeln(classifier.p_class(c)); */
//        var p = p_joint_data_given_class + log(classifier.p_class(c)) - p_joint_data;
//        /* writeln(p); */
//        p_class_given_data(c) = p;
//      }
//
//      /* writeln("........"); */
//      /* writeln(p_class_given_data); */
//
//      Y(i) = argmax(p_class_given_data);
//    }
//
//    return Y;
//  }
