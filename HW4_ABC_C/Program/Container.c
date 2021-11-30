//
// Created by Ernest on 30.11.2021.
//

#include "Container.h"

void InitializeContainer(Container *c) {
    c->len = 0;
}

void ClearContainer(Container *c) {
    c->len = 0;
}

void InputContainer(Container *c, FILE *file) {
    while (!feof(file)) {
        if (InputFigure(&((c->cont)[c->len]), file)) {
            c->len++;
        }
    }
}

void InputRandomContainer(Container *c, int sz) {
    while (c->len < sz) {
        if (InputRandomFigure(&((c->cont)[c->len]))) {
            c->len++;
        }
    }
}

void PrintContainer(Container *c, FILE *file) {
    fprintf(file, "There are %d figures in container\n", c->len);
    for (int i = 0; i < c->len; ++i) {
        PrintFigure(&(c->cont)[i], file);
    }
}

void ShellSort(Container *c) {
    for (int dist = c->len / 2; dist > 0; dist /= 2) {
        for (int i = 0; i < c->len; ++i) {
            for (int j = i; j < c->len; j += dist) {
                if (SquareFigure(&(c->cont)[i]) > SquareFigure(&(c->cont)[j])) {
                    Figure tmp = (c->cont)[i];
                    (c->cont)[i] = (c->cont)[j];
                    (c->cont)[j] = tmp;
                }
            }
        }
    }
}