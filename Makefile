MODULES = filter supervised utils data image io
LINK_MODULES = $(addprefix -M, $(MODULES))
FILES_MODULES = $(wildcard $(MODULES)/*.chpl)
CLI_SOURCES = $(wildcard cli/*.chpl)
CLI_OBJECTS = $(patsubst cli/%.chpl,%,$(CLI_SOURCES))
FLAGS = --fast
LIBS = -lpng

all: cli

%: cli/%.chpl $(FILES_MODULES)
	@echo cli/$@.chpl:
	chpl ${FLAGS} $< ${LINK_MODULES} -o bin/$@ $(LIBS)

cli: $(CLI_OBJECTS)
	@echo $(CLI_OBJECTS)

clean:
	rm bin/*
