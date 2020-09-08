#include <util/array.h>
#include <iostream>
#include <classifier/naive_bayes.h>

int main() {
    matrix<float> m(10,3);
    m(9,2) = 10;
    array<int> y(10);
    naive_bayes clf(10,3,2);

    clf.train(m, y);
    std::cout << "done" << endl;
}
