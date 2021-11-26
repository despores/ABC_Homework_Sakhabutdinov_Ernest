#ifndef CUBE_H
#define CUBE_H

#include "Figure.h"

class Parallelepiped : public Figure{
protected:
    int a, b, c;
public:
    Parallelepiped ();
    Parallelepiped (int, int, int, float);
    float square();
    void print(FILE *);
};


#endif //CUBE_H
