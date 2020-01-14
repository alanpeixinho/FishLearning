
private use LinearAlgebra;
private use Random;

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

  proc init(X, Y) {
    init(X.shape[1], X.shape[2]);
    this.X = X;
    this.labelsDomain = {1..nsamples};
    this.Y = Y;
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

private proc split(line, delimiter) throws {
    const data = for x in line.split(delimiter) do x:real;
    return data;
}

proc readCSV(filepath: string, delimiter = ' ', labelIdx = -1) throws {
    const file = open(filepath, iomode.r);
    const lines = for line in file.lines() do split(line, delimiter);
    file.close();
    const matrix = toDataset(lines, labelIdx);
    return matrix;
}

private proc toDataset(array: [] ?T, labelIdx = -1) where isArray(T) {
   const nrows = array.size;
   const ncols = array.head().size;

   var matrix = Matrix(nrows, ncols);
   for (x,y) in matrix.domain {
     matrix(x, y) = array[x][y];
   }

   if(labelIdx==-1) {
     return new Dataset(matrix);
   } else {
      var dataset = new Dataset(nrows, ncols-1);
      dataset.X[.., ..labelIdx-1] = matrix[..,..labelIdx-1];
      dataset.X[.., labelIdx..] = matrix[.., labelIdx+1..];
      dataset.Y = matrix[.., labelIdx];
      return dataset;
   }
}
