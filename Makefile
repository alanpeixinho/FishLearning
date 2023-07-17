MODULES = -M filter -M supervised -M utils -M data -M image -M io
CLI_SOURCES = $(wildcard cli/*.chpl)
CLI_OBJECTS = $(patsubst cli/%.chpl,bin/%,$(CLI_SOURCES))
FLAGS = --fast
LIBS = -lpng

all: cli

bin/%: cli/%.chpl
	@echo $<
	chpl ${FLAGS} $< ${MODULES} -o $@ $(LIBS)

cli: $(CLI_OBJECTS)
	@echo $(CLI_OBJECTS)

clean:
	rm bin/*


