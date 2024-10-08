MODULES = filter supervised utils data image io graphics frequency
LINK_MODULES = $(addprefix -M, $(MODULES))
FILES_MODULES = $(wildcard $(MODULES)/*.chpl)
CLI_SOURCES = $(wildcard cli/*.chpl)
CLI_OBJECTS = $(patsubst cli/%.chpl,bin/%,$(CLI_SOURCES))
FLAGS =
LIBS = -lpng -lraylib

all: bin

bin/%: cli/%.chpl $(FILES_MODULES)
	@echo $<
	chpl ${FLAGS} $< ${LINK_MODULES} -o $@ $(LIBS)

bin: $(CLI_OBJECTS)
	@echo $(CLI_OBJECTS)

clean:
	rm bin/*
