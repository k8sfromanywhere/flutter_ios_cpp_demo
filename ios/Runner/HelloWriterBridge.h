#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HelloWriterBridge : NSObject

/// Invokes the underlying C++ writer and returns the full file contents after the write.
+ (NSString * _Nullable)writeHelloWithCount:(NSInteger)count toPath:(NSString *)path append:(BOOL)append;

@end

NS_ASSUME_NONNULL_END
