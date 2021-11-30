//
// Created by Ernest on 30.11.2021.
//

#ifndef HW4_ABC_C_TETRAHEDRON_H
#define HW4_ABC_C_TETRAHEDRON_H

#include <stdio.h>
#include "RandomGenerator.h"

typedef struct Tetrahedron {
    int x;
    float density;
} Tetrahedron;

void InputTetrahedron(Tetrahedron *t, FILE *file);

void InputRandomTetrahedron(Tetrahedron *t);

void PrintTetrahedron(Tetrahedron *t, FILE *file);

float SquareTetrahedron(Tetrahedron *t);

#endif //HW4_ABC_C_TETRAHEDRON_H
