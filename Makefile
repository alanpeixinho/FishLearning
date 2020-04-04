all: main.chpl
	chpl -o main main.chpl -M utils -M data -M supervised -lcblas

release: main.chpl
	chpl --fast -o main main.chpl -M utils -M data -M supervised -lcblas

library: fish_learning.chpl
	chpl --fast --library fish_learning.chpl -M utils -M data -M supervised -lcblas
