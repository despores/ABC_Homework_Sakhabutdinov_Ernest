//
// Created by Ernest on 30.11.2021.
//

#ifndef HW4_ABC_C_FIGURE_H
#define HW4_ABC_C_FIGURE_H

#include <stdio.h>
#include "stdbool.h"
#include "Sphere.h"
#include "Parallelepiped.h"
#include "Tetrahedron.h"
#include "RandomGenerator.h"

typedef enum figure_type{SPHERE, PARALLELEPIPED, TETRA} figure_type;

typedef struct Figure {
    union {
        Sphere sphere;
        Parallelepiped parallelepiped;
        Tetrahedron tetrahedron;
    };
    figure_type type;
} Figure;

bool InputFigure(Figure *f, FILE *file);

bool InputRandomFigure(Figure *f);

void PrintFigure(Figure *f, FILE *file);

void PrintFigure(Figure* f, FILE *file);

float SquareFigure(Figure *f);

#endif