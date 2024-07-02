#import <Foundation/Foundation.h>
#import <spawn.h>
#import <sys/wait.h>
#import "BCRootListController.h"

@implementation BCRootListController

- (NSArray *)specifiers {
	if (!_specifiers) {
		_specifiers = [self loadSpecifiersFromPlistName:@"Root" target:self];
	}

	return _specifiers;
}

- (void)respringDevice {
    pid_t pid;
	int status;
	const char *argv[] = {"/usr/bin/sbreload", NULL};
	posix_spawn(&pid, argv[0], NULL, NULL, (char *const *)argv, NULL);
	waitpid(pid, &status, WEXITED);
}

@end
