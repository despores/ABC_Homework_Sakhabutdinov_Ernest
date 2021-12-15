cmake_minimum_required(VERSION 3.20)
project(ABC_HW5)

set(CMAKE_CXX_STANDARD 17)

SET(CMAKE_CXX_FLAGS -pthread)

add_executable(ABC_HW5 main.cpp Workplace.cpp Workplace.h Program.h)
