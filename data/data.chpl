
private use LinearAlgebra;
private use Random;
private use IO;

class Dataset {
  var nsamples, nfeats: int;
  var nlabels: int = 0;
  var featsDomain: domain(2);
  var labelsDomain: domain(1);
  var X: [featsDomain] real;
  var Y: [labelsDomain] real;

  proc init(nsamples: int, nfeats: int) {
    this.nsamples = nsamples;
    this.nfeats = nfeats;
    this.featsDomain = {1..nsamples, 1..nfeats};
    this.labelsDomain = {1..nsamples};
  }

  proc init(X) {
    init(X.shape[1], X.shape[2]);
    this.X = X;
  }

  proc split(trainRatio = 0.5) {
    var splits = for (Xtrain, Ytrain, Xtest, Ytest) in nsplit(trainRatio, n=1) do
      (Xtrain, Ytrain, Xtest, Ytest);
    return splits(0);
  }


  iter nsplit(trainRatio = 0.5, n = 1) {
    var ids = for i in 1..nsamples do i;

    var ntrain = (trainRatio*nsamples): int;
    var ntest = nsamples - ntrain;

    var Ytrain: [1..ntrain] real;
    var Xtrain: [1..ntrain, 1..nfeats] real;

    var Ytest: [1..ntest] real;
    var Xtest: [1..ntest, 1..nfeats] real;

    for s in 1..n {
      shuffle(ids);
      for i in 1..ntrain {
        Xtrain(i, ..) = X(ids(i), ..);
        Ytrain(i) = Y(ids(i));
      }
      for i in 1..ntest {
        Xtest(i, ..) = X(ids(ntrain + i), ..);
        Ytest(i) = Y(ids(ntrain + i));
      }
      yield (Xtrain, Ytrain, Xtest, Ytest);
    }
  }

}

private proc lineSplit(line, delimiter) throws {
    const data = for x in line.split(delimiter) do x:real;
    return data;
}

proc readCSV(filepath: string, delimiter = ' ', labelIdx = 0) throws {
    const file = open(filepath, ioMode.r);
    const lines = for line in file.reader(locking=false).lines() do lineSplit(line, delimiter);
    file.close();
    const matrix = toDataset(lines, labelIdx);
    return matrix;
}

private proc toDataset(array: [] ?T, label_idx = 0) where isArray(T) {
   const nrows = array.size;
   const ncols = array[array.domain.low].size;

   var X: [1..nrows, 1..ncols-1] real;
   var Y: [1..nrows] real;

   var true_label_idx = if label_idx > 0 then label_idx else ncols;

   for (i,j) in {1..nrows, 1..ncols} {
     if j == true_label_idx {
       Y(i) = array[i-1][j-1];
     } else {
       const offsetj = if j > true_label_idx then -1 else 0;
       X(i, j + offsetj) = array[i-1][j-1];
     }
   }

   var d = new Dataset(nrows, ncols-1);
   d.X = X;
   d.Y = Y;

   return d;
}
