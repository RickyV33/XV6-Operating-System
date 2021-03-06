#include "types.h"
#include "defs.h"
#include "param.h"
#include "memlayout.h"
#include "mmu.h"
#include "x86.h"
#include "proc.h"
#include "spinlock.h"
#include "uproc.h"

struct {
  struct spinlock lock;
  struct proc proc[NPROC];
#ifdef CS333_SCHEDULER
  struct proc * readyList[SIZE];
  struct proc * freeList;
  uint timeToReset;
#endif
} ptable;


static struct proc *initproc;

int nextpid = 1;
extern void forkret(void);
extern void trapret(void);

static void wakeup1(void *chan);

void
pinit(void)
{
  initlock(&ptable.lock, "ptable");
}

//PAGEBREAK: 32
// Look in the process table for an UNUSED proc.
// If found, change state to EMBRYO and initialize
// state required to run in the kernel.
// Otherwise return 0.
static struct proc*
allocproc(void)
{
  struct proc *p;
  char *sp;

  acquire(&ptable.lock);
#ifdef CS333_SCHEDULER
  p = ptable.freeList;
  if (p) {
      ptable.freeList = ptable.freeList->next;
      p->next = 0;
      goto found;
  }
#else
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
    if(p->state == UNUSED)
      goto found;
#endif
  release(&ptable.lock);
  return 0;

found:
  p->state = EMBRYO;
  p->pid = nextpid++;
  release(&ptable.lock);

  // Allocate kernel stack.
  if((p->kstack = kalloc()) == 0){
    p->state = UNUSED;
#ifdef CS333_Scheduler
    acquire(&ptable.lock);
    putOnFreeList(p);
    release(&ptable.lock);
#endif
    return 0;
  }
  sp = p->kstack + KSTACKSIZE;
  
  // Leave room for trap frame.
  sp -= sizeof *p->tf;
  p->tf = (struct trapframe*)sp;
  
  // Set up new context to start executing at forkret,
  // which returns to trapret.
  sp -= 4;
  *(uint*)sp = (uint)trapret;

  sp -= sizeof *p->context;
  p->context = (struct context*)sp;
  memset(p->context, 0, sizeof *p->context);
  p->context->eip = (uint)forkret;


  return p;
}

//PAGEBREAK: 32
// Set up first user process.
void
userinit(void)
{
  struct proc *p;
  extern char _binary_initcode_start[], _binary_initcode_size[];
#ifdef CS333_SCHEDULER
  acquire(&ptable.lock);
  initFreeList();
  ptable.timeToReset = COUNT;
  release(&ptable.lock);
#endif
  
  p = allocproc();
  initproc = p;
  if((p->pgdir = setupkvm()) == 0)
    panic("userinit: out of memory?");
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
  p->sz = PGSIZE;
  memset(p->tf, 0, sizeof(*p->tf));
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
  p->tf->es = p->tf->ds;
  p->tf->ss = p->tf->ds;
  p->tf->eflags = FL_IF;
  p->tf->esp = PGSIZE;
  p->tf->eip = 0;  // beginning of initcode.S
  p->uid = USERID;
  p->gid = GROUPID;

  safestrcpy(p->name, "initcode", sizeof(p->name));
  p->cwd = namei("/");

  p->state = RUNNABLE;
#ifdef CS333_SCHEDULER
  acquire(&ptable.lock);
  int i;
  for (i = 0; i < 3; ++i) {
      ptable.readyList[i] = 0;
  }
  putOnReadyList(p, p->priority);
  release(&ptable.lock);
#endif
}

#ifdef CS333_SCHEDULER
// Initializes the free list by iterating through the process
// list and adding all UNUSED process to the head of the list
void
initFreeList() {
    struct proc * p;
  ptable.freeList = 0;
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
      if(p->state == UNUSED) {
          p->next = ptable.freeList;
          ptable.freeList = p;
      }
      p->priority = DEFAULTPRIO;
  }
}

//Adds an UNUSED process to the free list at the tail of the list
void
putOnFreeList(struct proc * p) {
    struct proc * current = ptable.freeList;

    // If the list is empty
    if (current == 0) {
        ptable.freeList = p;
        ptable.freeList->next = 0;
    }
    //Add to end of list
    else {
        while (current->next != 0){
            current = current ->next;
        }
        p->next = 0;
        current->next = p;
    }
}

