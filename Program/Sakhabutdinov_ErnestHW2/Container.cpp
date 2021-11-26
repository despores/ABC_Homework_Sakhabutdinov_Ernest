#include "Container.h"

Container::Container() {
    array = (Figure **) calloc (1, sizeof(Figure *));
    size = 0;
}

Container::~Container() {
    delete array;
}

void Container::Add(Figure *fig) {
    array = (Figure **)realloc (array, (size + 1) * sizeof(Figure *));
    array[size] = fig;
    size++;
}

void Container::Print(FILE *file) {
    for (size_t i = 0; i < size; i++)
        array[i]->print(file);
}

void Container::ShellSort() {
    for (size_t dist = size / 2; dist > 0; dist /= 2)
        for (size_t i = 0; i < size; i++)
        {
            for (size_t j = i; j < size; j += dist)
            {
                if (array[i]->square() > array[j]->square())
                {
                    Figure *t = array[i];
                    array[i] = array[j];
                    array[j] = t;
                }
            }
        }
}

void Container::Input (FILE *input)
{
    int N;
    fscanf (input, "%d", &N);
    for (int i = 0; i < N;  i++)
    {
        char *type = (char *)calloc (10, sizeof(char));
        fscanf (input, "%s", type);
        if (!strcmp (type, "sphere"))
        {
            float radius;
            fscanf (input, "%f", &radius);
            float density;
            fscanf (input, "%f", &density);
            Figure *s = new Sphere (radius, density);
            this->Add(s);
        }
        else if (!strcmp (type, "tetra"))
        {
            int len;
            fscanf (input, "%d", &len);
            float density;
            fscanf (input, "%f", &density);
            Figure *s = new Tetrahedron (len, density);
            this->Add(s);
        }
        else if (!strcmp (type, "cube"))
        {
            int a, b, c;
            fscanf (input, "%d %d %d", &a, &b, &c);
            float density;
            fscanf (input, "%f", &density);
            Figure *s = new Parallelepiped (a, b, c, density);
            this->Add(s);
        }
    }
}

void Container::Delete() {
    for (int i = 0; i < size; i++)
        free (array[i]);
}

