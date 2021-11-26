
#include "RightThetreadare.h"

float Tetrahedron::square() {
    return sqrt(3) * len * len;
}

Tetrahedron::Tetrahedron() {
    len = 0;
    density = 0.;
}

Tetrahedron::Tetrahedron(int length, float d) {
    len = length;
    density = d;
}

void Tetrahedron::print(FILE *file) {
    fprintf (file, "Tetrahedron with side = %d, density = %f, square = %f\n", len, density, square());
}
