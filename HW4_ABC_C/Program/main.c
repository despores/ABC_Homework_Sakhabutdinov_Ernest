#include <time.h>
#include <stdio.h>
#include <string.h>
#include <stdlib.h>

#include "Container.h"

void errMessage1() {
    printf("incorrect command line!\n"
           "  Waited:\n"
           "     command -f infile outfile01 outfile02\n"
           "  Or:\n"
           "     command -n number outfile01 outfile02\n");
}

void errMessage2() {
    printf("incorrect qualifier value!\n"
           "  Waited:\n"
           "     command -f infile outfile01 outfile02\n"
           "  Or:\n"
           "     command -n number outfile01 outfile02\n");
}

int main(int argc, char *argv[])
{
    if (argc != 5) {
        errMessage1();
        return 1;
    }

    printf("Start\n");
    printf("Figure input format should be:\n"
           "    for sphere:\n"
           "        1 radius density\n"
           "    for parallelepiped:\n"
           "        2 x y z density\n"
           "    for tetrahedron:\n"
           "        3 x density\n");
    Container c;
    InitializeContainer(&c);

    if(!strcmp(argv[1], "-f")) {
        FILE* input_file = fopen(argv[2], "r");
        InputContainer(&c, input_file);
    }
    else if(!strcmp(argv[1], "-n")) {
        int size = atoi(argv[2]);
        if((size < 1) || (size > 10000)) {
            printf("incorrect number of figures = %d. Set 0 < number <= 10000\n",
                   size);
            return 3;
        }
        srand((unsigned int)(time(0)));
        InputRandomContainer(&c, size);
    }
    else {
        errMessage2();
        return 2;
    }

    fprintf(stdout, "Filled container:\n");
    PrintContainer(&c, stdout);
    FILE* output_file1 = fopen(argv[3], "w");
    fprintf(output_file1, "Filled container:\n");
    PrintContainer(&c, output_file1);
    fclose(output_file1);

    clock_t start = clock();
    ShellSort(&c);
    clock_t end = clock();
    double calcTime = ((double )(end - start)) / (CLOCKS_PER_SEC + 1.0);
    fprintf(stdout, "Sorted container:\n");
    PrintContainer(&c, stdout);
    fprintf(stdout, "Calculation time = %f\n", calcTime);
    FILE* output_file2 = fopen(argv[4], "w");
    fprintf(output_file2, "Sorted container:\n");
    PrintContainer(&c, output_file2);
    fprintf(output_file2, "Calculation time = %f\n", calcTime);
    fclose(output_file2);

    ClearContainer(&c);
    printf("Done\n");
    return 0;
}