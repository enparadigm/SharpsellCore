#ifdef __OBJC__
#import <UIKit/UIKit.h>
#else
#ifndef FOUNDATION_EXPORT
#if defined(__cplusplus)
#define FOUNDATION_EXPORT extern "C"
#else
#define FOUNDATION_EXPORT extern
#endif
#endif
#endif

#import "IsLockScreenPlugin.h"

FOUNDATION_EXPORT double is_lock_screenVersionNumber;
FOUNDATION_EXPORT const unsigned char is_lock_screenVersionString[];

