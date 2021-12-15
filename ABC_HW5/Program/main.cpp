#include <fstream>
#include <thread>
#include <iostream>
#include <cstring>
#include "Workplace.h"

void errMessage() {
    std::cout << "Некорректные аргументы командой строки!\n"
                 "  Ожидается:\n"
                 "     command -f infile\n"
                 "  Или:\n"
                 "     command -n number\n";
}

int main(int argc, char* argv[]) {
    if (argc != 3) {
        errMessage();
        return 1;
    }
    std::cout << "Формат входного файла должен быть исполнен в виде:\n"
                 "  <тэг задачи> <номер исполняющего программиста>\n"
                 "  Всего у задачи 4 возможных тега, от 1 до 4, и по ним проверяется корректность программы.\n"
                 "  программы первого программиста проверяет второй, программы второго - третий, программы третьего - первый.\n";

    std::cout << "\nНачало работы программы\n\n";
    Workplace workplace;
    if(!strcmp(argv[1], "-f")) {;
        workplace.InputWorkplace(argv[2]);
    }
    else if(!strcmp(argv[1], "-n")) {
        int size = atoi(argv[2]);
        if((size < 1) || (size > 100)) {
            std::cout << "Некорректное количество программ "<< size << ", ожидается от 1 до 100.";
            return 3;
        }
        srand((unsigned int)(time(0)));
        workplace.InputRandomWorkplace(size);
    }
    else {
        errMessage();
        return 2;
    }
    std::thread first_programmer(&Workplace::ProgramistWork, std::ref(workplace), 0);
    std::thread second_programmer(&Workplace::ProgramistWork, std::ref(workplace), 1);
    std::thread third_programmer(&Workplace::ProgramistWork, std::ref(workplace), 2);

    first_programmer.join();
    second_programmer.join();
    third_programmer.join();

    std::cout << "\n Работа программы завершена \n\n";
    return 0;
}
