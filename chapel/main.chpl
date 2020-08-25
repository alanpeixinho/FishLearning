
use data;
use LinearAlgebra;
use Time;
use knn;
use logistic_regression;
use naive_bayes;
use math;
use utils;

config const learning_rate = 1e-4;
config const max_iter = 10000;

config const csv_dataset: string;

proc main() {

  try {

    var dataset = data.readCSV(csv_dataset, delimiter=',');
    var t = new Timer();

    var n_splits = 10;
    var accuracies: [1..n_splits] real;
    t.start();
    var i = 1;
    for (Xtrain, Ytrain, Xtest, Ytest) in dataset.nsplit(n=n_splits, trainRatio=0.75) {
      var clf = naive_bayes.train(Xtrain, Ytrain);

      var Ypred: [1..Ytest.size] int = -1;
      Ypred = predict_batch(clf, Xtest);
      accuracies(i) = accuracy(Ytest, Ypred);
      i+=1;
    }
    t.stop();

    writeln("==========");
    writeln(t.elapsed()/n_splits);
    writeln(sum(accuracies)/n_splits);

    writeln(accuracies);
    writeln("%r %r".format(utils.mean(accuracies), utils.stdDev(accuracies)));

    } catch e {
      writeln("deu ruim " + e:string);
    }

  }
