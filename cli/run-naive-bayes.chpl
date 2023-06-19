use IO.FormattedIO;

use data;
use naive_bayes;
use math;
use utils;

config const csv_dataset: string;

proc main(): int {

    const dataset = data.readCSV(csv_dataset, delimiter=',');

    for i in 1..10 {
        try {
            const (Xtrain, Ytrain, Xtest, Ytest) = dataset.split(trainRatio=0.5);

            const clf = naive_bayes.train(Xtrain, Ytrain);
            const Ypred = clf.predict_batch(Xtest);

            writef("Score: %4.2dr\n", accuracy(Ytest, Ypred) * 100.0);
        } catch e {
            writeln("Error: ", e);
            return 1;
        }
    }

    return 0;
}
