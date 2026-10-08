#ifndef Libclash_h
#define Libclash_h

#include <Foundation/Foundation.h>

#ifdef __cplusplus
extern "C" {
#endif

NSString* _Nullable LibclashStart(NSString* _Nonnull homeDir, NSString* _Nonnull configPath);
void LibclashStop(void);
BOOL LibclashIsRunning(void);
void LibclashGetTraffic(int64_t* _Nonnull up, int64_t* _Nonnull down);

#ifdef __cplusplus
}
#endif

#endif /* Libclash_h */
