#include "Container.h"
#include <time.h>


int main(int argc, char *argv[]) {
    Container cont;
    FILE *input = fopen (argv[1], "r"), *output = fopen (argv[2], "w");
    clock_t time = clock();
    cont.Input(input);
    cont.ShellSort();
    cont.Print(output);
    time = clock() - time;
    printf ("Time = %f", (double)time / CLOCKS_PER_SEC);
    fclose (input);
    fclose (output);
    cont.Delete();
    return 0;
}