
use data;
use naive_bayes;
use math;
use utils;

config const csv_dataset: string;

proc main() {
  try {
      var dataset = data.readCSV(csv_dataset, delimiter=',');
      var (Xtrain, Ytrain, Xtest, Ytest) = dataset.split(trainRatio=0.5);
      var clf = naive_bayes.train(Xtrain, Ytrain);
      var Ypred: [1..Ytest.size] int = -1;
      Ypred = clf.predict_batch(Xtest);

      writeln("Score: %4.2dr".format(accuracy(Ytest, Ypred) * 100.0));

    } catch e {
      writeln("deu ruim " + e:string);
    }
}
