//
// Created by Ernest on 30.11.2021.
//

#include "Figure.h"

bool InputFigure(Figure *f, FILE *file) {
    int type;
    fscanf(file, "%d", &type);
    switch (type) {
        case 1:
            f->type = SPHERE;
            InputSphere(&(f->sphere), file);
            return true;
        case 2:
            f->type = PARALLELEPIPED;
            InputParallelepiped(&(f->parallelepiped), file);
            return true;
        case 3:
            f->type = TETRA;
            InputTetrahedron(&(f->tetrahedron), file);
            return true;
        default:
            return false;
    }
}

bool InputRandomFigure(Figure *f) {
    int type = Random(3);
    switch (type) {
        case 1:
            f->type = SPHERE;
            InputRandomSphere(&(f->sphere));
            return true;
        case 2:
            f->type = PARALLELEPIPED;
            InputRandomParallelepiped(&(f->parallelepiped));
            return true;
        case 3:
            f->type = TETRA;
            InputRandomTetrahedron(&(f->tetrahedron));
            return true;
        default:
            return false;
    }
}

void PrintFigure(Figure *f, FILE *file) {
    switch(f->type) {
        case SPHERE:
            PrintSphere(&(f->sphere), file);
            break;
        case PARALLELEPIPED:
            PrintParallelepiped(&(f->parallelepiped), file);
            break;
        case TETRA:
            PrintTetrahedron(&(f->tetrahedron), file);
            break;
        default:
            fprintf(file, "Incorrect figure!\n");
    }
}


float SquareFigure(Figure* f)
{
    switch (f->type) {
        case SPHERE:
            return SquareSphere(&(f->sphere));
        case PARALLELEPIPED:
            return SquareParallelepiped(&(f->parallelepiped));
        case TETRA:
            return SquareTetrahedron(&(f->tetrahedron));
        default:
            return 0;
    }
}


