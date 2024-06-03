//
//  SharpsellWrapper.swift
//  Sharpsell
//
//  Created by Surya on 19/12/21.
//

import Foundation
import Flutter
import FlutterPluginRegistrant
import os
import AVFoundation
import MoEngageSDK
import moengage_flutter_ios

//MARK: - Enum Declaration
fileprivate enum FlutterMethods: String{
    case initialize = "initialize"
    case open = "open"
    case clearData = "clear_data"
    case enableLogs = "enable_logs_in_production_sdk"
    case isSharpsellNotification = "is_sharpsell_notification"
    case showNotification = "show_notification"
    case handleNotificationRedirection = "handle_notification_redirection"
    case getMoEngageCompanyId = "get_moEngage_company_id"
}

public enum SharpSellError: Error{
    case flutterEngineFailure
    case flutterError
    case flutterMethodNotImplemented
}

public struct SharpSellWrapper{
    
    //MARK: - Property Declaration
    var flutterEngine: FlutterEngine?
    var isFlutterEngineCreated = false
    private let flutterMethodChannelName = "sharpsell_flutter_channel"
    private let flutterEngineIdentifer = "sharpsell_flutter_engine"
    
    //MARK: - Init Declaration
    public init (){}
    
    //MARK: - Private Methods
    private func getFlutterViewController() throws -> FlutterViewController {
        guard let flutterEngine = self.flutterEngine else {
            NSLog("Sharpsell Error: Flutter Engine is nil.")
            throw SharpSellError.flutterEngineFailure
        }
        let flutterViewController = FlutterViewController(engine: flutterEngine, nibName: nil, bundle: nil)
        return flutterViewController
    }
    
    /// Creating Flutter method channel.
    private func getFlutterMethodChannel() throws -> FlutterMethodChannel{
        let methodChannel = FlutterMethodChannel(name: flutterMethodChannelName, binaryMessenger: try getFlutterViewController().binaryMessenger)
        return methodChannel
    }
    
    //MARK: - Public Methods
    /// Creating Flutter Engine to use the flutter screens in native.
    ///- Note: Try to avoid calling this function multiple times because creating the flutter engine again and again will cause an memory issue and you may face some lag in the UI.
    ///- Recommeded: Call this method in App delegatge if you using native iOS or call this in app landing function which will be called only once in the app life cycle
    public mutating func createFlutterEngine(){
        NSLog("Sharpsell: Creating Flutter Engine....")
        //            os_log(.info, log: Log.tracking, "Creating Flutter Engine...")
        do {
            self.flutterEngine = try FlutterEngine(name: flutterEngineIdentifer)
            guard let myengine = self.flutterEngine else {
                NSLog("Sharpsell Error: Flutter Engine not assigned")
                return
            }
            myengine.run()
            NSLog("Sharpsell: Flutter Engine Sucessfully Created!")
            GeneratedPluginRegistrant.register(with: myengine)
            isFlutterEngineCreated = true
        } catch{
            NSLog("Sharpsell: Flutter Engine causing unexpected error - \(error)")
        }
        
    }
    
