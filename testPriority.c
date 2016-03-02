#include "types.h" 
#include "user.h"
#include "date.h"
#include "uproc.h"

int stdout = 1;
int stderr = 2;

void
ps(struct uproc p[UPROC]) 
{
    int size;

    size = getprocs(10, p);
    if (size <= 0) {
        printf(2, "Error: ps failed");
        exit();
    }

    int i;
    printf(1, "pid  uid  gid  ppid  state prio sz  nm\n");
    for (i = 0; i < size; ++i) {
        //Only print the processes that I care about for this testing
        if (p[i].pid == 1){
            printf(1, "%d  %d  %d  %d  %s %d  %d  %s\n", 
                    p[i].pid, p[i].gid, p[i].uid, p[i].ppid, p[i].state,
                    p[i].priority, p[i].size, p[i].name);
        }
    }
    return;
}

void
ps2(struct uproc p[UPROC]) 
{
    int size;

    size = getprocs(10, p);
    if (size <= 0) {
        printf(2, "Error: ps failed");
        exit();
    }

    int i;
    printf(1, "pid  uid  gid  ppid  state prio sz  nm\n");
    for (i = 0; i < size; ++i) {
        //Only print the processes that I care about for this testing
        if (p[i].pid == 2){
            printf(1, "%d  %d  %d  %d  %s %d  %d  %s\n", 
                    p[i].pid, p[i].gid, p[i].uid, p[i].ppid, p[i].state,
                    p[i].priority, p[i].size, p[i].name);
        }
    }
    return;
}


int
main(int argc, char * argv[]) {
   
    struct uproc p[UPROC];
    // Set priority of init
    printf(stdout, "Before setting priority for pid 1 (init)...\n");
    ps(p);
    printf(stdout, "Setting priority of pid 1 (init) to 0...\n");
    setpriority(1, 0);
    ps(p);
    printf(stdout, "Setting priority of pid 1 (init) to 2...\n");
    setpriority(1, 2);
    ps(p);
    printf(stdout, "Setting priority of pid 2 (init) to -10...\n");
    setpriority(1, -10);
    ps(p);
    printf(stdout, "Setting priority of pid 2 (init) to 100...\n");
    setpriority(1, 100);
    ps(p);
    printf(stdout, "Setting priority of pid 2 (init) to 1...\n");
    setpriority(1, 1);
    ps(p);



    printf(stdout, "\nBefore setting priority for pid 2 (sh)...\n");
    ps2(p);
    printf(stdout, "Setting priority of pid 2 (sh) to 0...\n");
    setpriority(2, 0);
    ps2(p);
    printf(stdout, "Setting priority of pid 2 (sh) to 2...\n");
    setpriority(2, 2);
    ps2(p);
    printf(stdout, "Setting priority of pid 2 (sh) to -10...\n");
    setpriority(2, -10);
    ps2(p);
    printf(stdout, "Setting priority of pid 2 (sh) to 100...\n");
    setpriority(2, 100);
    ps2(p);
    printf(stdout, "Setting priority of pid 2 (sh) to 1...\n");
    setpriority(2, 1);
    ps2(p);

    printf(stdout, "Testing Complete\n");

    exit();
}

