all: main.chpl
	chpl -o main main.chpl -M utils -M data -M supervised -lcblas

release: main.chpl
	chpl --fast -o main main.chpl -M utils -M data -M supervised -lcblas
