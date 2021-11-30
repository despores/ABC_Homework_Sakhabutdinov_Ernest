//
// Created by Ernest on 30.11.2021.
//

#ifndef HW4_ABC_C_SPHERE_H
#define HW4_ABC_C_SPHERE_H

#include <stdio.h>
#include "RandomGenerator.h"

typedef struct Sphere {
    int radius;
    float density;
} Sphere;

void InputSphere(Sphere *s, FILE *file);

void InputRandomSphere(Sphere *s);

void PrintSphere(Sphere *s, FILE *file);

float SquareSphere(Sphere *s);

#endif //HW4_ABC_C_SPHERE_H
