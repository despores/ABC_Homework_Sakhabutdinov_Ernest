//
// Created by Ernest on 14.12.2021.
//

#ifndef ABC_HW5_WORKPLACE_H
#define ABC_HW5_WORKPLACE_H

#include <queue>
#include "Program.h"
#include <mutex>
#include <thread>
#include <condition_variable>

class Workplace {
private:
    std::queue<Program> working_queue[3];
    std::mutex wip[3];
    std::mutex print_mutex;
    std::condition_variable a;
public:
    void InputWorkplace(char*);
    void InputRandomWorkplace(int);

    void ProgramistWork(int);
};


#endif //ABC_HW5_WORKPLACE_H
