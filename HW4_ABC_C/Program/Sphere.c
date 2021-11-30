//
// Created by Ernest on 30.11.2021.
//

#include "Sphere.h"

# define M_PI 3.14159265358979323846

void InputSphere(Sphere *s, FILE *file) {
    fscanf(file, "%d%f", &(s->radius), &(s->density));
}

void InputRandomSphere(Sphere *s) {
    s->radius = Random(1000);
    s->density = FRandom(1000);
}

void PrintSphere(Sphere *s, FILE *file) {
    fprintf(file, "Sphere with radius = %d, density = %f and surface area = %f\n",
            s->radius, s->density, SquareSphere(s));
}

float SquareSphere(Sphere *s) {
    return 4.0 * M_PI * s->radius * s->radius;
}