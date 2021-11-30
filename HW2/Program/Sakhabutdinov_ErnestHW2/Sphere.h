#ifndef SPHERE_H
#define SPHERE_H


#include "Figure.h"

class Sphere : public Figure {
protected:
    int radius;
public:
    Sphere ();
    Sphere(int, float);
    float square ();
    void print(FILE *);
};


#endif //SPHERE_H
