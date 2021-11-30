//
// Created by Ernest on 30.11.2021.
//

#ifndef HW4_ABC_C_PARALLELEPIPED_H
#define HW4_ABC_C_PARALLELEPIPED_H

#include <stdio.h>
#include "RandomGenerator.h"

typedef struct Parallelepiped {
    int x, y, z;
    float density;
} Parallelepiped;

void InputParallelepiped(Parallelepiped *p, FILE *file);

void InputRandomParallelepiped(Parallelepiped *p);

void PrintParallelepiped(Parallelepiped *p, FILE *file);

float SquareParallelepiped(Parallelepiped *p);

#endif
