#ifndef CONTAINER_H
#define CONTAINER_H

#include <stdlib.h>
#include <string.h>
#include "Sphere.h"
#include "RightThetreadare.h"
#include "Cube.h"

class Container {
protected:
    size_t size;
    Figure **array;
public:
    Container ();
    ~Container();
    void Add (Figure *);
    void Input (FILE *);
    void Print(FILE *);
    void ShellSort();
    void Delete();
};

#endif //CONTAINER_H