//Adds an RUNNABLE process to the ready list at the tail of the list
void
putOnReadyList(struct proc * p, int priority) {
    struct proc * current = ptable.readyList[priority];

    // If the list is empty
    if (current == 0) {
        ptable.readyList[priority] = p;
        ptable.readyList[priority]->next = 0;
    } 
    //Add to end of list
    else {
        while (current->next != 0){
            current = current ->next;
        }
        p->next = 0;
        current->next = p;
    }
}

void 
removeFromReadyList(struct proc * p, int priority) {
    struct proc * current = ptable.readyList[priority];
    
    if (current == 0)
        return;
    // If it's the first item in the list, remove it
    if (current == p) {
        ptable.readyList[priority] = ptable.readyList[priority]->next;
        p->next = 0;
    } 
    //Search for it in the middle of the list
    else {
        while (current->next) {
            if (current->next == p){
                current->next = current->next->next;
                p->next = 0;
            }
            current = current->next;
        }
    }
}

void
resetReadyList() {
    struct proc * p;
    struct proc * current = ptable.readyList[HIGH];
    struct proc * next;

    while (current != 0) {
        next = current->next;
        removeFromReadyList(current, current->priority);
        current->priority = DEFAULTPRIO;
        putOnReadyList(current, current->priority);
        current = next;
    }

    current = ptable.readyList[LOW];
    while (current != 0) {
        next = current->next;
        removeFromReadyList(current, current->priority);
        current->priority = DEFAULTPRIO;
        putOnReadyList(current, current->priority);
        current = next; 
    }

//Reset running and sleeping priorities 
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
      if (p->state == RUNNING || p->state == SLEEPING) {
          p->priority = DEFAULTPRIO;
      }
  }

}
#endif

// Grow current process's memory by n bytes.
// Return 0 on success, -1 on failure.
int
growproc(int n)
{
  uint sz;
  
  sz = proc->sz;
  if(n > 0){
    if((sz = allocuvm(proc->pgdir, sz, sz + n)) == 0)
      return -1;
  } else if(n < 0){
    if((sz = deallocuvm(proc->pgdir, sz, sz + n)) == 0)
      return -1;
  }
  proc->sz = sz;
  switchuvm(proc);
  return 0;
}

// Create a new process copying p as the parent.
// Sets up stack to return as if from system call.
// Caller must set state of returned proc to RUNNABLE.
int
fork(void)
{
  int i, pid;
  struct proc *np;

  // Allocate process.
  if((np = allocproc()) == 0)
    return -1;

  // Copy process state from p.
  if((np->pgdir = copyuvm(proc->pgdir, proc->sz)) == 0){
    kfree(np->kstack);
    np->kstack = 0;
    np->state = UNUSED;
#ifdef CS333_SCHEDULER
    acquire(&ptable.lock);
    putOnFreeList(np);
    release(&ptable.lock);
#endif
    return -1;
  }
  np->sz = proc->sz;
  np->parent = proc;
  *np->tf = *proc->tf;

    //Set guid and uid to np from proc
    np->gid = proc->gid;
    np->uid = proc->uid;
    np->priority = DEFAULTPRIO;

  // Clear %eax so that fork returns 0 in the child.
  np->tf->eax = 0;

  for(i = 0; i < NOFILE; i++)
    if(proc->ofile[i])
      np->ofile[i] = filedup(proc->ofile[i]);
  np->cwd = idup(proc->cwd);

  safestrcpy(np->name, proc->name, sizeof(proc->name));
 
  pid = np->pid;

  // lock to force the compiler to emit the np->state write last.
  acquire(&ptable.lock);
  np->state = RUNNABLE;
#ifdef CS333_SCHEDULER
  putOnReadyList(np, np->priority);
#endif
  release(&ptable.lock);
  
  return pid;
}

// Exit the current process.  Does not return.
// An exited process remains in the zombie state
// until its parent calls wait() to find out it exited.
void
exit(void)
{
  struct proc *p;
  int fd;

  if(proc == initproc)
    panic("init exiting");

  // Close all open files.
  for(fd = 0; fd < NOFILE; fd++){
    if(proc->ofile[fd]){
      fileclose(proc->ofile[fd]);
      proc->ofile[fd] = 0;
    }
  }

  begin_op();
  iput(proc->cwd);
  end_op();
  proc->cwd = 0;

  acquire(&ptable.lock);

  // Parent might be sleeping in wait().
  wakeup1(proc->parent);

  // Pass abandoned children to init.
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->parent == proc){
      p->parent = initproc;
      if(p->state == ZOMBIE)
        wakeup1(initproc);
    }
  }

  // Jump into the scheduler, never to return.
  proc->state = ZOMBIE;
  sched();
  panic("zombie exit");
}

