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
        // Dependencies declare other packages that this package depends on.
        //         .package(url: "https://github.com/firebase/firebase-ios-sdk.git", from: "8.12.1"),
//                .Package(url: "https://github.com/firebase/firebase-ios-sdk.git", .upToNextMajor(from: "8.12.1"))
//        .package(url: "https://github.com/firebase/firebase-ios-sdk.git", .upToNextMajor(from: "8.12.1"))
    ],
    targets: [
        .target(
            name: "SharpsellCore",
            dependencies: [
                //                "Flutter",
                "FlutterPluginRegistrant",
                //                "App",
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
                "firebase_messaging",
                //                                "FirebaseAnalytics",
                //                                "FirebaseCore",
                //                                "FirebaseCoreDiagnostics",
                //                                "FirebaseCrashlytics",
                //                                "FirebaseInstallations",
                //                                "FirebaseMessaging",
//                .product(name: "FirebaseMessaging", package: "firebase-ios-sdk"),
//                .product(name: "FirebaseCrashlytics", package: "firebase-ios-sdk"),
//                .product(name: "FirebaseAnalytics", package: "firebase-ios-sdk"),
                "flutter_custom_tabs",
                "flutter_inappwebview",
                "fluttercontactpicker",
                "fluttertoast",
//                "FMDB",
                //                                "GoogleAppMeasurement",
                //                                "GoogleDataTransport",
//                "GoogleUtilities",
                "image_cropper",
                "image_picker_ios",
                "just_audio",
                "libwebp",
                "light_compressor",
                //                "nanopb",
                "open_file",
                "OrderedSet",
                "package_info_plus",
                "path_provider_ios",
                "permission_handler_apple",
                "pdfx",
                "Reachability",
                "share_extend",
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
                "uni_links",
                "url_launcher_ios",
                "video_player_avfoundation",
                "video_thumbnail",
                "wakelock",
                "webview_flutter_wkwebview"
                
            ]),
        //        .testTarget(
        //            name: "SharpsellcoreTests",
        //            dependencies: ["Sharpsellcore"]),
        
            .binaryTarget(name: "FlutterPluginRegistrant",
                          path: "artifacts/FlutterPluginRegistrant.xcframework"),
        
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
        
            .binaryTarget(name: "firebase_messaging",
                          path: "artifacts/firebase_messaging.xcframework"),
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
        
            .binaryTarget(name: "just_audio",
                          path: "artifacts/just_audio.xcframework"),
        
            .binaryTarget(name: "libwebp",
                          path: "artifacts/libwebp.xcframework"),
        
            .binaryTarget(name: "light_compressor",
                          path: "artifacts/light_compressor.xcframework"),
        
        //            .binaryTarget(name: "nanopb",
        //                          path: "artifacts/nanopb.xcframework"),
        
            .binaryTarget(name: "open_file",
                          path: "artifacts/open_file.xcframework"),
        
            .binaryTarget(name: "OrderedSet",
                          path: "artifacts/OrderedSet.xcframework"),
        
            .binaryTarget(name: "pdfx",
                          path: "artifacts/pdfx.xcframework"),
        
            .binaryTarget(name: "package_info_plus",
                          path: "artifacts/package_info_plus.xcframework"),
        
            .binaryTarget(name: "path_provider_ios",
                          path: "artifacts/path_provider_ios.xcframework"),
        
            .binaryTarget(name: "permission_handler_apple",
                          path: "artifacts/permission_handler_apple.xcframework"),
        
            .binaryTarget(name: "Reachability",
                          path: "artifacts/Reachability.xcframework"),
        
            .binaryTarget(name: "share_extend",
                          path: "artifacts/share_extend.xcframework"),
        
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
        
            .binaryTarget(name: "uni_links",
                          path: "artifacts/uni_links.xcframework"),
        
            .binaryTarget(name: "url_launcher_ios",
                          path: "artifacts/url_launcher_ios.xcframework"),
        
            .binaryTarget(name: "video_player_avfoundation",
                          path: "artifacts/video_player_avfoundation.xcframework"),
        
            .binaryTarget(name: "video_thumbnail",
                          path: "artifacts/video_thumbnail.xcframework"),
        
            .binaryTarget(name: "wakelock",
                          path: "artifacts/wakelock.xcframework"),
        
            .binaryTarget(name: "webview_flutter_wkwebview",
                          path: "artifacts/webview_flutter_wkwebview.xcframework"),
        
    ]
)
