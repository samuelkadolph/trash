CC = gcc
INSTALL = install

CFLAGS = -Wall -Werror -fno-common -pipe
LDFLAGS = -framework Foundation -framework ScriptingBridge

ifeq ($(DEBUG), 1)
	BUILD = debug
	CFLAGS += -DDEBUG=1
else
	BUILD = release
	CFLAGS += -O2 -g
endif

CFLAGS += -Ibuild/$(BUILD) -Lbuild/$(BUILD)

EXECUTABLE = trash
SOURCES = trash.m
OBJECTS = $(addprefix build/$(BUILD)/,$(SOURCES:.m=.o))
DEPENDENCIES = $(addprefix build/$(BUILD)/,$(SOURCES:.m=.d))

all: build/$(BUILD)/$(EXECUTABLE)

build/$(BUILD):
	mkdir -p $@

build/$(BUILD)/%.d: source/%.m | build/$(BUILD)
	$(CC) $(CFLAGS) $< -M -MF $@ -MT ${@:.d=.o} -MT $@

build/$(BUILD)/%.o: source/%.m | build/$(BUILD)
	$(CC) $(CFLAGS) -c $< -o $@

build/$(BUILD)/$(EXECUTABLE): $(OBJECTS) | build/$(BUILD)
	$(CC) $(CFLAGS) $(LDFLAGS) $(OBJECTS) -o $@

clean:
	rm -rf build

install: build/$(BUILD)/$(EXECUTABLE)
	$(INSTALL) -d /usr/local/bin
	$(INSTALL) -m 755 build/$(BUILD)/$(EXECUTABLE) /usr/local/bin

.PHONY: all clean install

-include $(DEPENDENCIES)
