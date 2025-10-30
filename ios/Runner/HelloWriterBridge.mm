#import "HelloWriterBridge.h"

#if __cplusplus
#include "HelloWriter.hpp"
#include <exception>
#include <string>
#endif

@implementation HelloWriterBridge

+ (NSString * _Nullable)writeHelloWithCount:(NSInteger)count toPath:(NSString *)path append:(BOOL)append {
#if __cplusplus
  const char *filePathCStr = [path fileSystemRepresentation];
  if (filePathCStr == NULL) {
    return nil;
  }

  try {
    std::string fullContents = hello_writer::writeHello(filePathCStr, static_cast<int>(count), append);
    return [[NSString alloc] initWithBytes:fullContents.data()
                                    length:fullContents.size()
                                  encoding:NSUTF8StringEncoding];
  } catch (const std::exception &error) {
    NSLog(@"HelloWriterBridge exception: %s", error.what());
    return nil;
  } catch (...) {
    NSLog(@"HelloWriterBridge unknown exception");
    return nil;
  }
#else
  return nil;
#endif
}

@end
