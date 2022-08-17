# trash

trash is a simple command line tool for OS X that lets you send a file or directory to the trash instead of oblivion.

## Description

trash lets you empty, empty securely, list, or send files or directories to the Finder Trash instead of using `rm -rf foo`
so that you can recover them at a later point if you made a mistake. Uses the Finder to delete the files so you get normal
trash behaviour: `Put Back` and name conflict resolution and you get that lovely trash sound.

## Installation

```
git clone https://github.com/samuelkadolph/trash && cd trash
make
sudo make install
```

## Usage

```
Usage: trash [options] files...

Trash Options:
-e, --empty                      Empties the trash
-E, --empty-securely             Securely empties the trash
-l, --list                       Lists all files in the trash

General Options:
-h, --help                       Print this message and exit
-v, --version                    Print the version and exit
```

## Contributing

Fork, branch & pull request.