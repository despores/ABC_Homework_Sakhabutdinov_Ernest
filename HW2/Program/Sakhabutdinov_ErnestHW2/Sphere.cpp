#include "Sphere.h"

float Sphere::square() {
    return 4 * M_PI * radius * radius;
}

Sphere::Sphere(int r, float d) {
    radius = r;
    density = d;
}

Sphere::Sphere() {
    radius = 0.;
    density = 0.;
}

void Sphere::print(FILE *file) {
    fprintf (file, "Sphere with radius = %d, density = %f, square = %f\n", radius, density, square());
}
