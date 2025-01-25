#include <iostream>
#include <string>
#include <sstream>

int main() {
    std::string line;
    int total_sum = 0, total_count = 0;

    while (std::getline(std::cin, line)) {
        std::istringstream iss(line);
        std::string date;
        int temp;

        if (!(iss >> date >> temp)) {
            // Handle invalid input line
            std::cerr << "Invalid input: " << line << std::endl;
            continue;
        }

        total_sum += temp;
        total_count++;
    }

    // Output the total average
    if (total_count > 0) {
        std::cout << static_cast<double>(total_sum) / total_count << std::endl;
    } else {
        std::cerr << "No valid data provided." << std::endl;
    }

    return 0;
}