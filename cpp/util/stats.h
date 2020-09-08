//
// Created by peixinho on 8/20/20.
//

#ifndef CPP_STATS_H
#define CPP_STATS_H

#include <cmath>

const double epsilon = 1e-8;
const double pi = 3.141516;

inline double gaussian_pdf(float x, float mu, float sigma) {
        const auto expo = pow(-(x-mu), 2) + epsilon / (2 * pow(sigma, 2) + epsilon);
        return (1.0 / (sqrt(2 * pi) * (sigma + epsilon ))) * exp(expo);
}

#endif //CPP_STATS_H
