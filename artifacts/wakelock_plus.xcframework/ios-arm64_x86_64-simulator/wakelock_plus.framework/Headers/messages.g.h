// Autogenerated from Pigeon (v10.1.0), do not edit directly.
// See also: https://pub.dev/packages/pigeon

#import <Foundation/Foundation.h>

@protocol FlutterBinaryMessenger;
@protocol FlutterMessageCodec;
@class FlutterError;
@class FlutterStandardTypedData;

NS_ASSUME_NONNULL_BEGIN

@class FLTToggleMessage;
@class FLTIsEnabledMessage;

/// Message for toggling the wakelock on the platform side.
@interface FLTToggleMessage : NSObject
+ (instancetype)makeWithEnable:(nullable NSNumber *)enable;
@property(nonatomic, strong, nullable) NSNumber * enable;
@end

/// Message for reporting the wakelock state from the platform side.
@interface FLTIsEnabledMessage : NSObject
+ (instancetype)makeWithEnabled:(nullable NSNumber *)enabled;
@property(nonatomic, strong, nullable) NSNumber * enabled;
@end

/// The codec used by FLTWakelockPlusApi.
NSObject<FlutterMessageCodec> *FLTWakelockPlusApiGetCodec(void);

@protocol FLTWakelockPlusApi
- (void)toggleMsg:(FLTToggleMessage *)msg error:(FlutterError *_Nullable *_Nonnull)error;
/// @return `nil` only when `error != nil`.
- (nullable FLTIsEnabledMessage *)isEnabledWithError:(FlutterError *_Nullable *_Nonnull)error;
@end

extern void FLTWakelockPlusApiSetup(id<FlutterBinaryMessenger> binaryMessenger, NSObject<FLTWakelockPlusApi> *_Nullable api);

NS_ASSUME_NONNULL_END