
#ifndef RIGHTTHETREADARE_H
#define RIGHTTHETREADARE_H

#include "Figure.h"

class Tetrahedron :public Figure {
protected:
    int len;
public:
    Tetrahedron();
    Tetrahedron(int, float);
    float square ();
    void print(FILE *);
};


#endif //RIGHTTHETREADARE_H
