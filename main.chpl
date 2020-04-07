
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

    var acc = 0.0;

    var accuracies: [1..10] real;
    t.start();
    var i = 1;
    for (Xtrain, Ytrain, Xtest, Ytest) in dataset.nsplit(n=10, trainRatio=0.75) {
      var classifier = logistic_regression.train(Xtrain, Ytrain,
                                                 learning_rate=learning_rate,
                                                 max_iter=max_iter);

      /* var classifier = naive_bayes.train(Xtrain, Ytrain); */

      var Ypred: [1..Ytest.size] real = -1;
      classify(classifier, Xtest, Ypred);
      /* naive_bayes.classify(classifier, Xtest, Ypred); */

      /* writeln(Ytest);
      writeln(Ypred); */
      accuracies(i) = accuracy(Ytest, Ypred);
      acc += accuracies(i);
      writeln(accuracies(i));
      i+=1;
      /* writeln(Xtrain.shape);
      writeln(Xtrain.shape(1).type:string); */
    }
    t.stop();

    writeln("==========");
    writeln(t.elapsed());
    writeln(acc/1.0);

    writeln(accuracies);
    writeln(utils.mean(accuracies), utils.stdDev(accuracies));

    } catch e {
      writeln("deu ruim " + e:string);
    }

  }
