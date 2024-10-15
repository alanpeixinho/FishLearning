private use math;
private use utils;
private use Random;

class LogisticRegression {
    const n_feats, n_classes: int;
    const coef: [1..n_feats, 1..n_classes] real;
    const bias: [1..n_classes] real;
}

proc train(X, Y, learning_rate = 1e-4, max_iter = 10000, stop_criteria = 1e-10) {

    const (n_train, n_feats) = X.shape;
    const n_classes = max(Y): int(64);

    var coef: [1..n_feats, 1..n_classes] real;
    var bias: [1..n_classes] real;

    var gradient: [1..n_feats, 1..n_classes] real;
    var bias_gradient: [1..n_classes] real;

    var Y_pred: [{1..n_train, 1..n_classes}] real;

    var Y_enc = math.oneHotEncoder(Y, n_classes);
    var prev = inf;

    var lr = learning_rate;

    for it in 1..max_iter {

        forward(X, coef, bias, Y_pred);
        const cost = computeCost(Y_pred, Y_enc);
        backward(X, Y_enc, Y_pred, gradient); //compute gradient
        coef -= gradient * lr; //update weights

        if abs(prev - cost) < stop_criteria then break;
        if it == max_iter then writeln("Reached max iter = ", max_iter);

        prev = cost;
    }

    var classifier = new LogisticRegression(
            coef = coef, bias = bias,
            n_classes = n_classes,
            n_feats = n_feats);

    return classifier;

}

proc computeCost(prediction, y) {
    var cost = 0.0;

    var n_train = prediction.shape(1);

    forall t in 1..n_train with (+ reduce cost) {
        //add epsilon constant to avoid log(0)
        var c = y(t, ..) * log(prediction(t, ..) + epsilon) +
            (1.0 - y(t, ..)) * log(1.0 - prediction(t, ..) + epsilon);
        cost -= sum(c)/n_train;
    }

    return cost;
}

proc forward(X, coef, bias, ref pred) {

    //pred = 0.0;
    const (n_train, n_feats) = X.shape;
    const n_classes = pred.shape(1);

    for i in 1..n_train {
        for c in 1..n_classes {
            for j in 1..n_feats {
                pred(i, c) += X(i, j): real * coef(j, c);
            }
            pred(i, c) = sigmoid(pred(i, c) + bias(c));
        }
    }
    /*
       pred = X.dot( coef );
       forall c in 1..n_classes {
       pred(.., c) = sigmoid(pred(..,c) + bias(c));
       } */
}

proc backward(X, Y, Ypred, grad) {

    const (n_train, n_feats) = X.shape;
    const n_classes = Ypred.shape(1);

    grad = 0;

    for j in 1..n_feats {
        for i in 1..n_train {
            for c in 1..n_classes {
                grad(j, c) += (Ypred(i, c) - Y(i, c)) * X(i,j) / n_train;
            }
        }
    }
}

proc LogisticRegression.classify(X, Y) {

    var (n_test, n_feats) = X.shape;
    var n_classes = classifier.n_classes;

    var prediction: [{1..n_test, 1..n_classes}] real = 0.0;
    forward(X, coef, bias, prediction);

    /* writeln("classify: ", n_classes); */
    forall t in 1..n_test {
        /* writeln(prediction.shape); */
        /* writeln(prediction(t, ..)); */
        Y(t) = utils.argmax(prediction(t, ..));
        /* writeln("class: ", Y(t)); */
    }
}
