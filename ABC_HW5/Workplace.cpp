//
// Created by Ernest on 14.12.2021.
//

#include "Workplace.h"
#include <fstream>
#include <unistd.h>
#include <iostream>

void Workplace::InputWorkplace(char *ifst) {
    std::ifstream in(ifst);
    int num = 1;
    while (!(in.peek() == EOF)) {
        int tag, writer;
        in >> tag >> writer;
        Program p;
        p.tag = tag;
        p.num = num;
        p.isReady = false;
        num++;
        working_queue[writer - 1].push(p);
    }
}

void Workplace::InputRandomWorkplace(int size) {
    for (int i = 0; i < size; ++i) {
        int tag = rand() % 4 + 1;
        int writer = rand() % 3 + 1;
        Program p;
        p.tag = tag;
        p.num = i + 1;
        p.isReady = false;
        working_queue[writer - 1].push(p);
    }
}

void Workplace::ProgramistWork(int num) {
    int test_num = (num + 2) % 3;
    while (!working_queue[test_num].empty() || !working_queue[num].empty()) {
        {
            std::unique_lock<std::mutex> writing_lock(wip[num]);
            a.wait(writing_lock, [=]() { return !working_queue[num].front().isReady; });
            if (!working_queue[num].empty()) {
                print_mutex.lock();
                std::cout << "Программист №" << num + 1 << " работает над программой №"
                          << working_queue[num].front().num << "...\n";
                print_mutex.unlock();
                int working_tag = rand() % 4 + 1;
                sleep(rand() % 5 + 1);
                print_mutex.lock();
                std::cout << "Программист №" << num + 1 << " закончил работу над программой " <<
                          working_queue[num].front().num << ", выполнив ее под тегом #" << working_tag << ".\n";
                print_mutex.unlock();
                working_queue[num].front().testing_tag = working_tag;
                working_queue[num].front().isReady = true;
                a.notify_one();
            }
        }
        if (!wip[test_num].try_lock()) {
            print_mutex.lock();
            std::cout << "Программист №" << num + 1 << " спит...\n";
            print_mutex.unlock();
            wip[test_num].unlock();
            sleep(1);
        } else {
            wip[test_num].unlock();
        }
        {
            if (!working_queue[test_num].empty()) {
                std::unique_lock<std::mutex> ul(wip[test_num]);
                a.wait(ul, [=]() { return working_queue[test_num].front().isReady; });
                print_mutex.lock();
                std::cout << "Программист №" << num + 1 << " проверяет работу " << working_queue[test_num].front().num <<
                            " программиста №" << test_num + 1 << ".\n";
                print_mutex.unlock();
                sleep(rand() % 5 + 1);
                if (working_queue[test_num].front().tag == working_queue[test_num].front().testing_tag) {
                    print_mutex.lock();
                    std::cout << "Программист №" << num + 1 << " проверил работу " << working_queue[test_num].front().num <<
                            "; она написана правильно. Программист №" << test_num + 1
                            << " переходит к написанию следующей, если у него остались еще ненаписанные программы.\n";
                    print_mutex.unlock();
                    working_queue[test_num].pop();
                } else {
                    print_mutex.lock();
                    std::cout << "Программист №" << num + 1 << " проверил работу " << working_queue[test_num].front().num <<
                            "; она написана неправильно. Программист №" << test_num + 1 << " будет ее переписывать.\n";
                    working_queue[test_num].front().isReady = false;
                    print_mutex.unlock();
                }
                a.notify_one();
            }
        }

        if (!wip[num].try_lock()) {
            print_mutex.lock();
            std::cout << "Программист №" << num + 1 << " спит...\n";
            print_mutex.unlock();
            wip[num].unlock();
            sleep(1);
        } else {
            wip[num].unlock();
        }
    }
    std::cout << "Программист №" << num + 1 << " закончил свой рабочий день!\n";
}