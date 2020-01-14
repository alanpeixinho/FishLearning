
use data;
use LinearAlgebra;
use Time;
use knn;
use logistic_regression;
use math;
use utils;

use VisualDebug;


proc string.hue() {
    writeln("huehuehue br");
}

proc kk(X, Y) {
  writeln("@ function");
}

proc main() {


startVdebug("E1");

    kk(1,1);

    writeln("Olá mundo ");
    "ola".hue();
    try {

        var dataset = data.readCSV("data/digits.csv", delimiter=',', labelIdx=65);
        var t = new Timer();

	var A = Matrix(1000,1000);
  var X = Matrix(1000,1000);
	var time = 0.0;
  A = 1.5;
	for i in 1..10 {
	  t.start();
	  X = 1.0/log(A * 2);
	  t.stop();
	  time += t.elapsed();
	}

   writeln(X(10,10));

	writeln(time);

  for i in 1..10 {
    t.start();
    for i in A.domain {
      X(i) = 1.0/log(A(i) * 2.0);
    }
    t.stop();
    time += t.elapsed();
  }

  writeln(X(10,10));

  writeln(time);



        var acc = 0.0;

        t.start();
        for (Xtrain, Ytrain, Xtest, Ytest) in dataset.nsplit(n=1, trainRatio=0.5) {
          var classifier = new LogisticRegression();
          classifier.train(Xtrain, Ytrain);
          var Y: [1..Ytest.size] real = -1;
          classifier.classify(Xtest, Y);
          /* writeln(t.elapsed()); */
          acc += accuracy(Ytest, Y);
        }
        t.stop();

        writeln(t.elapsed());
        writeln(acc/1.0);

    } catch e {
     writeln("deu ruim " + e:string);
    }

    stopVdebug();
}