    /// initialize the flutter communication between native and flutter code
    /// - Parameters:
    ///   - data: Pass the smart sell credentaials with the need params
    ///   - onSuccess: Success colsure will be called on succful initialization
    ///   - onFailure: Failure closure will be called incase of any failure
    public func initialize(smartsellParameters: [String:Any],
                           onSucces: @escaping () -> (),
                           onFailure: @escaping (_ message: String,_ errorType: SharpSellError) -> ()){
        
        do {
            let flutterMethodChannel = try getFlutterMethodChannel()
            
            //Convert Dict to json
            if let theJSONData = try?  JSONSerialization.data(
                withJSONObject: smartsellParameters,
                options: .prettyPrinted),
               //Convert json to String
               let theJSONText = String(data: theJSONData,
                                        encoding: String.Encoding.ascii) {
                NSLog("Sharpsell: Calling initialize flutter invoke method.")
                flutterMethodChannel.invokeMethod(FlutterMethods.initialize.rawValue,
                                                  arguments: theJSONText) { (flutterResult) in
                    if flutterResult is FlutterError {
                        if let res = flutterResult as? FlutterError{
                            NSLog("Sharpsell Error: Initialize - Error Code : \(String(describing: res.code)) and Error Messaoge : \(String(describing: res.message))")
                            //                            os_log(.error, log: Log.flutterError, "initialize: Error Code : %d", res.code)
                            //                            os_log(.error, log: Log.flutterError, "initialize: Error Messaoge : %{public}s", res.message ?? "")
                            onFailure(res.message ?? "Flutter Error", SharpSellError.flutterError)
                        }else {
                            NSLog("Sharpsell Error: Initialize - Flutter Error: UnKnown")
                        }
                        
                    }
                    if FlutterMethodNotImplemented.isEqual(flutterResult){
                        NSLog("Sharpsell Error: Initialize - Method \(FlutterMethods.initialize.rawValue) is not implemented in Sharpsell SDK")
                        onFailure("Flutter method not implemented", SharpSellError.flutterMethodNotImplemented)
                        return
                    } else {
                        onSucces()
                        print("Sharpsell - Calling mo engage app  ")
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                            getMoEngageAppId { moEngagaeAppId in
                                print("Sharpsell - in getMoEngageAppId - \(moEngagaeAppId)")
                                var sdkConfig = MoEngageSDKConfig(withAppID: moEngagaeAppId)
//                                sdkConfig.enableLogs = true
                                MoEngageInitializer.sharedInstance.initializeDefaultInstance(sdkConfig)
                                
                            } onFailure: { errorMessage, SharpSellError in
                                print(errorMessage)
                            }
                        }
                        
                        
                    }
                }
                
            } else {
                NSLog("Sharpsell Error: Initialize - JSON Parsing failure")
            }
        } catch (SharpSellError.flutterEngineFailure){
            NSLog("Sharpsell Error: Initialize - Flutter Engine Not Available")
        } catch {
            NSLog("Sharpsell Error: Initialize - Flutter Engine Not Available")
        }
    }
    
    /// Opens the flutter home screen
    /// - Parameters:
    ///   - onSuccess: Success colsure will be called on succesfuly launching the flutter screen
    ///   - flutterViewController: On succeful invoke call, flutter view controller will be sent back. Use this to show the flutter screen in you app
    ///   - onFailure: Failure closure will be called incase of any failure
    ///   - message: Flutter error message
    ///   - errorType: Passing the smartSellError enum by using this you check the type of error
    public func open(arguments: String,
                     onSucess: @escaping (_ flutterViewController: UIViewController) -> (),
                     onFailure: @escaping (_ message: String,_ errorType: SharpSellError) -> ()){
        do {
            let flutterMethodChannel = try getFlutterMethodChannel()
            NSLog("Sharpsell : Calling Open flutter invoke method")
            
            var sharpsellOpenData = "{}"
            if !arguments.isEmpty{
                sharpsellOpenData = arguments
            }
            flutterMethodChannel.invokeMethod(FlutterMethods.open.rawValue,
                                              arguments: sharpsellOpenData) {  (flutterResult) in
                
                if (flutterResult is FlutterError) {
                    if let res = flutterResult as? FlutterError{
                        NSLog("Sharpsell Error: open - Error Code : \(String(describing: res.code)) and Error Messaoge : \(String(describing: res.message))")
                        onFailure(res.message ?? "Flutter Error", SharpSellError.flutterError)
                    }else {
                        NSLog("Sharpsell Error: open - Flutter Error: UnKnown")
                    }
                }
                
                if FlutterMethodNotImplemented.isEqual(flutterResult){
                    NSLog("Sharpsell Error: open - Method \(FlutterMethods.open.rawValue) is not implemented in Sharpsell SDK")
                    onFailure("Flutter method not implemented", SharpSellError.flutterMethodNotImplemented)
                    return
                } else {
                    do {
                        //Success
                        let flutterViewController = try getFlutterViewController()
                        onSucess(flutterViewController)
                    } catch (SharpSellError.flutterEngineFailure){
                        NSLog("Sharpsell Error: Open - Failed to get the FlutterVC due to flutterEngineFailure")
                    } catch {
                        NSLog("Sharpsell Error: Open - Failed to get the FlutterVC")
                    }
                    
                }
            }
            
        } catch (SharpSellError.flutterEngineFailure){
            NSLog("Sharpsell Error: Open - Flutter Engine Not Available")
        } catch {
            NSLog("Sharpsell Error: Open - Flutter Engine Not Available")
        }
    }
    
    
    /// Use this function to get the app ID
    /// - Parameters:
    ///   - onSuccess: On success, if the notification is sharpsell then sharpsell notification will be shown
    ///   - onFailure: Failure closure will be called incase of any failure
    ///   - message: Flutter error message
    ///   - errorType: Passing the smartSellError enum by using this you check the type of error
    private func getMoEngageAppId(onSucess: @escaping (_ result: String) -> (),
                                  onFailure: @escaping (_ message: String,
                                                        _ errorType: SharpSellError) -> ()){
        do {
            let flutterMethodChannel = try getFlutterMethodChannel()
            NSLog("Sharpsell: isSharpsellNotification - Calling showNotification flutter invoke method")
            
            
            flutterMethodChannel.invokeMethod(FlutterMethods.getMoEngageCompanyId.rawValue,
                                              arguments: "") {  (flutterResult) in
                
                
                if (flutterResult is FlutterError) {
                    if let res = flutterResult as? FlutterError{
                        NSLog("Sharpsell Error: getMoEngageCompanyId - Error Code : \(String(describing: res.code)) and Error Messaoge : \(String(describing: res.message))")
                        onFailure(res.message ?? "Flutter Error", SharpSellError.flutterError)
                        
                    }else {
                        debugPrint("Error:\(flutterResult ?? "")")
                    }
                }
                
                if FlutterMethodNotImplemented.isEqual(flutterResult){
                    
                    NSLog("Sharpsell Error: getMoEngageCompanyId - Method \(FlutterMethods.getMoEngageCompanyId.rawValue) is not implemented in Sharpsell SDK")
                    
                    onFailure("Flutter method not implemented", SharpSellError.flutterMethodNotImplemented)
                    return
                } else {
                    print("*************** Flutter Result For getMoEngageCompanyId *********************")
                    print(flutterResult)
                    print("*************** Flutter Result For getMoEngageCompanyId *********************")
                    onSucess(flutterResult as! String)
                    //                    //If sharpsell return 1 then it is sharpsell notification
                    //                    let isSharpsellNotifi = "\(flutterResult ?? 1)"
                    //                    if isSharpsellNotifi == "1"{
                    //                        onSucess(flutterResult)
                    //                    } else {
                    //                        onSucess(false)
                    //                        NSLog("Sharpsell: Not a sharpsell notification")
                    //                    }
                }
            }
            
        }catch (SharpSellError.flutterEngineFailure){
            NSLog("Sharpsell Error: isSharpsellNotification - Flutter Engine Not Available")
        } catch {
            NSLog("Sharpsell Error: isSharpsellNotification - Flutter Engine Not Available")
        }
    }
    
    /// Use this function to handle the sharpsell notification
    /// - Parameters:
    ///   - onSuccess: On success, sharpsell notification will be shown by sharpsell sdk
    ///   - onFailure: Failure closure will be called incase of any failure
    ///   - message: Flutter error message
    ///   - errorType: Passing the smartSellError enum by using this you check the type of error
    public func showNotification(notificationPayLoad: [AnyHashable: Any],
                                 onSucess: @escaping () -> (),
                                 onFailure: @escaping (_ message: String,
                                                       _ errorType: SharpSellError) -> ()){
        do {
            let flutterMethodChannel = try getFlutterMethodChannel()
            NSLog("Sharpsell: showNotification - Calling showNotification flutter invoke method")
            if let theJSONData = try?  JSONSerialization.data(
                withJSONObject: notificationPayLoad,
                options:.prettyPrinted),
               
                let notificationPayloadInString = String(data: theJSONData,
                                                         encoding: String.Encoding.ascii) {
                flutterMethodChannel.invokeMethod(FlutterMethods.showNotification.rawValue,
                                                  arguments: notificationPayloadInString) {  (flutterResult) in
                    
                    if (flutterResult is FlutterError) {
                        if let res = flutterResult as? FlutterError{
                            NSLog("Sharpsell Error: showNotification - Error Code : \(String(describing: res.code)) and Error Messaoge : \(String(describing: res.message))")
                            
                            onFailure(res.message ?? "Flutter Error", SharpSellError.flutterError)
                            
                        }else {
                            debugPrint("Error:\(flutterResult ?? "")")
                        }
                    }
                    
                    if FlutterMethodNotImplemented.isEqual(flutterResult){
                        
                        NSLog("Sharpsell Error: showNotification - Method \(FlutterMethods.open.rawValue) is not implemented in Sharpsell SDK")
                        
                        onFailure("Flutter method not implemented", SharpSellError.flutterMethodNotImplemented)
                        return
                    } else {
                        NSLog("Sharpsell: Notification triggred successful")
                        onSucess()
                    }
                }
            }
            
        }catch (SharpSellError.flutterEngineFailure){
            NSLog("Sharpsell Error: showNotification - Flutter Engine Not Available")
        } catch {
            NSLog("Sharpsell Error: showNotification - Flutter Engine Not Available")
        }
    }
    
    /// Use this function to check the recived notification is from sharpsell or not
    /// - Parameters:
    ///   - onSuccess: On success, if the notification is sharpsell then sharpsell notification will be shown
    ///   - onFailure: Failure closure will be called incase of any failure
    ///   - message: Flutter error message
    ///   - errorType: Passing the smartSellError enum by using this you check the type of error
    public func isSharpsellNotification(notificationPayLoad: [AnyHashable: Any],
                                        onSucess: @escaping (_ result: Bool) -> (),
                                        onFailure: @escaping (_ message: String,
                                                              _ errorType: SharpSellError) -> ()){
        do {
            let flutterMethodChannel = try getFlutterMethodChannel()
            NSLog("Sharpsell: isSharpsellNotification - Calling showNotification flutter invoke method")
            
            
            //Convert json to String
            if let theJSONData = try?  JSONSerialization.data(
                withJSONObject: notificationPayLoad,
                options:.prettyPrinted),
               //Convert Dict to json
               let notificationPayloadInString = String(data: theJSONData,
                                                        encoding: String.Encoding.ascii) {
                flutterMethodChannel.invokeMethod(FlutterMethods.isSharpsellNotification.rawValue,
                                                  arguments: notificationPayloadInString) {  (flutterResult) in
                    
                    
                    if (flutterResult is FlutterError) {
                        if let res = flutterResult as? FlutterError{
                            NSLog("Sharpsell Error: isSharpsellNotification - Error Code : \(String(describing: res.code)) and Error Messaoge : \(String(describing: res.message))")
                            onFailure(res.message ?? "Flutter Error", SharpSellError.flutterError)
                            
                        }else {
                            debugPrint("Error:\(flutterResult ?? "")")
                        }
                    }
                    
                    if FlutterMethodNotImplemented.isEqual(flutterResult){
                        
                        NSLog("Sharpsell Error: isSharpsellNotification - Method \(FlutterMethods.open.rawValue) is not implemented in Sharpsell SDK")
                        
                        onFailure("Flutter method not implemented", SharpSellError.flutterMethodNotImplemented)
                        return
                    } else {
                        //If sharpsell return 1 then it is sharpsell notification
                        let isSharpsellNotifi = "\(flutterResult ?? 1)"
                        if isSharpsellNotifi == "1"{
                            onSucess(true)
                        } else {
                            onSucess(false)
                            NSLog("Sharpsell: Not a sharpsell notification")
                        }
                    }
                }
            } else {
                NSLog("Sharpsell Error: isSharpsellNotification - Notification payload conversion og string error")
            }
        }catch (SharpSellError.flutterEngineFailure){
            NSLog("Sharpsell Error: isSharpsellNotification - Flutter Engine Not Available")
        } catch {
            NSLog("Sharpsell Error: isSharpsellNotification - Flutter Engine Not Available")
        }
    }
    
    /// Opens the sharpsell notification and navigate to proper sharpsell screen based on the notification
    /// - Parameters:
    ///   - onSuccess: Navigating the user to appropirate sharpsell screen
    ///   - onFailure: Parent app landing screen will be shown
    ///   - message: Flutter error message
    ///   - errorType: Passing the smartSellError enum by using this you check the type of error
    public func handleNotificationRedirection(notificationData: [AnyHashable: Any],
                                              onSucess: @escaping (_ notificationData: String) -> (),
                                              onFailure: @escaping (_ message: String,_ errorType: SharpSellError) -> ()){
        do {
            let flutterMethodChannel = try getFlutterMethodChannel()
            NSLog("Sharpsell : Calling handleNotificationRedirection flutter invoke method")
            
            //Convert json to String
            if let theJSONData = try?  JSONSerialization.data(
                withJSONObject: notificationData,
                options:.prettyPrinted),
               //Convert Dict to json
               let notificationDataInString = String(data: theJSONData,
                                                     encoding: String.Encoding.ascii) {
                
                flutterMethodChannel.invokeMethod(FlutterMethods.handleNotificationRedirection.rawValue,
                                                  arguments: notificationDataInString) {  (flutterResult) in
                    
                    if (flutterResult is FlutterError) {
                        if let res = flutterResult as? FlutterError{
                            NSLog("Sharpsell Error: handleNotificationRedirection - Error Code : \(String(describing: res.code)) and Error Messaoge : \(String(describing: res.message))")
                            onFailure(res.message ?? "Flutter Error", SharpSellError.flutterError)
                        }else {
                            NSLog("Sharpsell Error: handleNotificationRedirection - Flutter Error: UnKnown")
                        }
                    }
                    
                    if FlutterMethodNotImplemented.isEqual(flutterResult){
                        NSLog("Sharpsell Error: handleNotificationRedirection - Method \(FlutterMethods.open.rawValue) is not implemented in Sharpsell SDK")
                        onFailure("Flutter method not implemented", SharpSellError.flutterMethodNotImplemented)
                        return
                    } else {
                        onSucess(flutterResult as! String)
                    }
                }
            } else {
                NSLog("Sharpsell Error: handleNotificationRedirection - Arguments payload conversion of string error")
            }
            
        } catch (SharpSellError.flutterEngineFailure){
            NSLog("Sharpsell Error: handleNotificationRedirection - Flutter Engine Not Available")
        } catch {
            NSLog("Sharpsell Error: handleNotificationRedirection - Flutter Engine Not Available")
        }
    }
    
    /// Use this function to clear the smartsell data before logout or based on your usecase
    /// - Parameters:
    ///   - onSuccess: Success colsure will be called on succesfully Clearing the smartsell data
    ///   - onFailure: Failure closure will be called incase of any failure
    ///   - message: Flutter error message
    ///   - errorType: Passing the smartSellError enum by using this you check the type of error
    public func clearData(onSucess: @escaping () -> (),
                          onFailure: @escaping (_ message: String,_ errorType: SharpSellError) -> ()){
        do {
            let flutterMethodChannel = try getFlutterMethodChannel()
            NSLog("Sharpsell: clearData - Calling ClearData flutter invoke method")
            flutterMethodChannel.invokeMethod(FlutterMethods.clearData.rawValue,
                                              arguments: nil) {  (flutterResult) in
                
                if (flutterResult is FlutterError) {
                    if let res = flutterResult as? FlutterError{
                        NSLog("Sharpsell Error: clearData - Error Code : \(String(describing: res.code)) and Error Messaoge : \(String(describing: res.message))")
                        onFailure(res.message ?? "Flutter Error", SharpSellError.flutterError)
                        
                    }else {
                        debugPrint("Error:\(flutterResult ?? "")")
                    }
                }
                
                if FlutterMethodNotImplemented.isEqual(flutterResult){
                    
                    NSLog("Sharpsell Error: clearData - Method \(FlutterMethods.open.rawValue) is not implemented in Sharpsell SDK")
                    
                    onFailure("Flutter method not implemented", SharpSellError.flutterMethodNotImplemented)
                    return
                } else {
                    onSucess()
                }
            }
        }catch (SharpSellError.flutterEngineFailure){
            NSLog("Sharpsell Error: clearData - Flutter Engine Not Available")
        } catch {
            NSLog("Sharpsell Error: clearData - Flutter Engine Not Available")
        }
    }
    
    /// Enable Logs for the sharpsell SDK which can be seen in the console,
    /// Note - Don't enable this in production app
    /// - Parameters:
    ///   - onSuccess: Success colsure will be called on succesfuly launching the flutter screen
    ///   - flutterViewController: On succeful invoke call, flutter view controller will be sent back. Use this to show the flutter screen in you app
    ///   - onFailure: Failure closure will be called incase of any failure
    ///   - message: Flutter error message
    ///   - errorType: Passing the smartSellError enum by using this you check the type of error
    public func enableLogs(forProd: Bool,
                           onSucess: @escaping (_ flutterViewController: UIViewController) -> (),
                           onFailure: @escaping (_ message: String,_ errorType: SharpSellError) -> ()){
        do {
            let flutterMethodChannel = try getFlutterMethodChannel()
            NSLog("Sharpsell : Calling enableLogs flutter invoke method")
            
            
            flutterMethodChannel.invokeMethod(FlutterMethods.enableLogs.rawValue,
                                              arguments: forProd) {  (flutterResult) in
                
                if (flutterResult is FlutterError) {
                    if let res = flutterResult as? FlutterError{
                        NSLog("Sharpsell Error: enableLogs - Error Code : \(String(describing: res.code)) and Error Messaoge : \(String(describing: res.message))")
                        onFailure(res.message ?? "Flutter Error", SharpSellError.flutterError)
                    }else {
                        NSLog("Sharpsell Error: enableLogs - Flutter Error: UnKnown")
                    }
                }
                
                if FlutterMethodNotImplemented.isEqual(flutterResult){
                    NSLog("Sharpsell Error: enableLogs - Method \(FlutterMethods.enableLogs.rawValue) is not implemented in Sharpsell SDK")
                    onFailure("Flutter method not implemented", SharpSellError.flutterMethodNotImplemented)
                    return
                } else {
                    // Method channel call sucess
                    do {
                        let flutterViewController = try getFlutterViewController()
                        onSucess(flutterViewController)
                    } catch (SharpSellError.flutterEngineFailure){
                        NSLog("Sharpsell Error: enableLogs - Failed to get the FlutterVC due to flutterEngineFailure")
                    } catch {
                        NSLog("Sharpsell Error: enableLogs - Failed to get the FlutterVC")
                    }
                    
                }
            }
        } catch (SharpSellError.flutterEngineFailure){
            NSLog("Sharpsell Error: enableLogs - Flutter Engine Not Available")
        } catch {
            NSLog("Sharpsell Error: enableLogs - Flutter Engine Not Available")
        }
    }
}