// Wait for a child process to exit and return its pid.
// Return -1 if this process has no children.
int
wait(void)
{
  struct proc *p;
  int havekids, pid;

  acquire(&ptable.lock);
  for(;;){
    // Scan through table looking for zombie children.
    havekids = 0;
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
      if(p->parent != proc)
        continue;
      havekids = 1;
      if(p->state == ZOMBIE){
        // Found one.
        pid = p->pid;
        kfree(p->kstack);
        p->kstack = 0;
        freevm(p->pgdir);
        p->state = UNUSED;
        p->pid = 0;
#ifdef USE_CS333_SCHEDULER
       putOnFreeList(p);
#endif
        p->parent = 0;
        p->name[0] = 0;
        p->killed = 0;
        release(&ptable.lock);
        return pid;
      }
    }

    // No point waiting if we don't have any children.
    if(!havekids || proc->killed){
      release(&ptable.lock);
      return -1;
    }

    // Wait for children to exit.  (See wakeup1 call in proc_exit.)
    sleep(proc, &ptable.lock);  //DOC: wait-sleep
  }
}

#ifdef CS333_SCHEDULER
void
scheduler(void){
    //struct proc *p;
    
    int i;
    struct proc *p;

    for(;;){
        // Enable interrupts on this processor.
        sti();
        acquire(&ptable.lock);
        for (i = 0; i < SIZE; ++i) { 
            if (ptable.readyList[i] == 0)
                continue;
            p = ptable.readyList[i];
            removeFromReadyList(p, p->priority);
            // Set it back to priority 0 (increments at the end of loop)
            if (i != 2)
                i = -1;
            //Decrement counter
            --ptable.timeToReset;
            if (ptable.timeToReset == 0) {
                //cprintf("Reseting list\n");
                resetReadyList();
                ptable.timeToReset = COUNT;
            }
            proc = p;
            switchuvm(p);
            p->state = RUNNING;
            swtch(&cpu->scheduler, proc->context);
            switchkvm();
            proc = 0;
        }
        release(&ptable.lock);
    }
}
#else
//PAGEBREAK: 42
// Per-CPU process scheduler.
// Each CPU calls scheduler() after setting itself up.
// Scheduler never returns.  It loops, doing:
//  - choose a process to run
//  - swtch to start running that process
//  - eventually that process transfers control
//      via swtch back to the scheduler.
void
old_scheduler(void)
{
  struct proc *p;

  for(;;){
    // Enable interrupts on this processor.
    sti();

    // Loop over process table looking for process to run.
    acquire(&ptable.lock);
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
      if(p->state != RUNNABLE)
        continue;

      // Switch to chosen process.  It is the process's job
      // to release ptable.lock and then reacquire it
      // before jumping back to us.
      proc = p;
      switchuvm(p);
      p->state = RUNNING;
      swtch(&cpu->scheduler, proc->context);
      switchkvm();

      // Process is done running for now.
      // It should have changed its p->state before coming back.
      proc = 0;
    }
    release(&ptable.lock);

  }
}
#endif

// Enter scheduler.  Must hold only ptable.lock
// and have changed proc->state.
void
sched(void)
{
  int intena;

  if(!holding(&ptable.lock))
    panic("sched ptable.lock");
  if(cpu->ncli != 1)
    panic("sched locks");
  if(proc->state == RUNNING)
    panic("sched running");
  if(readeflags()&FL_IF)
    panic("sched interruptible");
  intena = cpu->intena;
  swtch(&proc->context, cpu->scheduler);
  cpu->intena = intena;
}

// Give up the CPU for one scheduling round.
void
yield(void)
{
  acquire(&ptable.lock);  //DOC: yieldlock
  proc->state = RUNNABLE;
#ifdef CS333_SCHEDULER
  putOnReadyList(proc, proc->priority);
#endif
  sched();
  release(&ptable.lock);
}

