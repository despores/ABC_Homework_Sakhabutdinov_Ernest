//
// Created by Ernest on 30.11.2021.
//

#include "Tetrahedron.h"
#include <math.h>

void InputTetrahedron(Tetrahedron *t, FILE *file) {
    fscanf(file, "%d%f", &(t->x), &(t->density));
}

void InputRandomTetrahedron(Tetrahedron *t) {
    t->x = Random(1000);
    t->density = FRandom(1000);
}

void PrintTetrahedron(Tetrahedron  *t, FILE *file) {
    fprintf(file, "Tetrahedron with side = %d, density = %f and surface area = %f\n",
            t->x, t->density, SquareTetrahedron(t));
}

float SquareTetrahedron(Tetrahedron *t) {
    return sqrtf(3) * t->x * t->x;
}