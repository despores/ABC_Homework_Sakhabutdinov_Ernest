//
// Created by Ernest on 30.11.2021.
//

#include "RandomGenerator.h"
#include "stdlib.h"

int Random(int cap) {
    return rand() % cap + 1;
}

float FRandom(float cap) {
    return (float) rand() / (float) RAND_MAX * cap;
}