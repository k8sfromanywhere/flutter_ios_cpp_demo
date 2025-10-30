#include "HelloWriter.hpp"

#include <fstream>
#include <sstream>
#include <stdexcept>

namespace hello_writer {

std::string writeHello(const std::string &file_path, int counter, bool append) {
  std::ios_base::openmode mode = std::ios::out;
  mode |= append ? std::ios::app : std::ios::trunc;

  std::ofstream writer(file_path.c_str(), mode);
  if (!writer.is_open()) {
    throw std::runtime_error("Unable to open file for writing");
  }

  writer << "hello world " << counter << '\n';
  writer.close();

  std::ifstream reader(file_path.c_str());
  if (!reader.is_open()) {
    throw std::runtime_error("Unable to open file for reading");
  }

  std::ostringstream buffer;
  buffer << reader.rdbuf();
  return buffer.str();
}

}  // namespace hello_writer
