#ifndef FIGURE_H
#define FIGURE_H

#include <fstream>
#include <math.h>


class Figure {
protected:
    float density;
public:
    virtual ~Figure() = default;
    virtual float square() = 0;
    virtual void print(FILE *) = 0;
};


#endif
