#include "types.h" 
#include "user.h"
#include "uproc.h"

int
main(int argc, char * argv[]) 
{
    struct uproc p[UPROC];
    int size;

    size = getprocs(10, p);
    if (size <= 0) {
        printf(2, "Error: ps failed");
        exit();
    }

    int i;
    printf(1, "pid  uid  gid  ppid  state prio sz  nm\n");
    for (i = 0; i < size; ++i) {
        printf(1, "%d  %d  %d  %d  %s %d  %d  %s\n", 
                p[i].pid, p[i].gid, p[i].uid, p[i].ppid, p[i].state,
                p[i].priority, p[i].size, p[i].name);
    }
    exit();
}
