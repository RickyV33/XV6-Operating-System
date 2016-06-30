#include "types.h" 
#include "user.h"
#include "date.h"

int stdout = 1;
int stderr = 2;

int
main(int argc, char * argv[]) {
   
    int uid, gid, ppid;

    uid = getuid();
    printf(stdout, "Current UID is %d\n", uid);
    printf(stdout, "Setting UID to 42...\n");
    setuid(42);
    uid = getuid();
    printf(stdout, "Current UID is %d\n", uid);
    

    gid = getgid();
    printf(stdout, "Current GID is %d\n", gid);
    printf(stdout, "Setting GID to 77...\n");
    setgid(77);
    gid = getgid();
    printf(stdout, "Current GID is %d\n", gid);

    ppid = getppid();
    printf(stdout, "My parent process id is %d\n", ppid);


    
    printf(stdout, "Before creating a new process...\n");
    gid = getgid();
    uid = getuid();
    ppid = getppid();
    printf(stdout, "The current process gid: %d, uid: %d, ppid: %d \n", gid, uid, ppid);

    printf(stdout, "Creating a new process...\n");
    //Create a new process
    int pid = fork();
    if (pid < 0) {
        printf(stderr, "Error: fork failed\n");
        exit();
    } else if (pid == 0) { //Child process
        gid = getgid();
        uid = getuid();
        ppid = getppid();
        printf(stdout, "The outer-child process pid: %d, gid: %d, uid: %d, ppid: %d \n", pid, gid, uid, ppid);

        printf(stdout, "Creating a new process...\n");
        //Create a new process
        int pid2 = fork();
        if (pid2 < 0) {
            printf(stderr, "Error: fork failed\n");
            exit();
        } else if (pid2 == 0) { //Child process
            gid = getgid();
            uid = getuid();
            ppid = getppid();
            printf(stdout, "The inner-child process pid: %d, gid: %d, uid: %d, ppid: %d \n", pid2, gid, uid, ppid);
            exit();
        } else { //Parent process
            wait();
            gid = getgid();
            uid = getuid();
            ppid = getppid();
            printf(stdout, "The inner-parent process pid: %d, gid: %d, uid: %d, ppid: %d \n", pid2, gid, uid, ppid);
        }
        exit();
    } else { //Parent process
        wait();
        gid = getgid();
        uid = getuid();
        ppid = getppid();
        printf(stdout, "The outer-parent process pid: %d, gid: %d, uid: %d, ppid: %d \n", pid, gid, uid, ppid);
    }

    printf(stdout, "Testing Complete\n");

    exit();
}
