#define UPROC 20


// Data structure that manages the processes be displayed with system call 'ps'
struct uproc {
  int pid;                       // Process ID
  uint gid;                      // Group Process ID
  uint uid;                      // User Process ID
  int ppid;                      // Parent Process ID   
  char state[16];                  // Process state
  uint size;                     // Size of process memory (bytes)
  int priority;                 //Stores the process priority
  char name[16];                 // Process name (debugging)
};
