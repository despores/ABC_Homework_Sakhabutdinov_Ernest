cmake_minimum_required(VERSION 3.20)
project (HW4_ABC_C C)

set(CMAKE_C_STANDARD 11)

add_executable(HW4_ABC_C main.c Figure.h Figure.c Sphere.h Parallelepiped.h Tetrahedron.h RandomGenerator.h Tetrahedron.c Sphere.c Parallelepiped.c RandomGenerator.c Container.c Container.h)
