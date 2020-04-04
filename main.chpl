
use data;
use LinearAlgebra;
use Time;
use knn;
use logistic_regression;
use naive_bayes;
use math;
use utils;

proc main() {

  try {

    var dataset = data.readCSV("data/digits.csv", delimiter=',', labelIdx=65);
    var t = new Timer();

    /* exit(); */

    var acc = 0.0;

    var accuracies: [1..10] real;
    t.start();
    var i = 1;
    for (Xtrain, Ytrain, Xtest, Ytest) in dataset.nsplit(n=10, trainRatio=0.5) {
      var classifier = new NaiveBayes(Xtrain.shape(1), Xtrain.shape(2), 10);
      classifier.train(Xtrain, Ytrain);
      var Y: [1..Ytest.size] real = -1;
      classifier.classify(Xtest, Y);
      /* writeln(t.elapsed()); */

      writeln(Ytest);
      writeln(Y);
      accuracies(i) = accuracy(Ytest, Y);
      acc += accuracies(i);
      i+=1;
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