// A fork child's very first scheduling by scheduler()
// will swtch here.  "Return" to user space.
void
forkret(void)
{
  static int first = 1;
  // Still holding ptable.lock from scheduler.
  release(&ptable.lock);

  if (first) {
    // Some initialization functions must be run in the context
    // of a regular process (e.g., they call sleep), and thus cannot 
    // be run from main().
    first = 0;
    iinit(ROOTDEV);
    initlog(ROOTDEV);
  }
  
  // Return to "caller", actually trapret (see allocproc).
}

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void
sleep(void *chan, struct spinlock *lk)
{
  if(proc == 0)
    panic("sleep");

  if(lk == 0)
    panic("sleep without lk");

  // Must acquire ptable.lock in order to
  // change p->state and then call sched.
  // Once we hold ptable.lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup runs with ptable.lock locked),
  // so it's okay to release lk.
  if(lk != &ptable.lock){  //DOC: sleeplock0
    acquire(&ptable.lock);  //DOC: sleeplock1
    release(lk);
  }

  // Go to sleep.
  proc->chan = chan;
  proc->state = SLEEPING;
  sched();

  // Tidy up.
  proc->chan = 0;

  // Reacquire original lock.
  if(lk != &ptable.lock){  //DOC: sleeplock2
    release(&ptable.lock);
    acquire(lk);
  }
}

//PAGEBREAK!
// Wake up all processes sleeping on chan.
// The ptable lock must be held.
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->state == SLEEPING && p->chan == chan) {
      p->state = RUNNABLE;
#ifdef CS333_SCHEDULER
      putOnReadyList(p, p->priority);
#endif
    }
  }
}

// Wake up all processes sleeping on chan.
void
wakeup(void *chan)
{
  acquire(&ptable.lock);
  wakeup1(chan);
  release(&ptable.lock);
}

// Kill the process with the given pid.
// Process won't exit until it returns
// to user space (see trap in trap.c).
int
kill(int pid)
{
  struct proc *p;

  acquire(&ptable.lock);
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->pid == pid){
      p->killed = 1;
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING) {
        p->state = RUNNABLE;
#ifdef CS333_SCHEDULER
        putOnReadyList(p, p->priority);
#endif
      }
      release(&ptable.lock);
      return 0;
    }
  }
  release(&ptable.lock);
  return -1;
}


//PAGEBREAK: 36
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
  static char *states[] = {
  [UNUSED]    "unused",
  [EMBRYO]    "embryo",
  [SLEEPING]  "sleep ",
  [RUNNABLE]  "runble",
  [RUNNING]   "run   ",
  [ZOMBIE]    "zombie"
  };
  int i;
  struct proc *p;
  char *state;
  uint pc[10];
  
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->state == UNUSED)
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
      state = states[p->state];
    else
      state = "???";
    cprintf("%d %d %d %d %s %s", p->pid, p->uid, p->gid, p->priority, state, p->name);
    if(p->state == SLEEPING){
      getcallerpcs((uint*)p->context->ebp+2, pc);
      for(i=0; i<10 && pc[i] != 0; i++)
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
  }
}

int
getProcInfo(int max, struct uproc *table) {
  static char *states[] = {
  [SLEEPING]  "SLEEPING",
  [RUNNABLE]  "RUNNABLE",
  [RUNNING]   "RUNNING ",
  };
  struct proc *p;
  int i;

 //Lock
  acquire(&ptable.lock);
    //Iterate through each process picking out only the ones it needs
  for(p = ptable.proc, i = 0; i < max && p < &ptable.proc[NPROC]; p++){
    if(p->state == ZOMBIE || p->state == RUNNING || p->state == RUNNABLE || p->state == SLEEPING) {
        table[i].pid = p->pid;
        table[i].uid = p->uid;
        table[i].gid = p->gid;
        table[i].priority = p->priority;
        if (p->parent) 
            table[i].ppid = p->parent->pid;
         else 
            table[i].ppid = p->pid;
        strncpy(table[i].state, states[p->state], sizeof(table[i].state));
        table[i].size = p->sz;
        strncpy(table[i].name, p->name, sizeof(table[i].name));
        ++i;
    }
  }
  release(&ptable.lock);
  return i;
}

int
setPriority(int pid, int priority) {
    struct proc *p;
    int oldPriority;
    int found = -1;

  acquire(&ptable.lock);
  //Iterate through each process picking out only the ones it needs
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
      if (p->pid == pid) {
          oldPriority = p->priority;
          //cprintf("FOUND PID %d   ", pid);
          //cprintf("OLD : %d    NEW : %d\n", oldPriority, priority);
        // If you are setting it to the same priority, then just leave it where it's at
          if (oldPriority == priority){
             // cprintf("Skipped adding to new queue");
              release(&ptable.lock);
              return 0;
          }
          p->priority = priority;
          if (p->state == RUNNABLE) {
              removeFromReadyList(p, oldPriority);
              putOnReadyList(p, priority);
          } 
          found = 0;
          break;
      }
  }
  release(&ptable.lock);
  return found;
}
