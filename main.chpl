
use data;
use LinearAlgebra;
use Time;
use knn;
use math.utils;

proc main() {
    writeln("Olá mundo ");
    try {

        var classifier = new KNN();

        var dataset = data.readCSV("iris.csv", delimiter=',', labelIdx=5);
        var t = new Timer();
        t.start();
        t.stop();
        writeln(dataset.Y[50..100]);
        writeln(dataset.X[50..100, ..]);
        writeln(dataset.nsamples, dataset.nfeats);
        classifier.train(dataset.X, dataset.Y);

        writeln((+ reduce dataset.X)/dataset.X.size);

        var amax = utils.argmax(dataset.X);
        writeln(dataset.X(amax), amax);

        writeln(utils.unique(dataset.Y));

        var d: domain(real) = utils.unique(dataset.Y);

        writeln(utils.oneHotEncoder(dataset.Y));

        writeln(classifier.xDomain.shape);

    } catch e {
     writeln("deu ruim " + e:string);
    }
}
