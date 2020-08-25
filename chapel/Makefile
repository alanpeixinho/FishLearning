all: main.chpl
	chpl -lcblas -o main main.chpl -M utils -M data -M supervised -lcblas

release: main.chpl
	chpl -lblas --print-commands --fast -o main main.chpl -M utils -M data -M supervised 

library: fish_learning.chpl
	chpl --fast --library fish_learning.chpl -M utils -M data -M supervised -lcblas
