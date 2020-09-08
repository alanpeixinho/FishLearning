//
// Created by peixinho on 7/25/20.
//

#ifndef CPP_ARRAY_H
#define CPP_ARRAY_H

#include <algorithm>
#include <iostream>

using size_t = long unsigned int;

using namespace std;

void* dcalloc(size_t s, size_t p) {
    void* d = calloc(s, p);
    cerr << "alloc: " << d << endl;
    return d;
}

void dfree(void* p) {
    cerr << "free: " << p << endl;
    free(p);
}

template <typename dtype>
class array {
public:
    dtype* data = NULL;
    size_t n = 0;
    bool owned = false;

    array() {
        cerr << "array default ctor" << endl;
    }

    array(size_t _n): n(_n) {
        data = (dtype*) dcalloc(n, sizeof(dtype));
        cerr << "array ctor ";
        cerr << data << endl;
        owned = true;
    }

    array(dtype* _data, size_t _n): data(_data), n(_n) {
        owned = false;
    }

    ~array() {
        cerr << "array dtor ";
        cerr << data << endl;
        if (owned && data != NULL)
            dfree(data);
        data = nullptr;
    }

    dtype& operator()(size_t i) {
        return data[i];
    }

    const dtype& operator()(size_t i) const {
        return data[i];
    }
};

template <typename dtype>
class matrix {
public:
    dtype* data = NULL;
    size_t m = 0, n = 0;

    matrix() {
        cerr << "dmatrix default ctor" << endl;
    }

    matrix(size_t _m, size_t _n): m(_m), n(_n) {
        data = (dtype*) dcalloc(m*n, sizeof(dtype));
        cerr << "matrix ctor ";
        cerr << data << endl;
    }

    ~matrix() {
        cerr << "matrix dtor ";
        cerr << data << endl;
        if (data != NULL)
            dfree(data);
        data = NULL;
    }

    dtype& operator()(size_t i, size_t j) {
        return data[i*n+j];
    }

    const dtype& operator()(size_t i, size_t j) const {
        return data[i*n+j];
    }

    bool isEmpty() {
        return (m*n)<=0;
    }
};

template <class dtype>
dtype max(const matrix<dtype> &m) {
    return *std::max_element(m.data, m.data + (m.m * m.n));
}

template <class dtype>
dtype max(const array<dtype> &a) {
    return *std::max_element(a.data, a.data + a.n);
}

template <class dtype>
size_t argmax(const array<dtype> &a) {
    size_t imax = 0;
    for (size_t i = 1; i < a.n; ++i) {
        if (a(imax) < a(i)) {
            imax = i;
        }
    }
    return imax;
}

#endif //CPP_ARRAY_H
