all: run_naive_bayes.chpl
	chpl --fast -lcblas -o bin/run_naive_bayes run_naive_bayes.chpl -M utils -M data -M supervised -lcblas

library: fish_learning.chpl
	chpl --fast -o fish_learning fish_learning.chpl --library -M utils -M data -M supervised -lcblas