//MARK: Notification Handlers
extension SharpSellWrapper{
    
    public func setPushTokenWhenDidRegisterForRemoteNotifications(with deviceToken: Data){
        NSLog("Sharpsell SDK:  Recived Device Token and shared the same ✅")
        //Sending the device token to mo engage to supprt mo engage push notification
        MoEngageSDKMessaging.sharedInstance.setPushToken(deviceToken)
    }
    
    public func setNotificationDataWhenDidReceive(_ center: UNUserNotificationCenter, _ response: UNNotificationResponse){
        NSLog("Sharpsell SDK:  on notification didReceive and shared the same ✅")
        //Sending the notification details to mo engage to support mo engage push notification
        MoEngageSDKMessaging.sharedInstance.userNotificationCenter(center, didReceive: response)
    }
    
    public func setNotificationDataWhenDidReceiveRemoteNotification(_ application: UIApplication, _ userInfo: [AnyHashable : Any]){
        NSLog("Sharpsell SDK:  on notification didReceiveRemoteNotification and shared the same ✅")
        //Sending the notification details to mo engage to support mo engage push notification
        MoEngageSDKMessaging.sharedInstance.didReceieveNotification(inApplication: application, withInfo: userInfo)
    }
}

//MARK: Sharpsell helper functions
extension SharpSellWrapper{
    /// Converts Dictionary to string
    /// - Parameters:
    ///   - dict: Dictinory of [String:Any] which needs to be converted as string
    public func convertJsonToString(dict: [String: Any]) -> String?{
        if let theJSONData = try?  JSONSerialization.data(
            withJSONObject: dict,
            options:.prettyPrinted),
           //Convert Dict to json
           let dataInString = String(data: theJSONData,
                                     encoding: String.Encoding.ascii) {
            return dataInString
            
        } else {
            NSLog("Sharpsell Error: - Json to string conversion error")
            return nil
        }
    }
    
    /// Gets the top most view controller of the app which is available
    /// - Parameters:
    ///   - dict: Dictinory of [String:Any] which needs to be converted as string
    public func getTopMostViewController(onSucess: @escaping (_ topMostViewController: UIViewController) -> (),
                                         onFailure: @escaping () -> ()){
        let keyWindow = UIApplication.shared.windows.filter {$0.isKeyWindow}.first
        if var topController = keyWindow?.rootViewController {
            while let presentedViewController = topController.presentedViewController {
                topController = presentedViewController
            }
            onSucess(topController)
            
        } else {
            NSLog("Sharpsell Error: - Failed to get top most view controller")
            onFailure()
        }
        
    }
}


extension FlutterViewController{
    open override var supportedInterfaceOrientations: UIInterfaceOrientationMask { return [.portrait,.landscapeRight,.landscapeLeft] }
}

