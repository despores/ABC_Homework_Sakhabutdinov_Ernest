#include <stdio.h>
#include <stdlib.h>
#include <time.h>

int main() {
     const int SIZE = 10000;
    int random;
    const float FRAND_MAX = 1000;
    float frandom;
    srand(time(NULL));
    FILE *input = fopen("test2.txt", "w");
    for (int i = 0; i < SIZE; ++i) {
        random = rand() % 3;
        switch (random) {
            case 0:
                fprintf(input, "%s", "tetra\n");
                random = 1 + rand() % 1000;
                fprintf(input, "%d ", random);
                frandom = FRAND_MAX * (float)rand() / RAND_MAX;
                fprintf(input, "%f\n", frandom);
                break;
            case 1:
                fprintf(input, "%s", "sphere\n");
                random = 1 + rand() % 1000;
                fprintf(input, "%d ", random);
                frandom = FRAND_MAX * (float)rand() / RAND_MAX;
                fprintf(input, "%f\n", frandom);
                break;
            case 2:
                fprintf(input, "%s", "cube\n");
                random = 1 + rand() % 1000;
                fprintf(input, "%d ", random);
                random = 1 + rand() % 1000;
                fprintf(input, "%d ", random);
                random = 1 + rand() % 1000;
                fprintf(input, "%d ", random);
                frandom = FRAND_MAX * (float)rand() / RAND_MAX;
                fprintf(input, "%f\n", frandom);
                break;
        }
    }
    fclose(input);
}