//
// Created by peixinho on 7/25/20.
//

#ifndef CPP_NAIVE_BAYES_H
#define CPP_NAIVE_BAYES_H

#include "util/array.h"

class naive_bayes {

    int m, n, c;

    //global feature model
    array<float> mu;//n_feats
    array<float> sigma;//n_feats

    //classes feature model
    matrix<float> mu_c;//c,n
    matrix<float> sigma_c;//c,n

    array<float> p_class;//c


public:
    void train(const matrix <float>& X, const array<int> &Y);
    int predict(const array<float> &x);

    naive_bayes(int m, int n, int c): mu(n), sigma(n), mu_c(c, n), sigma_c(c, n), p_class(c) {
        std::cerr << "naive bayes ctor" << endl;
    }

    ~naive_bayes() {
        std::cerr << "naive bayes ctor" << endl ;
    }
};

#endif //CPP_NAIVE_BAYES_H
