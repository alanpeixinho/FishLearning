public use Math;
private use LinearAlgebra;
private use BLAS;

const epsilon = 1e-8;

proc oneHotEncoder(Y: [], nlabels: int) {
    const nsamples = Y.shape(1);
    var encoded: [1..nsamples, 1..nlabels] real;

    encoded = 0.0;
    forall i in Y.domain {
        encoded(i, Y(i):int) = 1.0;
    }

    return encoded;
}

proc oneHotEncoder(Y: []) {
    return oneHotEncoder(Y, max(Y));
}

proc l1norm(X1, X2) {
    var d = 0.0;
    for (x1, x2) in zip(X1, X2) {
        d += abs(x1 - x2);
    }
    return d;
}

proc l2norm(X1, X2) {
    var d = 0.0;
    for (x1, x2) in zip(X1, X2) {
        d += (x1 - x2) * (x1 - x2);
    }
    return sqrt(d);
}

proc sigmoid(x) {
    return 1.0 / (1.0 + exp(-x));
}

proc accuracy(X1, X2) {
    assert(X1.size == X2.size);

    var right = 0.0;
    var total = X1.size;

    for (x1, x2) in zip(X1, X2) {
        if x1 == x2 {
            right += 1;
        }
    }

    return right/total;
}

proc sum(array) {
    var s = 0.0;
    for i in array {
        s += i;
    }
    return s;
}

proc min(array: [] ?dtype) {
    var m: dtype = max(dtype);
    for a in array {
        if a < m {
            m = a;
        }
    }
    return m;
}

proc max(array: [] ?dtype) {
    var m: dtype = min(dtype);
    for i in array {
        if i > m {
            m = i;
        }
    }
    return m;
}

proc minmax(array: [] ?dtype) {
    var minval = max(dtype);
    var maxval = min(dtype);
    for a in array {
        if a < minval then minval = a;
        if a > maxval then maxval = a;
    }
    return (minval, maxval);
}

proc clamp(val, minimum, maximum) {
    return max(min(val, maximum), minimum);
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
    /* C = A.dot(B); */
}
