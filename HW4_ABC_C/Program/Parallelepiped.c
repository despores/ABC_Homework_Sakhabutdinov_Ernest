//
// Created by Ernest on 30.11.2021.
//

#include "Parallelepiped.h"

void InputParallelepiped(Parallelepiped *p, FILE *file) {
    fscanf(file, "%d%d%d%f", &(p->x), &(p->y), &(p->z), &(p->density));
}

void InputRandomParallelepiped(Parallelepiped *p) {
    p->x = Random(1000);
    p->y = Random(1000);
    p->z = Random(1000);
    p->density = FRandom(1000);
}

void PrintParallelepiped(Parallelepiped *p, FILE *file) {
    fprintf(file, "Parallelepiped with sides x = %d, y = %d, z = %d, density = %f and surface area = %f\n",
            p->x, p->y, p->z, p->density, SquareParallelepiped(p));
}

float SquareParallelepiped(Parallelepiped *p) {
    return 2.0 * (p->x * p->y + p->x * p->z + p->y * p->z);
}