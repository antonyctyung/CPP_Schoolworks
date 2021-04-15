#include <stdio.h>
#include <sys/type.h>
#include <unistd.h>

int value = 32;

int main()
{
    pid_t pid;
    
    pid = fork();

    if (pid == 0) { /* child process */
        value += 8;
        return 0;    
    }
    else if (pid > 0) { /* parent process */
        wait(NULL);
        printf ("PARENT: value = %d\n",value); /* LINE A */
        return 0;
    }
}