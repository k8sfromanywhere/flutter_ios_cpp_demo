#pragma once

#include <string>

namespace hello_writer {

// Appends "hello world <counter>" into the file and returns its full contents.
std::string writeHello(const std::string &file_path, int counter, bool append);

}  // namespace hello_writer
