#include "Cube.h"

float Parallelepiped::square() {
    return 2 * (a * b + b * c + a * c);
}

Parallelepiped::Parallelepiped() {
    a = 0;
    b = 0;
    c = 0;
    density = 0.;
}

Parallelepiped::Parallelepiped(int a1, int b1, int c1, float d) {
    a = a1;
    b = b1;
    c = c1;
    density = d;
}

void Parallelepiped::print(FILE *file) {
    fprintf (file, "Parallelepiped with sides a = %d, b = %d, c = %d, density = %f, square = %f\n", a, b, c, density, square());
}
