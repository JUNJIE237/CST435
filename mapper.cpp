#include <iostream>
#include <sstream>
#include <string>

int main() {
    std::string line;
    while (std::getline(std::cin, line)) {
        std::istringstream iss(line);
        std::string date, temp;
        if (std::getline(iss, date, ',') && std::getline(iss, temp)) {
            std::cout << date << "\t" << temp << std::endl;
        }
    }
    return 0;
}