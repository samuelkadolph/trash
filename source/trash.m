#include <Foundation/Foundation.h>
#include <ScriptingBridge/ScriptingBridge.h>
#include <getopt.h>
#include "Finder.h"

#define VERSION "1.0.0"

static char * stripPath(const char * path)
{
  char * name = strrchr(path, '/');
  return name ? ++name : (char *)path;
}

static void usage(char * programName)
{
  printf("Usage: %s [options] files...\n", programName);
  printf("\n");
  printf("Trash Options:\n");
  printf("-e, --empty                      Empties the trash\n");
  printf("-E, --empty-securely             Securely empties the trash\n");
  printf("-l, --list                       Lists all files in the trash\n");
  printf("\n");
  printf("General Options:\n");
  printf("-h, --help                       Print this message and exit\n");
  printf("-v, --version                    Print the version and exit\n");
}

static void version(char * programName)
{
  printf("%s %s\n", programName, VERSION);
}

int main(int argc, const char * argv[])
{
  FinderApplication * finder = [SBApplication applicationWithBundleIdentifier:@"com.apple.finder"];
  FinderTrashObject * trash = finder.trash;
  trash.warnsBeforeEmptying = NO;
  NSURL * cwd = [NSURL fileURLWithPath:[[NSFileManager defaultManager] currentDirectoryPath]];
  char * programName = stripPath(argv[0]);
  const char * shortOptions = "eElhv";
  const struct option longOptions[] = {
    { "empty", no_argument, NULL, 'e' },
    { "empty-securely", no_argument, NULL, 'E' },
    { "list", no_argument, NULL, 'l' },
    { "help", no_argument, NULL, 'h' },
    { "version", no_argument, NULL, 'v' },
    { NULL, 0, NULL, 0 }
  };
  int i, option, optionIndex;

  while ((option = getopt_long(argc, (char **)argv, shortOptions, longOptions, &optionIndex)) != -1)
  {
    switch (option)
    {
      case 'e':
        [trash emptySecurity:NO];
        exit(EXIT_SUCCESS);
        break;
      case 'E':
        [trash emptySecurity:YES];
        exit(EXIT_SUCCESS);
        break;
      case 'l':
        [trash.items enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
          FinderItem * item = (FinderItem *)obj;
          NSString * path = [[NSURL URLWithString:item.URL] path];
          printf("%s\n", [path UTF8String]);
        }];
        exit(EXIT_SUCCESS);
        break;
      case 'h':
        usage(programName);
        exit(EXIT_SUCCESS);
      case '?':
        usage(programName);
        exit(EXIT_FAILURE);
        break;
      case 'v':
        version(programName);
        exit(EXIT_SUCCESS);
        break;
    }
  }

  if (optind >= argc)
  {
    usage(programName);
    exit(EXIT_FAILURE);
  }

  for (i = optind; i < argc; i++)
  {
    NSString * argument = [NSString stringWithUTF8String:argv[i]];
    NSURL * file = [[NSURL URLWithString:[argument stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] relativeToURL:cwd] absoluteURL];
    FinderItem * item = [finder.items objectAtLocation:file];

    if ([item exists])
    {
      [item delete];
    }
    else
    {
      printf("%s: %s: No such file or directory\n", programName, [argument UTF8String]);
      exit(EXIT_FAILURE);
    }
  }

  return 0;
}
