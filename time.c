#include "types.h"
#include "date.h"
#include "user.h"

#define MAXARGS 20

int
main(int argc, char * argv[]) 
{
    int i; //Used to increment through the arguments
    char * args[MAXARGS]; //Stores our arguments
    struct rtcdate t1, t2; //Stores our start time and our end time respectively
    int pid; //Stores our process ID
    uint time1, time2; //Stores our elapsed minutes and seconds respectively
    
    if (argc > (MAXARGS-1)) {
        printf(2,"Error: too many args\n");
        return -1;
    }

    //Copy the arguments from argv into args
    for (i = 0; i < argc-1; ++i) {
        strcpy(args[i], argv[i+1]);    
    }
    args[i] = '\0';
    
    //Get the start time
    if (date(&t1) != 0) {
        printf(2, "Error: getting the time failed\n");
        return -1;
    }

    //Create a new process
    pid = fork();
    if (pid < 0) {
        printf(2, "Error: fork failed\n");
        return -1;
    } else if (pid == 0) { //Child process
        exec(args[0], args);
        exit();
    } else { //Parent process
        wait();
        //Get our end time
        if (date(&t2) != 0) {
            printf(2, "Error: getting the time failed\n");
            return -1;
        }
    }

    //Calculate elapsed time
    if (t1.second > t2.second) {
        time1 = t2.minute - t1.minute;
        time2 = t1.second - t2.second;
    } else{
        time1 = t2.minute - t1.minute;
        time2 = t2.second - t1.second;
    }
    printf(1, "Elapsed time: %dm %ds\n", time1, time2);
    exit();
    return 0;
}
