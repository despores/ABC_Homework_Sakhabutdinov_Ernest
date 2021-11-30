//
// Created by Ernest on 30.11.2021.
//

#ifndef HW4_ABC_C_CONTAINER_H
#define HW4_ABC_C_CONTAINER_H

#include "Figure.h"

enum {max_length = 10000};

typedef struct Container {
    int len;
    Figure cont[max_length];
} Container;

void InitializeContainer(Container *c);

void ClearContainer(Container *c);

void InputContainer(Container *c, FILE *file);

void InputRandomContainer(Container *c, int sz);

void PrintContainer(Container *c, FILE *file);

void ShellSort(Container *c);

#endif //HW4_ABC_C_CONTAINER_H
