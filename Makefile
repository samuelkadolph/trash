CC ?= gcc
INSTALL ?= install

CFLAGS ?= -Wall -Werror -fno-common -pipe
LDFLAGS ?= -framework Foundation -framework ScriptingBridge

ifeq ($(DEBUG), 1)
	BUILD = debug
	CFLAGS += -DDEBUG=1
else
	BUILD = release
	CFLAGS += -O2 -g
endif

default: clean build

build: build/trash

build/%.o: source/%.m
	$(CC) $(CFLAGS) -c $< -o $@

build/trash: build/trash.o
	$(CC) $(CFLAGS) $(LDFLAGS) build/trash.o -o $@

clean:
	rm -rf build/*
.PHONY: clean

install: build/trash
	$(INSTALL) -d /usr/local/bin
	$(INSTALL) -m 755 build/trash /usr/local/bin
.PHONY: install
