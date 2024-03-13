// swift-tools-version:5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SharpsellCore",
    platforms: [.iOS(.v12)],
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(
            name: "SharpsellCore",
            targets: ["SharpsellCore"]),
    ],
    dependencies: [
        .package(url: "https://github.com/moengage/MoEngage-iOS-SDK", .exact("9.15.2")),
        .package(url: "https://github.com/moengage/MoEngage-iOS-InApps", .exact("4.14.1"))
        ],
    targets: [
        .target(
            name: "SharpsellCore",
            dependencies: [
                "MoEngage-iOS-SDK",
//                .product(name: "MoEngage-iOS-SDK", package: "MoEngage-iOS-SDK"),
                .product(name: "MoEngageInApps", package: "MoEngage-iOS-InApps"),
//                "MoEngage-iOS-InApps",
                //                "Flutter",
                //                "App",
                "app_links",
                "audio_session",
                "awesome_notifications",
                "camera_avfoundation",
                "connectivity_plus",
                "contacts_service",
                "device_info_plus",
                //                                "FBLPromises",
                "firebase_analytics",
                "firebase_core",
                "firebase_crashlytics",
//                "FirebaseCoreExtension",
//                "FirebaseCoreInternal",
//                "FirebaseSessions",
                "flutter_custom_tabs",
                "flutter_inappwebview",
                "fluttercontactpicker",
                "FlutterPluginRegistrant",
                "fluttertoast",
//                "FMDB",
                //                                "GoogleAppMeasurement",
                //                                "GoogleDataTransport",
//                "GoogleUtilities",
                "image_cropper",
                "image_picker_ios",
                "IosAwnCore",
                "is_lock_screen",
                "just_audio",
                "libwebp",
                "light_compressor",
                "moengage_flutter_ios",
                "MoEngagePluginBase",
                "open_filex",
                "OrderedSet",
                "package_info_plus",
                "path_provider_foundation",
                "pdfx",
                "permission_handler_apple",
                "pointer_interceptor_ios",
//                "Promises",
                "Reachability",
                "record",
                "rive_common",
                "share_plus",
                "share",
                "shared_preferences_ios",
                "sharpsell",
                "sqflite",
                "sqlite3_flutter_libs",
                "sqlite3",
                "store_redirect",
                "Toast",
                "TOCropViewController",
                "url_launcher_ios",
                "video_player_avfoundation",
                "video_thumbnail",
                "wakelock_plus",
                "webview_flutter_wkwebview"
                
            ]),
        //        .testTarget(
        //            name: "SharpsellcoreTests",
        //            dependencies: ["Sharpsellcore"]),
        
            .binaryTarget(name: "FlutterPluginRegistrant",
                          path: "artifacts/FlutterPluginRegistrant.xcframework"),
        
            .binaryTarget(name: "app_links",
                          path: "artifacts/app_links.xcframework"),
        
            .binaryTarget(name: "audio_session",
                          path: "artifacts/audio_session.xcframework"),
        
            .binaryTarget(name: "awesome_notifications",
                          path: "artifacts/awesome_notifications.xcframework"),
        
            .binaryTarget(name: "camera_avfoundation",
                          path: "artifacts/camera_avfoundation.xcframework"),
        
            .binaryTarget(name: "connectivity_plus",
                          path: "artifacts/connectivity_plus.xcframework"),
        
            .binaryTarget(name: "contacts_service",
                          path: "artifacts/contacts_service.xcframework"),
        
            .binaryTarget(name: "device_info_plus",
                          path: "artifacts/device_info_plus.xcframework"),
        
        //            .binaryTarget(name: "FBLPromises",
        //                          path: "artifacts/FBLPromises.xcframework"),
        
            .binaryTarget(name: "firebase_analytics",
                          path: "artifacts/firebase_analytics.xcframework"),
        
            .binaryTarget(name: "firebase_core",
                          path: "artifacts/firebase_core.xcframework"),
        
            .binaryTarget(name: "firebase_crashlytics",
                          path: "artifacts/firebase_crashlytics.xcframework"),
        
//            .binaryTarget(name: "FirebaseCoreExtension",
//                          path: "artifacts/FirebaseCoreExtension.xcframework"),
        
//            .binaryTarget(name: "FirebaseCoreInternal",
//                          path: "artifacts/FirebaseCoreInternal.xcframework"),
        
//            .binaryTarget(name: "FirebaseSessions",
//                          path: "artifacts/FirebaseSessions.xcframework"),
        
//            .binaryTarget(name: "firebase_messaging",
//                          path: "artifacts/firebase_messaging.xcframework"),
        //
        //            .binaryTarget(name: "FirebaseAnalytics",
        //                          path: "artifacts/FirebaseAnalytics.xcframework"),
        //
        //            .binaryTarget(name: "FirebaseCore",
        //                          path: "artifacts/FirebaseCore.xcframework"),
        //
        //            .binaryTarget(name: "FirebaseCoreDiagnostics",
        //                          path: "artifacts/FirebaseCoreDiagnostics.xcframework"),
        //
        //            .binaryTarget(name: "FirebaseCrashlytics",
        //                          path: "artifacts/FirebaseCrashlytics.xcframework"),
        //
        //            .binaryTarget(name: "FirebaseInstallations",
        //                          path: "artifacts/FirebaseInstallations.xcframework"),
        //
        //            .binaryTarget(name: "FirebaseMessaging",
        //                          path: "artifacts/FirebaseMessaging.xcframework"),
        
            .binaryTarget(name: "flutter_custom_tabs",
                          path: "artifacts/flutter_custom_tabs.xcframework"),
        
            .binaryTarget(name: "flutter_inappwebview",
                          path: "artifacts/flutter_inappwebview.xcframework"),
        
            .binaryTarget(name: "fluttercontactpicker",
                          path: "artifacts/fluttercontactpicker.xcframework"),
        
            
            .binaryTarget(name: "fluttertoast",
                          path: "artifacts/fluttertoast.xcframework"),
        
//            .binaryTarget(name: "FMDB",
//                          path: "artifacts/FMDB.xcframework"),
        
        //            .binaryTarget(name: "GoogleAppMeasurement",
        //                          path: "artifacts/GoogleAppMeasurement.xcframework"),
        //
        //            .binaryTarget(name: "GoogleDataTransport",
        //                          path: "artifacts/GoogleDataTransport.xcframework"),
        
//            .binaryTarget(name: "GoogleUtilities",
//                          path: "artifacts/GoogleUtilities.xcframework"),
        
            .binaryTarget(name: "image_cropper",
                          path: "artifacts/image_cropper.xcframework"),
        
            .binaryTarget(name: "image_picker_ios",
                          path: "artifacts/image_picker_ios.xcframework"),
        
            .binaryTarget(name: "IosAwnCore",
                          path: "artifacts/IosAwnCore.xcframework"),
        
            .binaryTarget(name: "is_lock_screen",
                          path: "artifacts/is_lock_screen.xcframework"),
        
            .binaryTarget(name: "just_audio",
                          path: "artifacts/just_audio.xcframework"),
        
            .binaryTarget(name: "libwebp",
                          path: "artifacts/libwebp.xcframework"),
        
            .binaryTarget(name: "light_compressor",
                          path: "artifacts/light_compressor.xcframework"),
        
        //            .binaryTarget(name: "nanopb",
        //                          path: "artifacts/nanopb.xcframework"),
            .binaryTarget(name: "moengage_flutter_ios",
                          path: "artifacts/moengage_flutter_ios.xcframework"),
        
            .binaryTarget(name: "MoEngagePluginBase",
                          path: "artifacts/MoEngagePluginBase.xcframework"),
        
            .binaryTarget(name: "open_filex",
                          path: "artifacts/open_filex.xcframework"),
        
            .binaryTarget(name: "OrderedSet",
                          path: "artifacts/OrderedSet.xcframework"),
        
            .binaryTarget(name: "pdfx",
                          path: "artifacts/pdfx.xcframework"),
        
            .binaryTarget(name: "package_info_plus",
                          path: "artifacts/package_info_plus.xcframework"),
        
            .binaryTarget(name: "path_provider_foundation",
                          path: "artifacts/path_provider_foundation.xcframework"),
        
            .binaryTarget(name: "permission_handler_apple",
                          path: "artifacts/permission_handler_apple.xcframework"),
        
            .binaryTarget(name: "pointer_interceptor_ios",
                          path: "artifacts/pointer_interceptor_ios.xcframework"),
        
//            .binaryTarget(name: "Promises",
//                          path: "artifacts/Promises.xcframework"),
        
            .binaryTarget(name: "Reachability",
                          path: "artifacts/Reachability.xcframework"),
        
            .binaryTarget(name: "record",
                          path: "artifacts/record.xcframework"),
        
            .binaryTarget(name: "rive_common",
                          path: "artifacts/rive_common.xcframework"),
        
            .binaryTarget(name: "share_plus",
                          path: "artifacts/share_plus.xcframework"),
        
            .binaryTarget(name: "share",
                          path: "artifacts/share.xcframework"),
        
            .binaryTarget(name: "shared_preferences_ios",
                          path: "artifacts/shared_preferences_ios.xcframework"),
        
            .binaryTarget(name: "sharpsell",
                          path: "artifacts/sharpsell.xcframework"),
        
            .binaryTarget(name: "sqflite",
                          path: "artifacts/sqflite.xcframework"),
        
            .binaryTarget(name: "sqlite3_flutter_libs",
                          path: "artifacts/sqlite3_flutter_libs.xcframework"),
        
            .binaryTarget(name: "sqlite3",
                          path: "artifacts/sqlite3.xcframework"),
        
            .binaryTarget(name: "store_redirect",
                          path: "artifacts/store_redirect.xcframework"),
        
            .binaryTarget(name: "Toast",
                          path: "artifacts/Toast.xcframework"),
        
            .binaryTarget(name: "TOCropViewController",
                          path: "artifacts/TOCropViewController.xcframework"),
        
        
            .binaryTarget(name: "url_launcher_ios",
                          path: "artifacts/url_launcher_ios.xcframework"),
        
            .binaryTarget(name: "video_player_avfoundation",
                          path: "artifacts/video_player_avfoundation.xcframework"),
        
            .binaryTarget(name: "video_thumbnail",
                          path: "artifacts/video_thumbnail.xcframework"),
        
            .binaryTarget(name: "wakelock_plus",
                          path: "artifacts/wakelock_plus.xcframework"),
        
            .binaryTarget(name: "webview_flutter_wkwebview",
                          path: "artifacts/webview_flutter_wkwebview.xcframework"),
        
    ]
)
